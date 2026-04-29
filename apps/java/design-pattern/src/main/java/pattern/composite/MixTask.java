package pattern.composite;

public class MixTask extends Task {

    public MixTask() {
        super("混ぜる");
    }

    @Override
    public double getTimeRequired() {
        return 3.0;
    }
}
