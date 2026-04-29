using DesignPattern.Patterns.TemplateMethod;

namespace DesignPattern.Tests.Patterns;

public class TemplateMethodTest
{
    private readonly string[] _text = ["Hello", "World"];

    [Fact]
    public void HtmlReport_ContainsHtmlTags()
    {
        var report = new HtmlReport("Test", _text);
        var output = report.OutputReport();

        Assert.StartsWith("<html>", output);
        Assert.Contains("</html>", output);
    }

    [Fact]
    public void HtmlReport_ContainsTitle()
    {
        var report = new HtmlReport("Monthly Report", _text);
        var output = report.OutputReport();

        Assert.Contains("<title>Monthly Report</title>", output);
    }

    [Fact]
    public void HtmlReport_WrapsLinesInParagraphs()
    {
        var report = new HtmlReport("Test", _text);
        var output = report.OutputReport();

        Assert.Contains("<p>Hello</p>", output);
        Assert.Contains("<p>World</p>", output);
    }

    [Fact]
    public void PlainTextReport_ContainsFormattedTitle()
    {
        var report = new PlainTextReport("Test", _text);
        var output = report.OutputReport();

        Assert.Contains("***** Test *****", output);
    }

    [Fact]
    public void PlainTextReport_ContainsPlainLines()
    {
        var report = new PlainTextReport("Test", _text);
        var output = report.OutputReport();

        Assert.Contains("Hello\n", output);
        Assert.Contains("World\n", output);
    }

    [Fact]
    public void PlainTextReport_DoesNotContainHtmlTags()
    {
        var report = new PlainTextReport("Test", _text);
        var output = report.OutputReport();

        Assert.DoesNotContain("<html>", output);
        Assert.DoesNotContain("<p>", output);
    }
}
