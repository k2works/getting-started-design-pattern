package pattern.factory;

import java.util.ArrayList;
import java.util.List;

/**
 * 生息地（Abstract Factory を使用）。
 * OrganismFactory から動物と植物を生成する。
 */
public class Habitat {
    private final List<Animal> animals;
    private final List<Plant> plants;

    public Habitat(int numAnimals, int numPlants, OrganismFactory factory) {
        animals = new ArrayList<>();
        for (int i = 0; i < numAnimals; i++) {
            animals.add(factory.newAnimal());
        }
        plants = new ArrayList<>();
        for (int i = 0; i < numPlants; i++) {
            plants.add(factory.newPlant());
        }
    }

    public List<String> simulateOneDay() {
        List<String> output = new ArrayList<>();
        for (Plant plant : plants) {
            output.add(plant.grow());
        }
        for (Animal animal : animals) {
            output.add(animal.speak());
            output.add(animal.eat());
            output.add(animal.sleep());
        }
        return output;
    }
}
