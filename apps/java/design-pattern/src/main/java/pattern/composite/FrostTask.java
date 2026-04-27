package pattern.composite;

public class FrostTask extends Task {

    public FrostTask() {
        super("アイシングする");
    }

    @Override
    public double getTimeRequired() {
        return 4.0;
    }
}
