using DesignPattern.Patterns.Interpreter;

namespace DesignPattern.Tests.Patterns;

public class InterpreterTest
{
    private readonly FileEntry _largeDoc = new("report.doc", 5000, true);
    private readonly FileEntry _smallTxt = new("notes.txt", 100, false);
    private readonly FileEntry _largeMp3 = new("song.mp3", 8000, true);

    [Fact]
    public void All_MatchesEverything()
    {
        var expr = new All();

        Assert.True(expr.Interpret(_largeDoc));
        Assert.True(expr.Interpret(_smallTxt));
    }

    [Fact]
    public void FileName_MatchesByExtension()
    {
        var expr = new FileName("*.txt");

        Assert.True(expr.Interpret(_smallTxt));
        Assert.False(expr.Interpret(_largeDoc));
    }

    [Fact]
    public void FileName_MatchesByExactName()
    {
        var expr = new FileName("report.doc");

        Assert.True(expr.Interpret(_largeDoc));
        Assert.False(expr.Interpret(_smallTxt));
    }

    [Fact]
    public void Bigger_FiltersAboveThreshold()
    {
        var expr = new Bigger(1000);

        Assert.True(expr.Interpret(_largeDoc));
        Assert.False(expr.Interpret(_smallTxt));
    }

    [Fact]
    public void Writable_FiltersWritableFiles()
    {
        var expr = new Writable();

        Assert.True(expr.Interpret(_largeDoc));
        Assert.False(expr.Interpret(_smallTxt));
    }

    [Fact]
    public void Not_InvertsExpression()
    {
        var expr = new Not(new Bigger(1000));

        Assert.False(expr.Interpret(_largeDoc));
        Assert.True(expr.Interpret(_smallTxt));
    }

    [Fact]
    public void And_CombinesTwoExpressions()
    {
        var expr = new And(new Bigger(1000), new FileName("*.doc"));

        Assert.True(expr.Interpret(_largeDoc));
        Assert.False(expr.Interpret(_largeMp3));
    }

    [Fact]
    public void Or_MatchesEitherExpression()
    {
        var expr = new Or(new FileName("*.txt"), new FileName("*.mp3"));

        Assert.True(expr.Interpret(_smallTxt));
        Assert.True(expr.Interpret(_largeMp3));
        Assert.False(expr.Interpret(_largeDoc));
    }
}
