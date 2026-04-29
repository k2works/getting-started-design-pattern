# frozen_string_literal: true

require_relative '../../test/test_helper'
require_relative '../lib/employee'
require_relative '../lib/payroll'
require_relative '../lib/tax_man'

class ObserverTest < Minitest::Test
  def setup
    @employee = Employee.new('田中太郎', 'エンジニア', 300_000)
    @payroll = Payroll.new
    @tax_man = TaxMan.new
  end

  def test_payroll_gets_notified_on_salary_change
    @employee.add_observer(@payroll)

    assert_output(/田中太郎 の給与が 350000 に変更されました/) do
      @employee.salary = 350_000
    end

    assert_equal '田中太郎 の給与が 350000 に変更されました', @payroll.last_notification
  end

  def test_multiple_observers_get_notified
    @employee.add_observer(@payroll)
    @employee.add_observer(@tax_man)

    assert_output(/田中太郎/) do
      @employee.salary = 400_000
    end

    assert_equal '田中太郎 の給与が 400000 に変更されました', @payroll.last_notification
    assert_equal '田中太郎 に新しい税金の請求書を送付します', @tax_man.last_notification
  end

  def test_observer_can_be_removed
    @employee.add_observer(@payroll)
    @employee.add_observer(@tax_man)
    @employee.delete_observer(@tax_man)

    assert_output(/給与/) do
      @employee.salary = 500_000
    end

    assert_nil @tax_man.last_notification
  end

  def test_title_change_notifies_observers
    @employee.add_observer(@payroll)

    assert_output(/田中太郎/) do
      @employee.title = 'シニアエンジニア'
    end
  end
end
