namespace DesignPattern.Patterns.Decorator;

public interface IWriter
{
    string Write(string text);
}

public class SimpleWriter : IWriter
{
    public string Write(string text) => text;
}

public class NumberingWriter : IWriter
{
    private readonly IWriter _inner;
    private int _lineNumber;

    public NumberingWriter(IWriter inner)
    {
        _inner = inner;
        _lineNumber = 0;
    }

    public string Write(string text)
    {
        _lineNumber++;
        return _inner.Write($"{_lineNumber}: {text}");
    }
}

public class TimeStampingWriter : IWriter
{
    private readonly IWriter _inner;
    private readonly Func<DateTime> _clock;

    public TimeStampingWriter(IWriter inner, Func<DateTime>? clock = null)
    {
        _inner = inner;
        _clock = clock ?? (() => DateTime.Now);
    }

    public string Write(string text)
    {
        var timestamp = _clock().ToString("yyyy-MM-dd HH:mm:ss");
        return _inner.Write($"[{timestamp}] {text}");
    }
}

public class UpperCaseWriter : IWriter
{
    private readonly IWriter _inner;

    public UpperCaseWriter(IWriter inner)
    {
        _inner = inner;
    }

    public string Write(string text) => _inner.Write(text.ToUpper());
}
