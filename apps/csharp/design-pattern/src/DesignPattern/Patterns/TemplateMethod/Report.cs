namespace DesignPattern.Patterns.TemplateMethod;

public abstract class Report
{
    public string Title { get; }
    public string[] Text { get; }

    protected Report(string title, string[] text)
    {
        Title = title;
        Text = text;
    }

    public string OutputReport()
    {
        var result = OutputStart();
        result += OutputHead();
        result += OutputBodyStart();
        result += OutputBody();
        result += OutputBodyEnd();
        result += OutputEnd();
        return result;
    }

    protected virtual string OutputStart() => "";
    protected virtual string OutputHead() => $"  {Title}\n";
    protected virtual string OutputBodyStart() => "";

    protected string OutputBody()
    {
        var result = "";
        foreach (var line in Text)
        {
            result += OutputLine(line);
        }
        return result;
    }

    protected abstract string OutputLine(string line);
    protected virtual string OutputBodyEnd() => "";
    protected virtual string OutputEnd() => "";
}

public class HtmlReport : Report
{
    public HtmlReport(string title, string[] text) : base(title, text) { }

    protected override string OutputStart() => "<html>\n";
    protected override string OutputHead() => $"  <head><title>{Title}</title></head>\n";
    protected override string OutputBodyStart() => "  <body>\n";
    protected override string OutputLine(string line) => $"    <p>{line}</p>\n";
    protected override string OutputBodyEnd() => "  </body>\n";
    protected override string OutputEnd() => "</html>\n";
}

public class PlainTextReport : Report
{
    public PlainTextReport(string title, string[] text) : base(title, text) { }

    protected override string OutputHead() => $"***** {Title} *****\n";
    protected override string OutputLine(string line) => $"{line}\n";
}
