namespace DesignPattern.Patterns.Observer;

public class Employee
{
    private string _name;
    private string _title;
    private decimal _salary;

    public string Name => _name;
    public string Title => _title;

    public decimal Salary
    {
        get => _salary;
        set
        {
            _salary = value;
            OnPropertyChanged(nameof(Salary));
        }
    }

    public event Action<Employee, string>? PropertyChanged;

    public Employee(string name, string title, decimal salary)
    {
        _name = name;
        _title = title;
        _salary = salary;
    }

    private void OnPropertyChanged(string propertyName)
    {
        PropertyChanged?.Invoke(this, propertyName);
    }
}

public class Payroll
{
    public List<string> Updates { get; } = new();

    public void OnEmployeeChanged(Employee employee, string propertyName)
    {
        Updates.Add($"Cut a new check for {employee.Name}! His salary is now {employee.Salary}");
    }
}

public class TaxMan
{
    public List<string> Updates { get; } = new();

    public void OnEmployeeChanged(Employee employee, string propertyName)
    {
        Updates.Add($"Send {employee.Name} a new tax bill!");
    }
}
