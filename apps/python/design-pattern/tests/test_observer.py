"""Observer パターンのテスト"""

from src.observer import Employee, Payroll, TaxMan


class TestEmployee:
    def test_従業員の初期状態(self):
        emp = Employee("田中", "エンジニア", 500000)
        assert emp.name == "田中"
        assert emp.title == "エンジニア"
        assert emp.salary == 500000

    def test_給与変更でオブザーバーに通知される(self):
        emp = Employee("田中", "エンジニア", 500000)
        payroll = Payroll()
        emp.add_observer(payroll)

        emp.salary = 600000
        assert "田中" in payroll.last_notification
        assert "600000" in payroll.last_notification

    def test_タイトル変更でオブザーバーに通知される(self):
        emp = Employee("田中", "エンジニア", 500000)
        taxman = TaxMan()
        emp.add_observer(taxman)

        emp.title = "シニアエンジニア"
        assert "田中" in taxman.last_notification

    def test_複数のオブザーバーが通知を受け取る(self):
        emp = Employee("田中", "エンジニア", 500000)
        payroll = Payroll()
        taxman = TaxMan()
        emp.add_observer(payroll)
        emp.add_observer(taxman)

        emp.salary = 700000
        assert payroll.last_notification != ""
        assert taxman.last_notification != ""

    def test_オブザーバーを削除できる(self):
        emp = Employee("田中", "エンジニア", 500000)
        payroll = Payroll()
        emp.add_observer(payroll)
        emp.remove_observer(payroll)

        emp.salary = 600000
        assert payroll.last_notification == ""

    def test_payrollが給与変更メッセージを生成する(self):
        emp = Employee("鈴木", "マネージャー", 800000)
        payroll = Payroll()
        emp.add_observer(payroll)

        emp.salary = 900000
        assert payroll.last_notification == "鈴木 の給与が 900000 に変更されました"

    def test_taxmanが税金通知メッセージを生成する(self):
        emp = Employee("鈴木", "マネージャー", 800000)
        taxman = TaxMan()
        emp.add_observer(taxman)

        emp.salary = 900000
        assert taxman.last_notification == "鈴木 に新しい税金の請求書を送付します"
