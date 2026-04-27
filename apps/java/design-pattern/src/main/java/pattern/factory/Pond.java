package pattern.factory;

import java.util.ArrayList;
import java.util.List;
import java.util.function.Supplier;

/**
 * 池（Factory Method パターン）。
 * サブクラスが生成する動物と植物の種類を決定する。
 */
public abstract class Pond {
    private final List<Animal> animals;
    private final List<Plant> plants;

    protected Pond(int numAnimals, Supplier<Animal> animalFactory,
                   int numPlants, Supplier<Plant> plantFactory) {
        animals = new ArrayList<>();
        for (int i = 0; i < numAnimals; i++) {
            animals.add(animalFactory.get());
        }
        plants = new ArrayList<>();
        for (int i = 0; i < numPlants; i++) {
            plants.add(plantFactory.get());
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
