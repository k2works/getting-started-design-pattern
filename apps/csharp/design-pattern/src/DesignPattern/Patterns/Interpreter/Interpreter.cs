namespace DesignPattern.Patterns.Interpreter;

public record FileEntry(string Name, long Size, bool Writable);

public interface IExpression
{
    bool Interpret(FileEntry context);
}

public class All : IExpression
{
    public bool Interpret(FileEntry context) => true;
}

public class FileName : IExpression
{
    private readonly string _pattern;

    public FileName(string pattern)
    {
        _pattern = pattern;
    }

    public bool Interpret(FileEntry context) =>
        MatchPattern(context.Name, _pattern);

    private static bool MatchPattern(string name, string pattern)
    {
        if (pattern == "*") return true;

        if (pattern.StartsWith("*."))
        {
            var extension = pattern[1..];
            return name.EndsWith(extension, StringComparison.OrdinalIgnoreCase);
        }

        return string.Equals(name, pattern, StringComparison.OrdinalIgnoreCase);
    }
}

public class Bigger : IExpression
{
    private readonly long _size;

    public Bigger(long size)
    {
        _size = size;
    }

    public bool Interpret(FileEntry context) => context.Size > _size;
}

public class Writable : IExpression
{
    public bool Interpret(FileEntry context) => context.Writable;
}

public class Not : IExpression
{
    private readonly IExpression _expression;

    public Not(IExpression expression)
    {
        _expression = expression;
    }

    public bool Interpret(FileEntry context) => !_expression.Interpret(context);
}

public class And : IExpression
{
    private readonly IExpression _left;
    private readonly IExpression _right;

    public And(IExpression left, IExpression right)
    {
        _left = left;
        _right = right;
    }

    public bool Interpret(FileEntry context) =>
        _left.Interpret(context) && _right.Interpret(context);
}

public class Or : IExpression
{
    private readonly IExpression _left;
    private readonly IExpression _right;

    public Or(IExpression left, IExpression right)
    {
        _left = left;
        _right = right;
    }

    public bool Interpret(FileEntry context) =>
        _left.Interpret(context) || _right.Interpret(context);
}
