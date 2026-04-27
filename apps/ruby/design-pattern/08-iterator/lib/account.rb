# frozen_string_literal: true

# 口座クラス（Iterator パターン）
class Account
  attr_reader :name, :balance

  def initialize(name, balance)
    @name = name
    @balance = balance
  end

  def <=>(other)
    balance <=> other.balance
  end
end
