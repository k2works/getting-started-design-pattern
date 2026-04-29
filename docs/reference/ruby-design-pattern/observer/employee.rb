require 'observer'
#
# == 従業員クラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class Employee
  include Observable

  # 従業員名と住所が格納される
  attr_reader :name, :address
  # 役職と給料が格納される
  attr_accessor :title, :salary

  def initialize( name, title, salary)
    super()
    @name = name
    @title = title
    @salary = salary
    @title_changed = false
    @salary_changed = false
  end

  def salary=(new_salary)
    old_salary = @salary
    @salary = new_salary
    if old_salary != new_salary
      @salary_changed = true
    else
      @salary_changed = false
    end
  end

  def title=(new_title)
    old_title = @title
    @title = new_title
    if old_title != new_title
      @title_changed = true
    else
      @title_changed = false
    end
  end

  # @return [Boolean] true  通知された場合
  # @return [Boolean] false 通知されない場合
  def changes_complete
    if @salary_changed == true
      if @title_changed == true
        changed
        notify_observers(self)
        return true
      end
    end
    if @salary_changed == true
      if @title_changed == false
        return check_salary_title_table
      end
    end
    if @salary_changed == false
      if @title_changed == true
        return check_salary_title_table
      end
    end
  end

  private
  def check_salary_title_table
    case @title
      when 'Crane Operator'
        if @salary <= 50000
          changed
          notify_observers(self)
          true
        end
      when 'Vice President of Sales'
        if @salary > 50000
          changed
          notify_observers(self)
          true
        end
      else
        false
    end
  end
end