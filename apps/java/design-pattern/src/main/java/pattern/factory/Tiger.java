package pattern.factory;

public class Tiger implements Animal {
    @Override
    public String speak() {
        return "Roar!";
    }

    @Override
    public String eat() {
        return "Tiger is eating.";
    }

    @Override
    public String sleep() {
        return "Tiger is sleeping.";
    }
}
