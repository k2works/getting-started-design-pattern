# frozen_string_literal: true

require "find"

# 式の基底クラス
class Expression
  def |(other)
    Or.new(self, other)
  end

  def &(other)
    And.new(self, other)
  end
end

# すべてのファイルにマッチ
class All < Expression
  def evaluate(dir)
    results = []
    Find.find(dir) do |path|
      results << path unless File.directory?(path)
    end
    results
  end
end

# ファイル名パターンでマッチ
class FileName < Expression
  def initialize(pattern)
    @pattern = pattern
  end

  def evaluate(dir)
    results = []
    Find.find(dir) do |path|
      next if File.directory?(path)

      results << path if File.fnmatch(@pattern, File.basename(path))
    end
    results
  end
end

# サイズが指定バイト以上のファイル
class Bigger < Expression
  def initialize(size)
    @size = size
  end

  def evaluate(dir)
    results = []
    Find.find(dir) do |path|
      next if File.directory?(path)

      results << path if File.size(path) > @size
    end
    results
  end
end

# 書き込み可能なファイル
class Writable < Expression
  def evaluate(dir)
    results = []
    Find.find(dir) do |path|
      next if File.directory?(path)

      results << path if File.writable?(path)
    end
    results
  end
end

# AND 複合式
class And < Expression
  def initialize(left, right)
    @left = left
    @right = right
  end

  def evaluate(dir)
    @left.evaluate(dir) & @right.evaluate(dir)
  end
end

# OR 複合式
class Or < Expression
  def initialize(left, right)
    @left = left
    @right = right
  end

  def evaluate(dir)
    (@left.evaluate(dir) + @right.evaluate(dir)).uniq
  end
end

# NOT 式
class Not < Expression
  def initialize(expression)
    @expression = expression
  end

  def evaluate(dir)
    All.new.evaluate(dir) - @expression.evaluate(dir)
  end
end

# パーサー: テキストを AST に変換する
class Parser
  def initialize(text)
    @tokens = text.scan(/\(|\)|[^\s()]+/)
  end

  def parse
    parse_expression
  end

  private

  def parse_expression
    token = next_token
    case token
    when "and"
      And.new(parse_expression, parse_expression)
    when "or"
      Or.new(parse_expression, parse_expression)
    when "not"
      Not.new(parse_expression)
    when "bigger"
      Bigger.new(next_token.to_i)
    when "filename"
      FileName.new(next_token)
    when "writable"
      Writable.new
    when "all"
      All.new
    when "("
      expr = parse_expression
      expect(")")
      expr
    else
      raise "Unexpected token: #{token}"
    end
  end

  def next_token
    @tokens.shift
  end

  def expect(expected)
    token = next_token
    raise "Expected '#{expected}' but got '#{token}'" unless token == expected
  end
end

# DSL ヘルパーメソッド
def bigger(size)
  Bigger.new(size)
end

def file_name(pattern)
  FileName.new(pattern)
end

def writable
  Writable.new
end

def except(expression)
  Not.new(expression)
end
