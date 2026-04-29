package pattern.factory;

/**
 * アヒルの池（具象 Factory Method）。
 */
public class DuckPond extends Pond {
    public DuckPond(int numAnimals, int numPlants) {
        super(numAnimals, Duck::new, numPlants, WaterLily::new);
    }
}
