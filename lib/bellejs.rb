require "bellejs/version"
require 'bellejs/belle_transpiler'
require 'uglifier'

class Bellejs

  def initialize(input_file, output_file = nil, minify = false)
    @local_dir = File.dirname(input_file)
    @output_path = get_output_path(input_file, output_file)
    @file_contents = get_file_contents(input_file)
    @compiled_js = compile(@file_contents)
    uglify_js if minify
    write
  end

  private

  def get_output_path(input, output)
    if output.nil?
      File.dirname(input) + "/" + File.basename(input, ".bellejs") + ".js"
    else
      if File.directory?(output)
        output + (output[-1, 1] == "/" ? "" : "/") + File.basename(input, ".bellejs") + ".js"
      else
        raise ArgumentError, 'Output parameter is invalid.' unless output.downcase[-3, 3] == ".js"
        if File.basename(output) == output # no directory attached
          File.dirname(input) + "/" + output
        else
          output
        end
      end
    end
  end

  def get_file_contents(input)
    raise IOError, 'Input file does not exist.' unless File.exists?(input)
    raise IOError, 'Input file is an invalid format. Only .bellejs and .js files are allowed.' unless
        input.downcase[-8,8] == ".bellejs" or input.downcase[-3,3] == ".js"
    File.read(input)
  end

  def compile(file_contents)
    transpiler = BelleTranspiler.new(file_contents, @local_dir)
    transpiler.transpile # <-- where the magic happens
  end

  def uglify_js
    @compiled_js = Uglifier.compile(@compiled_js, :compress => {:unused => false, })
  end

  def write
    FileUtils.mkdir_p(File.dirname(@output_path))
    File.open(@output_path, 'w') { |file| file.write(@compiled_js) }
  end

end
