require 'minitest/autorun'
require './bank_account'
require './bank_account_proxy'
require './account_protection_proxy'
require './virtual_account_proxy'
require './account_proxy'

describe BankAccount do
  # 銀行口座の残高は140になる
  it 'should be 140.' do
    account = BankAccount.new(100)
    account.deposit(50)
    account.withdraw(10)
    account.balance.must_equal 140
  end
end

describe BankAccountProxy do
  # 銀行口座の残高は140になる
  it 'should be 140.' do
    account = BankAccount.new(100)
    account = BankAccountProxy.new(account)
    account.deposit(50)
    account.withdraw(10)
    account.balance.must_equal 140
  end
end

describe AccountProtectionProxy do
  # 許可されていないユーザーは口座にアクセスできない
  it 'should protect access from illegal access.' do
    account = BankAccount.new(100)
    account = AccountProtectionProxy.new(account,'Illegal User')
    proc{account.deposit(50)}.must_raise RuntimeError
  end
end

describe VirtualAccountProxy do
  # 銀行口座の残高は140になる
  it 'should be 140.' do
    account = VirtualAccountProxy.new { BankAccount.new(100)}
    account.deposit(50)
    account.withdraw(10)
    account.balance.must_equal 140
  end
end

describe AccountProxy do
  # 銀行口座に操作を移譲する
  it 'should delegate method to Account.' do
    output =<<EOS
Delegating deposit message to subject.
Delegating withdraw message to subject.
Delegating balance message to subject.
account balance is now: 75
EOS
    ap = AccountProxy.new (BankAccount.new(100))
    proc {
      ap.deposit(25)
      ap.withdraw(50)
      puts("account balance is now: #{ap.balance}")
    }.must_output output
  end
end
