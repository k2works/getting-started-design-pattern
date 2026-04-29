package pattern.factory;

public class Frog implements Animal {
    @Override
    public String speak() {
        return "Croak!";
    }

    @Override
    public String eat() {
        return "Frog is eating.";
    }

    @Override
    public String sleep() {
        return "Frog is sleeping.";
    }
}
