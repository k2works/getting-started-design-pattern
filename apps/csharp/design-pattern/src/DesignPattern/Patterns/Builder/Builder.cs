namespace DesignPattern.Patterns.Builder;

public record Computer(
    string Display,
    string Motherboard,
    List<string> Drives,
    string? Gpu = null,
    bool Portable = false
)
{
    public string Describe()
    {
        var drives = string.Join(", ", Drives);
        var gpu = Gpu != null ? $", GPU: {Gpu}" : "";
        var type = Portable ? "Laptop" : "Desktop";
        return $"{type} - Display: {Display}, Motherboard: {Motherboard}, Drives: [{drives}]{gpu}";
    }
}

public abstract class ComputerBuilder
{
    protected string Display = "Unknown";
    protected string Motherboard = "Unknown";
    protected List<string> Drives = new();
    protected string? Gpu;
    protected bool Portable;

    public ComputerBuilder SetDisplay(string display)
    {
        Display = display;
        return this;
    }

    public ComputerBuilder SetMotherboard(string motherboard)
    {
        Motherboard = motherboard;
        return this;
    }

    public ComputerBuilder AddDrive(string drive)
    {
        Drives.Add(drive);
        return this;
    }

    public ComputerBuilder SetGpu(string gpu)
    {
        Gpu = gpu;
        return this;
    }

    public abstract Computer Build();

    public abstract ComputerBuilder Reset();
}

public class DesktopBuilder : ComputerBuilder
{
    public DesktopBuilder()
    {
        Portable = false;
    }

    public override Computer Build()
    {
        var computer = new Computer(Display, Motherboard, new List<string>(Drives), Gpu, Portable);
        Reset();
        return computer;
    }

    public override ComputerBuilder Reset()
    {
        Display = "Unknown";
        Motherboard = "Unknown";
        Drives = new List<string>();
        Gpu = null;
        Portable = false;
        return this;
    }
}

public class LaptopBuilder : ComputerBuilder
{
    public LaptopBuilder()
    {
        Portable = true;
    }

    public override Computer Build()
    {
        var computer = new Computer(Display, Motherboard, new List<string>(Drives), Gpu, Portable);
        Reset();
        return computer;
    }

    public override ComputerBuilder Reset()
    {
        Display = "Unknown";
        Motherboard = "Unknown";
        Drives = new List<string>();
        Gpu = null;
        Portable = true;
        return this;
    }
}
