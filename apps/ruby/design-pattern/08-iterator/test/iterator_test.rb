# frozen_string_literal: true

require_relative "../../test/test_helper"
require_relative "../lib/array_iterator"
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

  def test_portfolio_each
    portfolio = Portfolio.new
    portfolio.add_account(Account.new("普通預金", 100_000))
    portfolio.add_account(Account.new("定期預金", 500_000))

    names = portfolio.map(&:name)
    assert_equal ["普通預金", "定期預金"], names
  end

  def test_portfolio_sort
    portfolio = Portfolio.new
    portfolio.add_account(Account.new("定期預金", 500_000))
    portfolio.add_account(Account.new("普通預金", 100_000))

    sorted = portfolio.sort
    assert_equal "普通預金", sorted.first.name
    assert_equal "定期預金", sorted.last.name
  end

  def test_portfolio_select
    portfolio = Portfolio.new
    portfolio.add_account(Account.new("普通預金", 100_000))
    portfolio.add_account(Account.new("定期預金", 500_000))
    portfolio.add_account(Account.new("投資信託", 300_000))

    rich = portfolio.select { |a| a.balance >= 300_000 }
    assert_equal 2, rich.size
  end

  def test_portfolio_any
    portfolio = Portfolio.new
    portfolio.add_account(Account.new("普通預金", 100_000))

    assert portfolio.any? { |a| a.balance >= 100_000 }
    refute portfolio.any? { |a| a.balance >= 1_000_000 }
  end
end
