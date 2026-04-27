package pattern.factory;

public class Tree implements Plant {
    @Override
    public String grow() {
        return "Tree is growing.";
    }
}
