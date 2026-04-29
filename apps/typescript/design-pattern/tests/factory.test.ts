import {
  Duck,
  Frog,
  Tiger,
  WaterLily,
  Pond,
  PondFactory,
  JungleFactory,
  Habitat,
} from '../src/factory';

describe('Factory パターン', () => {
  describe('Factory Method (Pond)', () => {
    it('Pond はクラス参照からアニマルを生成する', () => {
      const pond = new Pond(Duck, 3, WaterLily, 2);
      const animals = pond.createAnimals();
      expect(animals).toHaveLength(3);
      expect(animals[0].speak()).toBe('Quack!');
    });

    it('Pond はクラス参照からプラントを生成する', () => {
      const pond = new Pond(Frog, 1, WaterLily, 4);
      const plants = pond.createPlants();
      expect(plants).toHaveLength(4);
      expect(plants[0].grow()).toBe('Growing in water');
    });
  });

  describe('Abstract Factory (Habitat)', () => {
    it('PondFactory は Duck と WaterLily を生成する', () => {
      const habitat = new Habitat(new PondFactory());
      const animal = habitat.addAnimal();
      const plant = habitat.addPlant();

      expect(animal.speak()).toBe('Quack!');
      expect(plant.grow()).toBe('Growing in water');
    });

    it('JungleFactory は Tiger と Tree を生成する', () => {
      const habitat = new Habitat(new JungleFactory());
      const animal = habitat.addAnimal();
      const plant = habitat.addPlant();

      expect(animal.speak()).toBe('Roar!');
      expect(plant.grow()).toBe('Growing tall');
    });

    it('Habitat は生成した生物を管理する', () => {
      const habitat = new Habitat(new PondFactory());
      habitat.addAnimal();
      habitat.addAnimal();
      habitat.addPlant();

      expect(habitat.getAnimals()).toHaveLength(2);
      expect(habitat.getPlants()).toHaveLength(1);
    });
  });

  describe('具体的な Animal', () => {
    it('各動物は speak/eat/sleep を持つ', () => {
      const animals = [new Duck(), new Frog(), new Tiger()];
      for (const animal of animals) {
        expect(typeof animal.speak()).toBe('string');
        expect(typeof animal.eat()).toBe('string');
        expect(typeof animal.sleep()).toBe('string');
      }
    });
  });
});
