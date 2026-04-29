package pattern.factory;

import java.util.function.Supplier;

/**
 * 生物ファクトリ（Abstract Factory）。
 * 動物と植物の生成を Supplier で受け取る。
 */
public class OrganismFactory {
    private final Supplier<Animal> animalFactory;
    private final Supplier<Plant> plantFactory;

    public OrganismFactory(Supplier<Animal> animalFactory, Supplier<Plant> plantFactory) {
        this.animalFactory = animalFactory;
        this.plantFactory = plantFactory;
    }

    public Animal newAnimal() {
        return animalFactory.get();
    }

    public Plant newPlant() {
        return plantFactory.get();
    }
}
