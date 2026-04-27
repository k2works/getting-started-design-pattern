using DesignPattern.Patterns.Factory;

namespace DesignPattern.Tests.Patterns;

public class FactoryTest
{
    [Fact]
    public void Duck_SpeaksQuack()
    {
        IAnimal duck = new Duck();

        Assert.Equal("Quack!", duck.Speak());
    }

    [Fact]
    public void DuckPond_CreatesDuckAndWaterLily()
    {
        var pond = new DuckPond();

        Assert.IsType<Duck>(pond.Animal);
        Assert.IsType<WaterLily>(pond.Plant);
    }

    [Fact]
    public void FrogPond_CreatesFrogAndAlgae()
    {
        var pond = new FrogPond();

        Assert.IsType<Frog>(pond.Animal);
        Assert.IsType<Algae>(pond.Plant);
    }

    [Fact]
    public void Pond_Describe_IncludesAnimalAndPlant()
    {
        var pond = new DuckPond();
        var desc = pond.Describe();

        Assert.Contains("Duck", desc);
        Assert.Contains("WaterLily", desc);
        Assert.Contains("Quack!", desc);
    }

    [Fact]
    public void JungleFactory_CreatesTigerAndTree()
    {
        var factory = new JungleFactory();
        var habitat = new Habitat(factory);

        Assert.IsType<Tiger>(habitat.Animal);
        Assert.IsType<Tree>(habitat.Plant);
    }

    [Fact]
    public void PondFactory_CreatesFrogAndAlgae()
    {
        var factory = new PondFactory();
        var habitat = new Habitat(factory);

        Assert.IsType<Frog>(habitat.Animal);
        Assert.IsType<Algae>(habitat.Plant);
    }

    [Fact]
    public void Habitat_Describe_IncludesInfo()
    {
        var habitat = new Habitat(new JungleFactory());
        var desc = habitat.Describe();

        Assert.Contains("Tiger", desc);
        Assert.Contains("Roar!", desc);
        Assert.Contains("Tree grows tall", desc);
    }
}
