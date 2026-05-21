require_relative "test_helper"

class InterpreterTest < Minitest::Test
  def setup
    @test_dir = Dir.mktmpdir("interpreter_test")
    File.write(File.join(@test_dir, "big.txt"), "x" * 200)
    File.write(File.join(@test_dir, "small.txt"), "x" * 5)
    File.write(File.join(@test_dir, "data.csv"), "a,b,c\n1,2,3\n")
    File.write(File.join(@test_dir, "readme.md"), "# README")
  end

  def teardown
    FileUtils.rm_rf(@test_dir)
  end

  def test_all_returns_every_file
    result = All.new.evaluate(@test_dir)
    assert_equal 4, result.size
  end

  def test_filename_matches_pattern
    result = FileName.new("*.txt").evaluate(@test_dir)
    basenames = result.map { |file| File.basename(file) }

    assert_includes basenames, "big.txt"
    assert_includes basenames, "small.txt"
    refute_includes basenames, "data.csv"
  end

  def test_and_combines_expressions
    expr = And.new(FileName.new("*.txt"), Bigger.new(100))
    result = expr.evaluate(@test_dir)
    basenames = result.map { |file| File.basename(file) }

    assert_includes basenames, "big.txt"
    refute_includes basenames, "small.txt"
  end

  def test_not_negates_expression
    expr = Not.new(FileName.new("*.txt"))
    result = expr.evaluate(@test_dir)
    basenames = result.map { |file| File.basename(file) }

    assert_includes basenames, "data.csv"
    refute_includes basenames, "big.txt"
  end
end
