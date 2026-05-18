require_relative "test_helper"
require_relative "../lib/array_iterator"
require_relative "../lib/account"
require_relative "../lib/portfolio"

class IteratorTest < Minitest::Test
  def test_external_iterator
    iterator = ArrayIterator.new([1, 2, 3])
    results = []

    while iterator.has_next?
      results << iterator.next_item
    end

    assert_equal [1, 2, 3], results
  end

  def test_account_is_comparable_by_balance
    ordinary = Account.new("普通預金", 100_000)
    time_deposit = Account.new("定期預金", 500_000)

    assert_operator ordinary, :<, time_deposit
  end

  def test_portfolio_sort
    portfolio = Portfolio.new
    portfolio.add_account(Account.new("定期預金", 500_000))
    portfolio.add_account(Account.new("普通預金", 100_000))

    sorted = portfolio.sort

    assert_equal "普通預金", sorted.first.name
  end
end
