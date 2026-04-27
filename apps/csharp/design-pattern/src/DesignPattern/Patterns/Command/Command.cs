namespace DesignPattern.Patterns.Command;

public interface ICommand
{
    string Execute();
    string Undo();
    string Description { get; }
}

public class CreateFileCommand : ICommand
{
    private readonly string _path;
    private readonly string _content;
    private bool _executed;

    public string Description => $"Create file: {_path}";

    public CreateFileCommand(string path, string content)
    {
        _path = path;
        _content = content;
    }

    public string Execute()
    {
        _executed = true;
        return $"Created file '{_path}' with content: {_content}";
    }

    public string Undo()
    {
        if (!_executed)
            return $"Cannot undo: file '{_path}' was never created";

        _executed = false;
        return $"Deleted file '{_path}'";
    }
}

public class DeleteFileCommand : ICommand
{
    private readonly string _path;
    private string? _backupContent;
    private bool _executed;

    public string Description => $"Delete file: {_path}";

    public DeleteFileCommand(string path)
    {
        _path = path;
    }

    public string Execute()
    {
        _backupContent = $"[backup of {_path}]";
        _executed = true;
        return $"Deleted file '{_path}'";
    }

    public string Undo()
    {
        if (!_executed)
            return $"Cannot undo: file '{_path}' was never deleted";

        _executed = false;
        return $"Restored file '{_path}' from backup: {_backupContent}";
    }
}

public class CompositeCommand : ICommand
{
    private readonly List<ICommand> _commands = new();

    public string Description => $"Composite ({_commands.Count} commands)";

    public void AddCommand(ICommand command) => _commands.Add(command);

    public string Execute()
    {
        var results = _commands.Select(c => c.Execute());
        return string.Join("\n", results);
    }

    public string Undo()
    {
        var results = _commands.AsEnumerable().Reverse().Select(c => c.Undo());
        return string.Join("\n", results);
    }
}
