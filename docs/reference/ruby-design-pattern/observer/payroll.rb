#
# == 経理部門クラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class Payroll
  def update( changed_employee )
    puts("#{changed_employee.name}のために小切手を切ります！")
    puts("彼の給料はいま#{changed_employee.salary}です！")
  end
end