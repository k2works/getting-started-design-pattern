using DesignPattern.Patterns.Adapter;

namespace DesignPattern.Tests.Patterns;

public class AdapterTest
{
    [Fact]
    public void Adapter_ConvertsTextProperty()
    {
        var british = new BritishTextObject { String = "Hello" };
        ITextObject adapted = new BritishTextObjectAdapter(british);

        Assert.Equal("Hello", adapted.Text);
    }

    [Fact]
    public void Adapter_ConvertsMmToInches()
    {
        var british = new BritishTextObject { SizeMm = 25.4 };
        ITextObject adapted = new BritishTextObjectAdapter(british);

        Assert.Equal(1, adapted.SizeInches);
    }

    [Fact]
    public void Adapter_ConvertsInchesToMm()
    {
        var british = new BritishTextObject();
        var adapted = new BritishTextObjectAdapter(british);

        adapted.SizeInches = 2;

        Assert.Equal(50.8, british.SizeMm, 1);
    }

    [Fact]
    public void Adapter_ConvertsColorProperty()
    {
        var british = new BritishTextObject { Colour = "red" };
        ITextObject adapted = new BritishTextObjectAdapter(british);

        Assert.Equal("red", adapted.Color);
    }

    [Fact]
    public void Renderer_CanRenderAdaptedObject()
    {
        var british = new BritishTextObject
        {
            String = "Adapted",
            SizeMm = 50.8,
            Colour = "blue"
        };
        var adapted = new BritishTextObjectAdapter(british);
        var renderer = new Renderer();

        var result = renderer.Render(adapted);

        Assert.Contains("Adapted", result);
        Assert.Contains("2in", result);
        Assert.Contains("blue", result);
    }

    [Fact]
    public void Adapter_SetsTextOnAdaptee()
    {
        var british = new BritishTextObject();
        var adapted = new BritishTextObjectAdapter(british);

        adapted.Text = "Updated";

        Assert.Equal("Updated", british.String);
    }
}
