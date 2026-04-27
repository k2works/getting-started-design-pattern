package pattern.factory;

public class Duck implements Animal {
    @Override
    public String speak() {
        return "Quack!";
    }

    @Override
    public String eat() {
        return "Duck is eating.";
    }

    @Override
    public String sleep() {
        return "Duck is sleeping.";
    }
}
