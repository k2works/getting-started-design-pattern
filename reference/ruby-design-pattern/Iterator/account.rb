#
# == 口座クラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class Account
  attr_accessor :name, :balance

  def initialize(name, balance)
    @name = name
    @balance = balance
  end

  def <=>(other)
    balance <=> other.balance
  end
end
