using DesignPattern.Patterns.Strategy;

namespace DesignPattern.Tests.Patterns;

public class StrategyTest
{
    private readonly string[] _text = ["Hello", "World"];

    [Fact]
    public void HtmlFormatter_ProducesHtmlOutput()
    {
        var report = new Report("Test", _text, HtmlFormatter.Format);
        var output = report.OutputReport();

        Assert.StartsWith("<html>", output);
        Assert.Contains("<p>Hello</p>", output);
    }

    [Fact]
    public void PlainTextFormatter_ProducesPlainOutput()
    {
        var report = new Report("Test", _text, PlainTextFormatter.Format);
        var output = report.OutputReport();

        Assert.Contains("***** Test *****", output);
        Assert.DoesNotContain("<html>", output);
    }

    [Fact]
    public void CanSwitchFormatterAtRuntime()
    {
        var report = new Report("Test", _text, HtmlFormatter.Format);
        Assert.Contains("<html>", report.OutputReport());

        report.Formatter = PlainTextFormatter.Format;
        Assert.Contains("*****", report.OutputReport());
    }

    [Fact]
    public void CanUseLambdaAsFormatter()
    {
        var report = new Report("Test", _text, r =>
            $"Custom: {r.Title} ({r.Text.Length} lines)");
        var output = report.OutputReport();

        Assert.Equal("Custom: Test (2 lines)", output);
    }

    [Fact]
    public void HtmlFormatter_IncludesAllLines()
    {
        var report = new Report("Test", _text, HtmlFormatter.Format);
        var output = report.OutputReport();

        Assert.Contains("<p>Hello</p>", output);
        Assert.Contains("<p>World</p>", output);
    }
}
