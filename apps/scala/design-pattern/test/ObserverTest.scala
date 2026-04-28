package designpattern.observer

class ObserverSuite extends munit.FunSuite:

  test("給与変更時にオブザーバーに通知する") {
    val employee = Employee("田中", 50000)
    val payroll  = Payroll()
    employee.addObserver(payroll)

    employee.salary = 60000

    assert(payroll.lastEmployee.isDefined)
    assertEquals(payroll.lastEmployee.get.name, "田中")
    assertEqualsDouble(payroll.lastEmployee.get.salary, 60000, 0.01)
  }

  test("複数のオブザーバーに通知する") {
    val employee = Employee("佐藤", 40000)
    val payroll  = Payroll()
    val taxMan   = TaxMan()
    employee.addObserver(payroll)
    employee.addObserver(taxMan)

    employee.salary = 45000

    assert(payroll.lastEmployee.isDefined)
    assert(taxMan.lastEmployee.isDefined)
  }

  test("オブザーバーを削除できる") {
    val employee = Employee("鈴木", 30000)
    val payroll  = Payroll()
    employee.addObserver(payroll)
    employee.removeObserver(payroll)

    employee.salary = 35000

    assert(payroll.lastEmployee.isEmpty)
  }
