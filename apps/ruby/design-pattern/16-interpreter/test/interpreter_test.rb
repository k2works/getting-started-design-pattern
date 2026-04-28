# frozen_string_literal: true

require_relative '../../test/test_helper'
require_relative '../lib/interpreter'
require 'fileutils'
require 'tmpdir'

class InterpreterTest < Minitest::Test
  def setup
    @test_dir = Dir.mktmpdir('interpreter_test')
    File.write(File.join(@test_dir, 'big.txt'), 'x' * 200)
    File.write(File.join(@test_dir, 'small.txt'), 'x' * 5)
    File.write(File.join(@test_dir, 'data.csv'), "a,b,c\n1,2,3\n")
    File.write(File.join(@test_dir, 'readme.md'), '# README')

    # 読み取り専用ファイル
    readonly_path = File.join(@test_dir, 'readonly.txt')
    File.write(readonly_path, 'readonly content')
    File.chmod(0o444, readonly_path)
  end

  def teardown
    FileUtils.rm_rf(@test_dir)
  end

  def test_all_returns_every_file
    result = All.new.evaluate(@test_dir)

    assert_equal 5, result.size
  end

  def test_filename_matches_pattern
    result = FileName.new('*.txt').evaluate(@test_dir)
    basenames = result.map { |f| File.basename(f) }

    assert_includes basenames, 'big.txt'
    assert_includes basenames, 'small.txt'
    assert_includes basenames, 'readonly.txt'
    refute_includes basenames, 'data.csv'
  end

  def test_bigger_filters_by_size
    result = Bigger.new(100).evaluate(@test_dir)
    basenames = result.map { |f| File.basename(f) }

    assert_includes basenames, 'big.txt'
    refute_includes basenames, 'small.txt'
  end

  def test_writable_filters_writable_files
    result = Writable.new.evaluate(@test_dir)
    basenames = result.map { |f| File.basename(f) }

    assert_includes basenames, 'big.txt'
    refute_includes basenames, 'readonly.txt'
  end

  def test_and_combines_expressions
    expr = And.new(FileName.new('*.txt'), Bigger.new(100))
    result = expr.evaluate(@test_dir)
    basenames = result.map { |f| File.basename(f) }

    assert_includes basenames, 'big.txt'
    refute_includes basenames, 'small.txt'
    refute_includes basenames, 'data.csv'
  end

  def test_or_combines_expressions
    expr = Or.new(FileName.new('*.csv'), FileName.new('*.md'))
    result = expr.evaluate(@test_dir)
    basenames = result.map { |f| File.basename(f) }

    assert_includes basenames, 'data.csv'
    assert_includes basenames, 'readme.md'
    assert_equal 2, basenames.size
  end

  def test_not_negates_expression
    expr = Not.new(FileName.new('*.txt'))
    result = expr.evaluate(@test_dir)
    basenames = result.map { |f| File.basename(f) }

    assert_includes basenames, 'data.csv'
    assert_includes basenames, 'readme.md'
    refute_includes basenames, 'big.txt'
  end

  def test_parser_with_and
    parser = Parser.new('and (bigger 100) (filename *.txt)')
    expr = parser.parse
    result = expr.evaluate(@test_dir)
    basenames = result.map { |f| File.basename(f) }

    assert_includes basenames, 'big.txt'
    refute_includes basenames, 'small.txt'
  end

  def test_parser_with_or
    parser = Parser.new('or (filename *.csv) (filename *.md)')
    expr = parser.parse
    result = expr.evaluate(@test_dir)
    basenames = result.map { |f| File.basename(f) }

    assert_includes basenames, 'data.csv'
    assert_includes basenames, 'readme.md'
  end

  def test_parser_with_not
    parser = Parser.new('not (filename *.txt)')
    expr = parser.parse
    result = expr.evaluate(@test_dir)
    basenames = result.map { |f| File.basename(f) }

    refute_includes basenames, 'big.txt'
    assert_includes basenames, 'data.csv'
  end

  def test_operator_dsl
    expr = (bigger(100) & except(writable)) | file_name('*.csv')
    result = expr.evaluate(@test_dir)
    basenames = result.map { |f| File.basename(f) }

    assert_includes basenames, 'data.csv'
  end

  def test_operator_pipe_creates_or
    expr = FileName.new('*.txt') | FileName.new('*.csv')

    assert_instance_of Or, expr
  end

  def test_operator_ampersand_creates_and
    expr = FileName.new('*.txt') & Bigger.new(100)

    assert_instance_of And, expr
  end
end

class InterpreterWithTestDirTest < Minitest::Test
  def test_evaluates_against_project_test_dir
    test_dir = File.expand_path('../test_dir', __dir__)
    return unless File.directory?(test_dir)

    result = FileName.new('*.txt').evaluate(test_dir)

    refute_empty result
    assert(result.all? { |f| f.end_with?('.txt') })
  end
end
