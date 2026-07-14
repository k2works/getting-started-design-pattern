import munit.FunSuite

class ObserverSuite extends FunSuite:
  test("給与変更時にオブザーバーに通知する") {
    val employee = Employee("田中", 50000)
    val payroll = Payroll()
    employee.addObserver(payroll)
    employee.salary = 60000

    assert(payroll.lastEmployee.isDefined, payroll.lastEmployee)
  }
  test("オブサーバーを削除できる") {
    val employee = Employee("鈴木", 30000)
    val payroll = Payroll()
    employee.addObserver(payroll)
    employee.removeObserver(payroll)
    employee.salary = 35000

    assert(payroll.lastEmployee.isEmpty, payroll.lastEmployee)
  }
