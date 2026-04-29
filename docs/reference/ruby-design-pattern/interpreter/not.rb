require_relative 'expression'
require_relative 'all'
#
# == Notクラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class Not < Expression
  def initialize(expression)
    @expression = expression
  end

  def evaluate(dir)
    All.new.evaluate(dir) - @expression.evaluate(dir)
  end
end
