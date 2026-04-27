package pattern.composite;

public class AddDryIngredientsTask extends Task {

    public AddDryIngredientsTask() {
        super("乾燥材料を加える");
    }

    @Override
    public double getTimeRequired() {
        return 1.0;
    }
}
