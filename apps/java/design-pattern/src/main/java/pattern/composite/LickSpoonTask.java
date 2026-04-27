package pattern.composite;

public class LickSpoonTask extends Task {

    public LickSpoonTask() {
        super("スプーンをなめる");
    }

    @Override
    public double getTimeRequired() {
        return 1.0;
    }
}
