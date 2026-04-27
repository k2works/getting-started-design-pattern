package pattern.observer;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class ObserverTest {

    @Test
    void payrollIsNotifiedOnSalaryChange() {
        Employee employee = new Employee("田中太郎", "エンジニア", 300000);
        Payroll payroll = new Payroll();
        employee.addObserver(payroll);

        employee.setSalary(350000);

        assertEquals("田中太郎 の給与が 350000 に変更されました", payroll.getLastNotification());
    }

    @Test
    void taxManIsNotifiedOnSalaryChange() {
        Employee employee = new Employee("田中太郎", "エンジニア", 300000);
        TaxMan taxMan = new TaxMan();
        employee.addObserver(taxMan);

        employee.setSalary(350000);

        assertEquals("田中太郎 に新しい税金の請求書を送付します", taxMan.getLastNotification());
    }

    @Test
    void multipleObserversAreNotified() {
        Employee employee = new Employee("田中太郎", "エンジニア", 300000);
        Payroll payroll = new Payroll();
        TaxMan taxMan = new TaxMan();
        employee.addObserver(payroll);
        employee.addObserver(taxMan);

        employee.setSalary(400000);

        assertNotNull(payroll.getLastNotification());
        assertNotNull(taxMan.getLastNotification());
    }

    @Test
    void observerIsNotifiedOnTitleChange() {
        Employee employee = new Employee("田中太郎", "エンジニア", 300000);
        Payroll payroll = new Payroll();
        employee.addObserver(payroll);

        employee.setTitle("シニアエンジニア");

        assertNotNull(payroll.getLastNotification());
    }

    @Test
    void removedObserverIsNotNotified() {
        Employee employee = new Employee("田中太郎", "エンジニア", 300000);
        Payroll payroll = new Payroll();
        employee.addObserver(payroll);
        employee.removeObserver(payroll);

        employee.setSalary(350000);

        assertNull(payroll.getLastNotification());
    }

    @Test
    void employeeHasCorrectInitialState() {
        Employee employee = new Employee("田中太郎", "エンジニア", 300000);

        assertEquals("田中太郎", employee.getName());
        assertEquals("エンジニア", employee.getTitle());
        assertEquals(300000, employee.getSalary());
    }
}
