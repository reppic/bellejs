require 'test/unit'
require 'bellejs/belle_transpiler'

class TestBelleTranspilerClass < Test::Unit::TestCase

  TEST_FILE_DIRECTORY = './test/test_files/'

  def test_simple_class
    # simple class conversion
    file_path = TEST_FILE_DIRECTORY + 'class_test.bellejs'
    bellejs = Bellejs.new(file_path)
    assert_equal File.read("#{TEST_FILE_DIRECTORY}class_test.js"), File.read("#{TEST_FILE_DIRECTORY}non_complied_class_test.js")
  end

  def test_extends_statement
    file_path = TEST_FILE_DIRECTORY + 'extends_test.bellejs'
    bellejs = Bellejs.new(file_path)
    result = File.read("#{TEST_FILE_DIRECTORY}extends_test.js")
    comparison = File.read("#{TEST_FILE_DIRECTORY}non_compiled_extends_test.js")
    assert_equal result, comparison
  end

  def test_private_public_statement
    file_path = TEST_FILE_DIRECTORY + 'private_public_test.bellejs'
    bellejs = Bellejs.new(file_path)
    result = File.read("#{TEST_FILE_DIRECTORY}private_public_test.js")
    comparison = File.read("#{TEST_FILE_DIRECTORY}noncompiled_private_public_test.js")
    assert_equal result, comparison
  end

end