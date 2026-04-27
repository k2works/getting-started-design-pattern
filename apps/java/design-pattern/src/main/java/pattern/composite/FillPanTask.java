package pattern.composite;

public class FillPanTask extends Task {

    public FillPanTask() {
        super("型に流し込む");
    }

    @Override
    public double getTimeRequired() {
        return 2.0;
    }
}
