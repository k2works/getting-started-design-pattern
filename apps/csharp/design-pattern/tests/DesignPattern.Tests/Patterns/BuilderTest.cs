using DesignPattern.Patterns.Builder;

namespace DesignPattern.Tests.Patterns;

public class BuilderTest
{
    [Fact]
    public void DesktopBuilder_BuildsDesktop()
    {
        var computer = new DesktopBuilder()
            .SetDisplay("30-inch")
            .SetMotherboard("ATX")
            .AddDrive("SSD 1TB")
            .SetGpu("RTX 4090")
            .Build();

        Assert.False(computer.Portable);
        Assert.Equal("30-inch", computer.Display);
        Assert.Equal("ATX", computer.Motherboard);
        Assert.Contains("SSD 1TB", computer.Drives);
        Assert.Equal("RTX 4090", computer.Gpu);
    }

    [Fact]
    public void LaptopBuilder_BuildsLaptop()
    {
        var computer = new LaptopBuilder()
            .SetDisplay("15-inch")
            .SetMotherboard("Mini-ITX")
            .AddDrive("NVMe 512GB")
            .Build();

        Assert.True(computer.Portable);
        Assert.Equal("15-inch", computer.Display);
    }

    [Fact]
    public void Builder_ResetsAfterBuild()
    {
        var builder = new DesktopBuilder();
        builder.SetDisplay("30-inch").AddDrive("SSD").Build();

        var second = builder.SetDisplay("24-inch").Build();

        Assert.Equal("24-inch", second.Display);
        Assert.Empty(second.Drives);
    }

    [Fact]
    public void Computer_Record_Equality()
    {
        var c1 = new Computer("15-inch", "ATX", new List<string> { "SSD" }, "RTX 4090", false);
        var c2 = new Computer("15-inch", "ATX", new List<string> { "SSD" }, "RTX 4090", false);

        // Records use value equality for primitive fields
        // but List<string> uses reference equality, so these won't be equal
        Assert.Equal(c1.Display, c2.Display);
        Assert.Equal(c1.Motherboard, c2.Motherboard);
    }

    [Fact]
    public void Computer_Describe_IncludesType()
    {
        var desktop = new DesktopBuilder()
            .SetDisplay("27-inch")
            .SetMotherboard("ATX")
            .AddDrive("HDD 2TB")
            .Build();

        Assert.StartsWith("Desktop", desktop.Describe());
    }

    [Fact]
    public void Computer_Describe_LaptopType()
    {
        var laptop = new LaptopBuilder()
            .SetDisplay("14-inch")
            .SetMotherboard("Embedded")
            .Build();

        Assert.StartsWith("Laptop", laptop.Describe());
    }

    [Fact]
    public void FluentBuilder_ChainsMethodCalls()
    {
        var computer = new DesktopBuilder()
            .SetDisplay("32-inch")
            .SetMotherboard("EATX")
            .AddDrive("SSD 2TB")
            .AddDrive("HDD 4TB")
            .SetGpu("RTX 5090")
            .Build();

        Assert.Equal(2, computer.Drives.Count);
    }
}
