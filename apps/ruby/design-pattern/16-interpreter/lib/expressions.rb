require "find"

class Expression
end

class All < Expression
  def evaluate(dir)
    Find.find(dir).reject { |path| File.directory?(path) }
  end
end

class FileName < Expression
  def initialize(pattern)
    @pattern = pattern
  end

  def evaluate(dir)
    Find.find(dir).select do |path|
      !File.directory?(path) && File.fnmatch(@pattern, File.basename(path))
    end
  end
end

class Bigger < Expression
  def initialize(size)
    @size = size
  end

  def evaluate(dir)
    Find.find(dir).select do |path|
      !File.directory?(path) && File.size(path) > @size
    end
  end
end

class And < Expression
  def initialize(left, right)
    @left = left
    @right = right
  end

  def evaluate(dir)
    @left.evaluate(dir) & @right.evaluate(dir)
  end
end

class Or < Expression
  def initialize(left, right)
    @left = left
    @right = right
  end

  def evaluate(dir)
    (@left.evaluate(dir) + @right.evaluate(dir)).uniq
  end
end

class Not < Expression
  def initialize(expression)
    @expression = expression
  end

  def evaluate(dir)
    All.new.evaluate(dir) - @expression.evaluate(dir)
  end
end
