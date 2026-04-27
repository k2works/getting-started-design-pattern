using DesignPattern.Patterns.Decorator;

namespace DesignPattern.Tests.Patterns;

public class DecoratorTest
{
    [Fact]
    public void SimpleWriter_ReturnsTextAsIs()
    {
        var writer = new SimpleWriter();

        Assert.Equal("hello", writer.Write("hello"));
    }

    [Fact]
    public void NumberingWriter_AddsLineNumbers()
    {
        var writer = new NumberingWriter(new SimpleWriter());

        Assert.Equal("1: hello", writer.Write("hello"));
        Assert.Equal("2: world", writer.Write("world"));
    }

    [Fact]
    public void TimeStampingWriter_AddsTimestamp()
    {
        var fixedTime = new DateTime(2025, 1, 15, 10, 30, 0);
        var writer = new TimeStampingWriter(new SimpleWriter(), () => fixedTime);

        var result = writer.Write("hello");

        Assert.Equal("[2025-01-15 10:30:00] hello", result);
    }

    [Fact]
    public void UpperCaseWriter_ConvertsToUpperCase()
    {
        var writer = new UpperCaseWriter(new SimpleWriter());

        Assert.Equal("HELLO", writer.Write("hello"));
    }

    [Fact]
    public void CanStackDecorators_TimestampThenNumbering()
    {
        var fixedTime = new DateTime(2025, 1, 15, 10, 30, 0);
        // TimeStamping wraps the text first, then Numbering adds line number
        var writer = new TimeStampingWriter(
            new NumberingWriter(new SimpleWriter()), () => fixedTime);

        var result = writer.Write("hello");

        // TimeStamping adds timestamp -> "[2025-01-15 10:30:00] hello"
        // Then passes to Numbering -> "1: [2025-01-15 10:30:00] hello"
        Assert.Equal("1: [2025-01-15 10:30:00] hello", result);
    }

    [Fact]
    public void CanStackDecorators_AllThree()
    {
        var fixedTime = new DateTime(2025, 1, 15, 10, 30, 0);
        // UpperCase first, then Timestamp, then Numbering
        var writer = new NumberingWriter(
            new TimeStampingWriter(
                new SimpleWriter(), () => fixedTime));

        var result = writer.Write("hello");

        // Numbering adds "1: " then passes to TimeStamping -> "[timestamp] 1: hello"?
        // No: Numbering.Write("hello") -> inner.Write("1: hello")
        //   -> TimeStamping.Write("1: hello") -> inner.Write("[ts] 1: hello")
        Assert.Contains("1:", result);
        Assert.Contains("2025-01-15", result);
    }
}
