require 'minitest/autorun'
require 'find'
require_relative 'parser'

describe All do
  # テストディレクリにファイルが存在する
  it 'should be exist file in directory.' do
    all = All.new
    results = all.evaluate('./test_dir')
    results.wont_be_empty
  end
end

describe FileName do
  # テストディレクリにファイルが存在する
  it 'should be exist file in directory.' do
    files = FileName.new('test.*')
    results = files.evaluate('./test_dir')
    results.wont_be_empty
  end
end

describe Bigger do
  # テストディレクリにファイルが存在する
  it 'should be exist file in directory.' do
    files = Bigger.new(100)
    results = files.evaluate('./test_dir')
    results.wont_be_empty
  end
end

describe Writable do
  # テストディレクリにファイルが存在する
  it 'should be exist file in directory.' do
    files = Writable.new
    results = files.evaluate('./test_dir')
    results.wont_be_empty
  end
end

describe Not do
  # テストディレクリにファイルが存在しない
  it 'should not be exist file in directory.' do
    expr_not_writable = Not.new(Writable.new)
    readonly_files = expr_not_writable.evaluate('./test_dir')
    readonly_files.must_be_empty
  end

  # テストディレクリにファイルが存在する
  it 'should be exist file in directory.' do
    expr_not_writable = Not.new(Bigger.new(100))
    readonly_files = expr_not_writable.evaluate('./test_dir')
    readonly_files.wont_be_empty
  end

  # テストディレクリにファイルが存在しない
  it 'should not be exist file in directory.' do
    expr_not_writable = Not.new(FileName.new('*.txt'))
    readonly_files = expr_not_writable.evaluate('./test_dir')
    readonly_files.must_be_empty
  end
end

describe Or do
  # テストディレクリにファイルが存在する
  it 'should be exist file in directory.' do
    big_or_txt_expr = Or.new(Bigger.new(1000), FileName.new('*.txt'))
    big_or_txt = big_or_txt_expr.evaluate('./test_dir')
    big_or_txt.wont_be_empty
  end
end

describe And do
  # テストディレクリにファイルが存在しない
  it 'should not be exist file in directory.' do
    complex_expression = And.new(
                                And.new(Bigger.new(0),
                                        FileName.new('*.txt')),
                                Not.new(Writable.new))
    complex_expression.evaluate('./test_dir').must_be_empty
  end
end

describe Parser do
  # テストディレクリにファイルが存在する
  it 'should be exist file in directory.' do
    parser = Parser.new "and (and(bigger 10) (filename *.txt)) writable"
    ast = parser.expression
    ast.evaluate('./test_dir').wont_be_empty
  end
end

describe Expression do
  # テストディレクリにファイルが存在する
  it 'should be exist file in directory.' do
    big_or_txt_expr = (Bigger.new(2000) & Not.new(Writable.new)) | FileName.new("*.txt")
    big_or_txt = big_or_txt_expr.evaluate('./test_dir')
    big_or_txt.wont_be_empty
  end

  # テストディレクリにファイルが存在する
  it 'should be exist file in directory.' do
    big_or_txt_expr = (bigger(2000) & except(writable)) | file_name("*.txt")
    big_or_txt = big_or_txt_expr.evaluate('./test_dir')
    big_or_txt.wont_be_empty
  end
end