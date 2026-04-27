package pattern.composite;

public class BakeTask extends Task {

    public BakeTask() {
        super("焼く");
    }

    @Override
    public double getTimeRequired() {
        return 10.0;
    }
}
