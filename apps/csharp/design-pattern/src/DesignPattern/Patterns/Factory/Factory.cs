namespace DesignPattern.Patterns.Factory;

// --- Product interfaces ---

public interface IAnimal
{
    string Name { get; }
    string Speak();
    string Eat();
}

public interface IPlant
{
    string Name { get; }
    string Grow();
}

// --- Concrete animals ---

public class Duck : IAnimal
{
    public string Name => "Duck";
    public string Speak() => "Quack!";
    public string Eat() => "Duck eats bugs";
}

public class Frog : IAnimal
{
    public string Name => "Frog";
    public string Speak() => "Croak!";
    public string Eat() => "Frog eats flies";
}

public class Tiger : IAnimal
{
    public string Name => "Tiger";
    public string Speak() => "Roar!";
    public string Eat() => "Tiger eats meat";
}

// --- Concrete plants ---

public class WaterLily : IPlant
{
    public string Name => "WaterLily";
    public string Grow() => "WaterLily grows in water";
}

public class Algae : IPlant
{
    public string Name => "Algae";
    public string Grow() => "Algae spreads in the pond";
}

public class Tree : IPlant
{
    public string Name => "Tree";
    public string Grow() => "Tree grows tall in the jungle";
}

// --- Factory Method pattern (Pond) ---

public abstract class Pond
{
    public IAnimal Animal { get; }
    public IPlant Plant { get; }

    protected Pond()
    {
        Animal = CreateAnimal();
        Plant = CreatePlant();
    }

    protected abstract IAnimal CreateAnimal();
    protected abstract IPlant CreatePlant();

    public string Describe() =>
        $"Pond with {Animal.Name} and {Plant.Name}: {Animal.Speak()}, {Plant.Grow()}";
}

public class DuckPond : Pond
{
    protected override IAnimal CreateAnimal() => new Duck();
    protected override IPlant CreatePlant() => new WaterLily();
}

public class FrogPond : Pond
{
    protected override IAnimal CreateAnimal() => new Frog();
    protected override IPlant CreatePlant() => new Algae();
}

// --- Abstract Factory pattern (OrganismFactory + Habitat) ---

public interface IOrganismFactory
{
    IAnimal CreateAnimal();
    IPlant CreatePlant();
}

public class PondFactory : IOrganismFactory
{
    public IAnimal CreateAnimal() => new Frog();
    public IPlant CreatePlant() => new Algae();
}

public class JungleFactory : IOrganismFactory
{
    public IAnimal CreateAnimal() => new Tiger();
    public IPlant CreatePlant() => new Tree();
}

public class Habitat
{
    public IAnimal Animal { get; }
    public IPlant Plant { get; }

    public Habitat(IOrganismFactory factory)
    {
        Animal = factory.CreateAnimal();
        Plant = factory.CreatePlant();
    }

    public string Describe() =>
        $"Habitat with {Animal.Name} and {Plant.Name}: {Animal.Speak()}, {Plant.Grow()}";
}
