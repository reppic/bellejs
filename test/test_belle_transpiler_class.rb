require 'test/unit'
require 'bellejs/belle_transpiler'

class TestBelleTranspilerClass < Test::Unit::TestCase

  TEST_FILE_DIRECTORY = './test/test_files/'

  def simple_class_test
    puts "DINGIUSIW!"
    # simple class conversion
    file_path = TEST_FILE_DIRECTORY + 'class_test.bellejs'
    bellejs = Bellejs.new(file_path)
    #assert_equal File.read("#{TEST_FILE_DIRECTORY}class_test.js"), File.read("#{TEST_FILE_DIRECTORY}non_complied_class_test.js")
    assert_equal false, true
  end

end