namespace DesignPattern.Patterns.Singleton;

public class SimpleLogger
{
    private readonly List<string> _messages = new();

    public void Log(string message) => _messages.Add(message);

    public IReadOnlyList<string> Messages => _messages.AsReadOnly();

    public string LatestMessage => _messages.Count > 0 ? _messages[^1] : "";

    public int MessageCount => _messages.Count;
}

public sealed class SingletonLogger
{
    private static readonly Lazy<SingletonLogger> _instance =
        new(() => new SingletonLogger());

    private readonly List<string> _messages = new();

    private SingletonLogger() { }

    public static SingletonLogger Instance => _instance.Value;

    public void Log(string message) => _messages.Add(message);

    public IReadOnlyList<string> Messages => _messages.AsReadOnly();

    public string LatestMessage => _messages.Count > 0 ? _messages[^1] : "";

    public int MessageCount => _messages.Count;

    // For testing only
    internal void Reset() => _messages.Clear();
}
