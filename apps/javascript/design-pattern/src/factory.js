// Factory パターン
// オブジェクト生成をサブクラスや別オブジェクトに委ねる

// --- 生物クラス ---

export class Duck {
  constructor(name) { this.name = name; }
  speak() { return `${this.name}: ガーガー`; }
  type() { return 'Duck'; }
}

export class Frog {
  constructor(name) { this.name = name; }
  speak() { return `${this.name}: ゲロゲロ`; }
  type() { return 'Frog'; }
}

export class Tiger {
  constructor(name) { this.name = name; }
  speak() { return `${this.name}: ガオー`; }
  type() { return 'Tiger'; }
}

export class WaterLily {
  constructor(name) { this.name = name; }
  grow() { return `${this.name} が水面に広がる`; }
  type() { return 'WaterLily'; }
}

export class Algae {
  constructor(name) { this.name = name; }
  grow() { return `${this.name} が繁殖する`; }
  type() { return 'Algae'; }
}

export class Tree {
  constructor(name) { this.name = name; }
  grow() { return `${this.name} がそびえ立つ`; }
  type() { return 'Tree'; }
}

// --- Factory Method パターン: Pond クラス ---

export class Pond {
  constructor(numberOfAnimals, numberOfPlants, AnimalClass, PlantClass) {
    this.animals = [];
    this.plants = [];
    for (let i = 0; i < numberOfAnimals; i++) {
      this.animals.push(new AnimalClass(`動物${i + 1}`));
    }
    for (let i = 0; i < numberOfPlants; i++) {
      this.plants.push(new PlantClass(`植物${i + 1}`));
    }
  }

  simulate() {
    const results = [];
    for (const animal of this.animals) {
      results.push(animal.speak());
    }
    for (const plant of this.plants) {
      results.push(plant.grow());
    }
    return results;
  }
}

// --- Abstract Factory パターン ---

export class OrganismFactory {
  constructor(AnimalClass, PlantClass) {
    this.AnimalClass = AnimalClass;
    this.PlantClass = PlantClass;
  }

  createAnimal(name) {
    return new this.AnimalClass(name);
  }

  createPlant(name) {
    return new this.PlantClass(name);
  }
}

export class Habitat {
  constructor(numberOfAnimals, numberOfPlants, factory) {
    this.animals = [];
    this.plants = [];
    for (let i = 0; i < numberOfAnimals; i++) {
      this.animals.push(factory.createAnimal(`動物${i + 1}`));
    }
    for (let i = 0; i < numberOfPlants; i++) {
      this.plants.push(factory.createPlant(`植物${i + 1}`));
    }
  }

  simulate() {
    const results = [];
    for (const animal of this.animals) {
      results.push(animal.speak());
    }
    for (const plant of this.plants) {
      results.push(plant.grow());
    }
    return results;
  }
}
