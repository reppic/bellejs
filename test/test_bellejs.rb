require 'test/unit'
require 'bellejs'
require 'rbelly'

class TestBellejs < Test::Unit::TestCase

  TEST_FILE_DIRECTORY = './test/test_files/'
  SIMPLE_FILE_PATH = TEST_FILE_DIRECTORY + 'simple_javascript.bellejs'

  def test_file_read
    # valid file
    file_path = TEST_FILE_DIRECTORY + 'simple_javascript.bellejs'
    bellejs = Bellejs.new(file_path)
    assert_equal bellejs.instance_variable_get(:@file_contents), File.read(file_path)

    # file doesn't exist
    assert_raise IOError do
      bellejs = Bellejs.new(TEST_FILE_DIRECTORY + '/non-existant-dir/fake.bellejs')
    end

    # invalid file type
    assert_raise IOError do
      bellejs = Bellejs.new(TEST_FILE_DIRECTORY + 'cc.png')
    end

  end

  def test_output_path
    # no output specified
    bellejs = Bellejs.new(SIMPLE_FILE_PATH)
    assert_equal bellejs.instance_variable_get(:@output_path), "./test/test_files/simple_javascript.js"

    # output is a directory
    bellejs = Bellejs.new(SIMPLE_FILE_PATH, TEST_FILE_DIRECTORY)
    assert_equal bellejs.instance_variable_get(:@output_path), "./test/test_files/simple_javascript.js"

    # output is just a .js file
    bellejs = Bellejs.new(SIMPLE_FILE_PATH, "test_file_NaME.js")
    assert_equal bellejs.instance_variable_get(:@output_path), "./test/test_files/test_file_NaME.js"

    # output is a .js file with a directory
    bellejs = Bellejs.new(SIMPLE_FILE_PATH, "./test/test_files/subdir/test_file_NaME.js")
    assert_equal bellejs.instance_variable_get(:@output_path), "./test/test_files/subdir/test_file_NaME.js"

    # output is invalid
    assert_raise ArgumentError do
      bellejs = Bellejs.new(SIMPLE_FILE_PATH, "./badFile.png")
    end

  end

  def test_file_write
    # output is a .js file with an existing directory
    bellejs = Bellejs.new(SIMPLE_FILE_PATH, "./test/test_files/subdir/output_test.js")
    assert_equal File.read("./test/test_files/subdir/output_test.js"), RBelly::Parser.new.parse(File.read(SIMPLE_FILE_PATH)).to_ecma

    #output to a non-existant folder
    random_folder_name = Random.new.rand(0...99999).to_s
    bellejs = Bellejs.new(SIMPLE_FILE_PATH, "./test/test_files/subdir/#{random_folder_name}/output_test2.js")
    assert_equal File.read("./test/test_files/subdir/#{random_folder_name}/output_test2.js"), RBelly::Parser.new.parse(File.read(SIMPLE_FILE_PATH)).to_ecma

  end


end