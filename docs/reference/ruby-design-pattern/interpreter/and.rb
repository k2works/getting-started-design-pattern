require_relative 'expression'
#
# == Andクラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class And < Expression
  def initialize(expression1, expression2)
    @expression1 = expression1
    @expression2 = expression2
  end

  def evaluate(dir)
    result1 = @expression1.evaluate(dir)
    result2 = @expression2.evaluate(dir)
    (result1 & result2).sort.uniq
  end
end
