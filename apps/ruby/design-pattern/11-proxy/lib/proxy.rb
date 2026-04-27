# frozen_string_literal: true

require "etc"

# 銀行口座（Real Subject）
class BankAccount
  attr_reader :balance

  def initialize(starting_balance = 0)
    @balance = starting_balance
  end

  def deposit(amount)
    @balance += amount
  end

  def withdraw(amount)
    @balance -= amount
  end
end

# 保護 Proxy
class AccountProtectionProxy
  def initialize(real_account, owner_name)
    @subject = real_account
    @owner_name = owner_name
  end

  def method_missing(name, *args)
    check_access
    @subject.send(name, *args)
  end

  def respond_to_missing?(name, include_private = false)
    @subject.respond_to?(name, include_private) || super
  end

  private

  def check_access
    if Etc.getlogin != @owner_name
      raise "Illegal access: #{Etc.getlogin} cannot access account."
    end
  end
end

# 仮想 Proxy（遅延初期化）
class VirtualAccountProxy
  def initialize(&creation_block)
    @creation_block = creation_block
  end

  def method_missing(name, *args)
    subject.send(name, *args)
  end

  def respond_to_missing?(name, include_private = false)
    subject.respond_to?(name, include_private) || super
  end

  private

  def subject
    @subject ||= @creation_block.call
  end
end
