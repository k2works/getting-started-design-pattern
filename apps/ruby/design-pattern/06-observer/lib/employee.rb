# frozen_string_literal: true

require "observer"

# 従業員クラス（Observer パターン - Subject）
#
# Observable モジュールを include し、
# 給与やタイトルの変更をオブザーバーに通知する。
class Employee
  include Observable

  attr_reader :name, :title, :salary

  def initialize(name, title, salary)
    @name = name
    @title = title
    @salary = salary
  end

  def salary=(new_salary)
    @salary = new_salary
    changed
    notify_observers(self)
  end

  def title=(new_title)
    @title = new_title
    changed
    notify_observers(self)
  end
end
