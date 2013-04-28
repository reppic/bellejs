require "rbelly" # javascript parser

class BelleTranspiler

  BELLEJS_NODE_CLASSES = [ RBelly::Nodes::ImportNode ]
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
    if bellejs_statement.class == RBelly::Nodes::ImportNode
        process_import bellejs_statement
    else
      bellejs_statement
    end
  end

  def process_import(import_statement)
     file_name = @local_dir + "/" + import_statement.value.value.gsub("\"", '').gsub("\'", '')
     ast = @parser.parse File.read(file_name)
     replace_bellejs ast
  end

  def print_tree(tree)
    tree.each do |node|
      puts node.value
    end
  end

  def print_result(tree)
    puts tree.to_ecma
  end


end