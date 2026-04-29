package pattern.composite;

public class AddLiquidsTask extends Task {

    public AddLiquidsTask() {
        super("液体材料を加える");
    }

    @Override
    public double getTimeRequired() {
        return 1.0;
    }
}
