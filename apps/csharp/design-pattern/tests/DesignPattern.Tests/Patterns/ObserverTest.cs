using DesignPattern.Patterns.Observer;

namespace DesignPattern.Tests.Patterns;

public class ObserverTest
{
    [Fact]
    public void PayrollIsNotifiedOnSalaryChange()
    {
        var employee = new Employee("Alice", "Engineer", 50000m);
        var payroll = new Payroll();
        employee.PropertyChanged += payroll.OnEmployeeChanged;

        employee.Salary = 60000m;

        Assert.Single(payroll.Updates);
        Assert.Contains("Alice", payroll.Updates[0]);
        Assert.Contains("60000", payroll.Updates[0]);
    }

    [Fact]
    public void TaxManIsNotifiedOnSalaryChange()
    {
        var employee = new Employee("Bob", "Manager", 70000m);
        var taxMan = new TaxMan();
        employee.PropertyChanged += taxMan.OnEmployeeChanged;

        employee.Salary = 80000m;

        Assert.Single(taxMan.Updates);
        Assert.Contains("Bob", taxMan.Updates[0]);
    }

    [Fact]
    public void MultipleObserversAreNotified()
    {
        var employee = new Employee("Carol", "Director", 90000m);
        var payroll = new Payroll();
        var taxMan = new TaxMan();
        employee.PropertyChanged += payroll.OnEmployeeChanged;
        employee.PropertyChanged += taxMan.OnEmployeeChanged;

        employee.Salary = 100000m;

        Assert.Single(payroll.Updates);
        Assert.Single(taxMan.Updates);
    }

    [Fact]
    public void UnsubscribedObserverIsNotNotified()
    {
        var employee = new Employee("Dave", "Intern", 30000m);
        var payroll = new Payroll();
        employee.PropertyChanged += payroll.OnEmployeeChanged;
        employee.PropertyChanged -= payroll.OnEmployeeChanged;

        employee.Salary = 35000m;

        Assert.Empty(payroll.Updates);
    }

    [Fact]
    public void MultipleChangesProduceMultipleNotifications()
    {
        var employee = new Employee("Eve", "Lead", 60000m);
        var payroll = new Payroll();
        employee.PropertyChanged += payroll.OnEmployeeChanged;

        employee.Salary = 65000m;
        employee.Salary = 70000m;

        Assert.Equal(2, payroll.Updates.Count);
    }
}
