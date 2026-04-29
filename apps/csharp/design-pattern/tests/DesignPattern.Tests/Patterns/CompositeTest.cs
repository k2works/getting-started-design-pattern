using DesignPattern.Patterns.Composite;
using Task = DesignPattern.Patterns.Composite.Task;

namespace DesignPattern.Tests.Patterns;

public class CompositeTest
{
    [Fact]
    public void LeafTask_ReturnsItsTimeRequired()
    {
        var task = new Task("Mix", 3.0);

        Assert.Equal(3.0, task.GetTimeRequired());
    }

    [Fact]
    public void CompositeTask_SumsSubTaskTimes()
    {
        var composite = new CompositeTask("Baking");
        composite.AddSubTask(new Task("Mix", 3.0));
        composite.AddSubTask(new Task("Bake", 2.0));

        Assert.Equal(5.0, composite.GetTimeRequired());
    }

    [Fact]
    public void MakeBatterTask_HasCorrectTotalTime()
    {
        var batter = new MakeBatterTask();

        Assert.Equal(4.5, batter.GetTimeRequired());
    }

    [Fact]
    public void MakeCakeTask_IncludesNestedTasks()
    {
        var cake = new MakeCakeTask();

        Assert.Equal(8.0, cake.GetTimeRequired());
    }

    [Fact]
    public void RemoveSubTask_ReducesTotalTime()
    {
        var composite = new CompositeTask("Test");
        var task = new Task("Removable", 5.0);
        composite.AddSubTask(task);
        composite.AddSubTask(new Task("Keep", 2.0));

        composite.RemoveSubTask(task);

        Assert.Equal(2.0, composite.GetTimeRequired());
    }

    [Fact]
    public void GetDescription_ShowsHierarchy()
    {
        var cake = new MakeCakeTask();
        var desc = cake.GetDescription();

        Assert.Contains("Make cake", desc);
        Assert.Contains("Make batter", desc);
        Assert.Contains("Add dry ingredients", desc);
    }
}
