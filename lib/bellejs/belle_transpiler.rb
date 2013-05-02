require "rbelly" # javascript parser

class BelleTranspiler

  BELLEJS_NODE_CLASSES = [RBelly::Nodes::ImportNode, RBelly::Nodes::ClassNode, RBelly::Nodes::ExtendsNode, RBelly::Nodes::BellejsVarStatementNode, RBelly::Nodes::BellejsFuncStatementNode]
  LINE_END = RBelly::Nodes::ExpressionStatementNode

  def initialize(file_contents, local_dir)
    @local_dir = local_dir
    @raw_file_contents = file_contents
    @parser = RBelly::Parser.new
  end

  def transpile
    ast = @parser.parse @raw_file_contents
    pure_js_tree = replace_bellejs(ast)
    pure_js_tree.to_ecma
  end

  private

  def replace_bellejs(parse_tree)
    parse_tree.each do |node|
      if node.class == RBelly::Nodes::SourceElementsNode
        i = 0
        source_array = node.value
        source_array.each do |element|
          if BELLEJS_NODE_CLASSES.include?(element.class)
            node.value[i] =evaluate(node.value[i])
          end
          i+=1
        end
      end
    end
    parse_tree
  end

  def evaluate(bellejs_statement)
    case bellejs_statement
      when RBelly::Nodes::ImportNode
        process_import bellejs_statement
      when RBelly::Nodes::ClassNode
        process_class bellejs_statement
      when RBelly::Nodes::BellejsVarStatementNode
        process_var_statement bellejs_statement
      when RBelly::Nodes::BellejsFuncStatementNode
        process_function bellejs_statement
      else
        bellejs_statement
    end
  end

  def process_import(import_statement)
    file_name = @local_dir + "/" + import_statement.value.value.gsub("\"", '').gsub("\'", '')
    ast = @parser.parse File.read(file_name)
    replace_bellejs ast
  end

  def process_class(class_statement)
    compiled_class = "function #{class_statement.value}() #{class_statement.class_body.to_ecma}"
    unless class_statement.parent.nil?
       inheritance_prototype = process_extends(class_statement.value, class_statement.parent)
       compiled_class = compiled_class + "\n" + inheritance_prototype
    end
    @parser.parse compiled_class
  end

  def process_extends(class_name, parent)
     parent_name = parent.parent
    "#{class_name}.prototype = new #{parent_name}();"
  end

  def process_var_statement(var_statement)
    visibility = var_statement.value
    js_decl_statement = var_statement.var_statement.value.first
    var_name = js_decl_statement.name
    var_value = (js_decl_statement.value == nil ? nil : js_decl_statement.value.value.value)
    if var_value.class == RBelly::Nodes::ResolveNode
       #object declaration
      var_value = "new " + var_value.value.to_s
    end
    var_value = js_decl_statement.value.value.to_ecma if var_value.class == Array
    var_value_statement = (var_value.nil? ? ";" : " = " + var_value.to_s + ";")
    is_constant = js_decl_statement.constant?

    if visibility == 'public'
      compiled_string =  "this.#{var_name}#{var_value_statement}"
    else
      if visibility == 'private'
          compiled_string = (is_constant ? "const" : "var") + " #{var_name}#{var_value_statement}"
      else
        raise "invalid variable declaration"
      end
    end
    @parser.parse compiled_string
  end

  def process_function(function_statement)
    visibility = function_statement.value
    func_name = function_statement.func_statement.value
    func_body = function_statement.func_statement.function_body.to_ecma
    func_args = function_statement.func_statement.arguments
    func_args_string = String.new
    unless func_args.nil?
      func_args.each do |arg|
        func_args_string += arg.value.to_s + (arg != func_args.last ? ", " : "")
      end
    end
    if visibility == 'public'
      compiled_string =  "this.#{func_name} = function(#{func_args_string})#{func_body}"
    else
      if visibility == 'private'
        compiled_string = "function #{func_name}(#{func_args_string})#{func_body}"
      else
        raise "invalid function declaration"
      end
    end
    @parser.parse compiled_string
  end

  # debug helpers:

  def print_tree(tree)
    tree.each do |node|
      puts node.value
    end
  end

  def print_result(tree)
    puts tree.to_ecma
  end


end