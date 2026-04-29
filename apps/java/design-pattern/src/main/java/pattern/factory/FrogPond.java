package pattern.factory;

/**
 * カエルの池（具象 Factory Method）。
 */
public class FrogPond extends Pond {
    public FrogPond(int numAnimals, int numPlants) {
        super(numAnimals, Frog::new, numPlants, Algae::new);
    }
}
