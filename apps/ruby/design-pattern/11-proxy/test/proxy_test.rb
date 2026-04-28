# frozen_string_literal: true

require_relative '../../test/test_helper'
require_relative '../lib/proxy'

class ProxyTest < Minitest::Test
  def test_bank_account_operations
    account = BankAccount.new(100)
    account.deposit(50)
    account.withdraw(10)
    assert_equal 140, account.balance
  end

  def test_protection_proxy_blocks_unauthorized
    account = BankAccount.new(100)
    proxy = AccountProtectionProxy.new(account, 'unauthorized_user')

    assert_raises(RuntimeError) { proxy.deposit(50) }
  end

  def test_protection_proxy_allows_authorized
    account = BankAccount.new(100)
    proxy = AccountProtectionProxy.new(account, Etc.getlogin)

    proxy.deposit(50)
    assert_equal 150, proxy.balance
  end

  def test_virtual_proxy_lazy_initialization
    initialized = false
    proxy = VirtualAccountProxy.new do
      initialized = true
      BankAccount.new(100)
    end

    refute initialized
    proxy.deposit(50)
    assert initialized
    assert_equal 150, proxy.balance
  end
end
