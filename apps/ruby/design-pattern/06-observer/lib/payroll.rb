# frozen_string_literal: true

# 給与計算オブザーバー
class Payroll
  attr_reader :last_notification

  def update(employee)
    @last_notification = "#{employee.name} の給与が #{employee.salary} に変更されました"
    puts(@last_notification)
  end
end
