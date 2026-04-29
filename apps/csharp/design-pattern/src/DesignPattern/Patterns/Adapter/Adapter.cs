namespace DesignPattern.Patterns.Adapter;

public interface ITextObject
{
    string Text { get; set; }
    int SizeInches { get; set; }
    string Color { get; set; }
}

public class BritishTextObject
{
    public string String { get; set; } = "";
    public double SizeMm { get; set; }
    public string Colour { get; set; } = "black";
}

public class BritishTextObjectAdapter : ITextObject
{
    private readonly BritishTextObject _adaptee;
    private const double MmPerInch = 25.4;

    public BritishTextObjectAdapter(BritishTextObject adaptee)
    {
        _adaptee = adaptee;
    }

    public string Text
    {
        get => _adaptee.String;
        set => _adaptee.String = value;
    }

    public int SizeInches
    {
        get => (int)(_adaptee.SizeMm / MmPerInch);
        set => _adaptee.SizeMm = value * MmPerInch;
    }

    public string Color
    {
        get => _adaptee.Colour;
        set => _adaptee.Colour = value;
    }
}

public class Renderer
{
    public string Render(ITextObject textObject)
    {
        return $"Rendering '{textObject.Text}' at {textObject.SizeInches}in in {textObject.Color}";
    }
}
