namespace DesignPattern.Patterns.Strategy;

public class Report
{
    public string Title { get; }
    public string[] Text { get; }
    public Func<Report, string> Formatter { get; set; }

    public Report(string title, string[] text, Func<Report, string> formatter)
    {
        Title = title;
        Text = text;
        Formatter = formatter;
    }

    public string OutputReport() => Formatter(this);
}

public static class HtmlFormatter
{
    public static string Format(Report report)
    {
        var result = "<html>\n";
        result += $"  <head><title>{report.Title}</title></head>\n";
        result += "  <body>\n";
        foreach (var line in report.Text)
        {
            result += $"    <p>{line}</p>\n";
        }
        result += "  </body>\n";
        result += "</html>\n";
        return result;
    }
}

public static class PlainTextFormatter
{
    public static string Format(Report report)
    {
        var result = $"***** {report.Title} *****\n";
        foreach (var line in report.Text)
        {
            result += $"{line}\n";
        }
        return result;
    }
}
