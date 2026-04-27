using DesignPattern.Patterns.Command;

namespace DesignPattern.Tests.Patterns;

public class CommandTest
{
    [Fact]
    public void CreateFileCommand_Execute_ReturnsConfirmation()
    {
        var cmd = new CreateFileCommand("test.txt", "hello");
        var result = cmd.Execute();

        Assert.Contains("Created file 'test.txt'", result);
        Assert.Contains("hello", result);
    }

    [Fact]
    public void CreateFileCommand_Undo_DeletesFile()
    {
        var cmd = new CreateFileCommand("test.txt", "hello");
        cmd.Execute();
        var result = cmd.Undo();

        Assert.Contains("Deleted file 'test.txt'", result);
    }

    [Fact]
    public void CreateFileCommand_UndoWithoutExecute_ReturnsError()
    {
        var cmd = new CreateFileCommand("test.txt", "hello");
        var result = cmd.Undo();

        Assert.Contains("Cannot undo", result);
    }

    [Fact]
    public void DeleteFileCommand_Execute_ReturnsConfirmation()
    {
        var cmd = new DeleteFileCommand("old.txt");
        var result = cmd.Execute();

        Assert.Contains("Deleted file 'old.txt'", result);
    }

    [Fact]
    public void DeleteFileCommand_Undo_RestoresFromBackup()
    {
        var cmd = new DeleteFileCommand("old.txt");
        cmd.Execute();
        var result = cmd.Undo();

        Assert.Contains("Restored file 'old.txt'", result);
    }

    [Fact]
    public void CompositeCommand_ExecutesAllCommands()
    {
        var composite = new CompositeCommand();
        composite.AddCommand(new CreateFileCommand("a.txt", "aaa"));
        composite.AddCommand(new CreateFileCommand("b.txt", "bbb"));

        var result = composite.Execute();

        Assert.Contains("a.txt", result);
        Assert.Contains("b.txt", result);
    }

    [Fact]
    public void CompositeCommand_UndoInReverseOrder()
    {
        var composite = new CompositeCommand();
        composite.AddCommand(new CreateFileCommand("a.txt", "aaa"));
        composite.AddCommand(new CreateFileCommand("b.txt", "bbb"));
        composite.Execute();

        var result = composite.Undo();
        var lines = result.Split('\n');

        Assert.Contains("b.txt", lines[0]);
        Assert.Contains("a.txt", lines[1]);
    }

    [Fact]
    public void Command_HasDescription()
    {
        var cmd = new CreateFileCommand("test.txt", "hello");

        Assert.Equal("Create file: test.txt", cmd.Description);
    }
}
