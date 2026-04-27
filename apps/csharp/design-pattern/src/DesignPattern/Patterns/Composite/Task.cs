namespace DesignPattern.Patterns.Composite;

public class Task
{
    public string Name { get; }
    public double TimeRequired { get; }

    public Task(string name, double timeRequired)
    {
        Name = name;
        TimeRequired = timeRequired;
    }

    public virtual double GetTimeRequired() => TimeRequired;

    public virtual string GetDescription(int indent = 0)
    {
        return $"{new string(' ', indent)}{Name}: {GetTimeRequired()}h\n";
    }
}

public class CompositeTask : Task
{
    private readonly List<Task> _subTasks = new();

    public CompositeTask(string name) : base(name, 0) { }

    public void AddSubTask(Task task) => _subTasks.Add(task);
    public void RemoveSubTask(Task task) => _subTasks.Remove(task);

    public override double GetTimeRequired() =>
        _subTasks.Sum(t => t.GetTimeRequired());

    public override string GetDescription(int indent = 0)
    {
        var result = $"{new string(' ', indent)}{Name}: {GetTimeRequired()}h\n";
        foreach (var task in _subTasks)
        {
            result += task.GetDescription(indent + 2);
        }
        return result;
    }

    public int SubTaskCount => _subTasks.Count;
}

public class MakeBatterTask : CompositeTask
{
    public MakeBatterTask() : base("Make batter")
    {
        AddSubTask(new Task("Add dry ingredients", 1.0));
        AddSubTask(new Task("Add liquids", 0.5));
        AddSubTask(new Task("Mix", 3.0));
    }
}

public class MakeCakeTask : CompositeTask
{
    public MakeCakeTask() : base("Make cake")
    {
        AddSubTask(new MakeBatterTask());
        AddSubTask(new Task("Fill pan", 0.5));
        AddSubTask(new Task("Bake", 2.0));
        AddSubTask(new Task("Frost", 1.0));
    }
}
