/**
 * Factory パターン
 *
 * Factory Method: サブクラスにインスタンス生成を委ねる。
 * Abstract Factory: 関連するオブジェクト群の生成を抽象化する。
 */

// --- Product interfaces ---

export interface Animal {
  speak(): string;
  eat(): string;
  sleep(): string;
}

export interface Plant {
  grow(): string;
}

// --- Concrete Animals ---

export class Duck implements Animal {
  speak(): string {
    return 'Quack!';
  }
  eat(): string {
    return 'Eating bugs';
  }
  sleep(): string {
    return 'Sleeping on the pond';
  }
}

export class Frog implements Animal {
  speak(): string {
    return 'Croak!';
  }
  eat(): string {
    return 'Eating flies';
  }
  sleep(): string {
    return 'Sleeping on a lily pad';
  }
}

export class Tiger implements Animal {
  speak(): string {
    return 'Roar!';
  }
  eat(): string {
    return 'Eating meat';
  }
  sleep(): string {
    return 'Sleeping in the jungle';
  }
}

// --- Concrete Plants ---

export class WaterLily implements Plant {
  grow(): string {
    return 'Growing in water';
  }
}

export class Algae implements Plant {
  grow(): string {
    return 'Growing on rocks';
  }
}

export class Tree implements Plant {
  grow(): string {
    return 'Growing tall';
  }
}

// --- Factory Method: Pond ---

type AnimalClass = new () => Animal;
type PlantClass = new () => Plant;

export class Pond {
  private animalClass: AnimalClass;
  private plantClass: PlantClass;
  private numberOfAnimals: number;
  private numberOfPlants: number;

  constructor(
    animalClass: AnimalClass,
    numberOfAnimals: number,
    plantClass: PlantClass,
    numberOfPlants: number
  ) {
    this.animalClass = animalClass;
    this.numberOfAnimals = numberOfAnimals;
    this.plantClass = plantClass;
    this.numberOfPlants = numberOfPlants;
  }

  createAnimals(): Animal[] {
    return Array.from({ length: this.numberOfAnimals }, () => new this.animalClass());
  }

  createPlants(): Plant[] {
    return Array.from({ length: this.numberOfPlants }, () => new this.plantClass());
  }
}

// --- Abstract Factory ---

export interface OrganismFactory {
  createAnimal(): Animal;
  createPlant(): Plant;
}

export class PondFactory implements OrganismFactory {
  createAnimal(): Animal {
    return new Duck();
  }
  createPlant(): Plant {
    return new WaterLily();
  }
}

export class JungleFactory implements OrganismFactory {
  createAnimal(): Animal {
    return new Tiger();
  }
  createPlant(): Plant {
    return new Tree();
  }
}

export class Habitat {
  private factory: OrganismFactory;
  private animals: Animal[] = [];
  private plants: Plant[] = [];

  constructor(factory: OrganismFactory) {
    this.factory = factory;
  }

  addAnimal(): Animal {
    const animal = this.factory.createAnimal();
    this.animals.push(animal);
    return animal;
  }

  addPlant(): Plant {
    const plant = this.factory.createPlant();
    this.plants.push(plant);
    return plant;
  }

  getAnimals(): ReadonlyArray<Animal> {
    return this.animals;
  }

  getPlants(): ReadonlyArray<Plant> {
    return this.plants;
  }
}
