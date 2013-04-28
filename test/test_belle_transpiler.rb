require 'test/unit'
require 'bellejs/belle_transpiler'

class TestBelleTranspiler < Test::Unit::TestCase

  TEST_FILE_DIRECTORY = './test/test_files/'

  def test_import
    # only contains an import statement that imports the simple_javascript.js file
    file_path = TEST_FILE_DIRECTORY + 'import_test.bellejs'
    bellejs = Bellejs.new(file_path)
    assert_equal File.read("#{TEST_FILE_DIRECTORY}import_test.js"), File.read("#{TEST_FILE_DIRECTORY}simple_javascript.js")
  end

  def test_import_recursive
    # import a file with an import statement that imports the simple_javascript.js file
    file_path = TEST_FILE_DIRECTORY + 'recursive_import_test.bellejs'
    bellejs = Bellejs.new(file_path)
    assert_equal File.read("#{TEST_FILE_DIRECTORY}recursive_import_test.js"), File.read("#{TEST_FILE_DIRECTORY}simple_javascript.js")
  end

  def test_double_import_recursive
    # 2 import statements one recursive both import the simple_javascript.js file... woa
    file_path = TEST_FILE_DIRECTORY + 'recursive_double_import.bellejs'
    bellejs = Bellejs.new(file_path)
    assert_equal File.read("#{TEST_FILE_DIRECTORY}recursive_double_import.js"), (File.read("#{TEST_FILE_DIRECTORY}simple_javascript.js")+"\n"+File.read("#{TEST_FILE_DIRECTORY}simple_javascript.js"))
  end

end