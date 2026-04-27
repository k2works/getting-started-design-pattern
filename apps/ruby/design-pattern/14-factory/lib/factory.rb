# frozen_string_literal: true

# === 動物クラス ===

class Duck
  def speak
    "Quack!"
  end

  def eat
    "Duck is eating."
  end

  def sleep
    "Duck is sleeping."
  end
end

class Frog
  def speak
    "Croak!"
  end

  def eat
    "Frog is eating."
  end

  def sleep
    "Frog is sleeping."
  end
end

class Tiger
  def speak
    "Roar!"
  end

  def eat
    "Tiger is eating."
  end

  def sleep
    "Tiger is sleeping."
  end
end

# === 植物クラス ===

class WaterLily
  def grow
    "WaterLily is growing."
  end
end

class Algae
  def grow
    "Algae is growing."
  end
end

class Tree
  def grow
    "Tree is growing."
  end
end

# === Factory Method パターン ===

# 池の基底クラス
class Pond
  def initialize(number_animals, animal_class, number_plants, plant_class)
    @animals = Array.new(number_animals) { animal_class.new }
    @plants = Array.new(number_plants) { plant_class.new }
  end

  def simulate_one_day
    output = []
    @plants.each { |plant| output << plant.grow }
    @animals.each do |animal|
      output << animal.speak
      output << animal.eat
      output << animal.sleep
    end
    output
  end
end

# アヒルの池（Factory Method）
class DuckPond < Pond
  def initialize(number_animals: 3, number_plants: 2)
    super(number_animals, Duck, number_plants, WaterLily)
  end
end

# カエルの池（Factory Method）
class FrogPond < Pond
  def initialize(number_animals: 3, number_plants: 2)
    super(number_animals, Frog, number_plants, Algae)
  end
end

# === Abstract Factory パターン ===

# 生物工場
class OrganismFactory
  def initialize(plant_class, animal_class)
    @plant_class = plant_class
    @animal_class = animal_class
  end

  def new_animal
    @animal_class.new
  end

  def new_plant
    @plant_class.new
  end
end

# 生息地（Abstract Factory を使用）
class Habitat
  def initialize(number_animals, number_plants, organism_factory)
    @animals = Array.new(number_animals) { organism_factory.new_animal }
    @plants = Array.new(number_plants) { organism_factory.new_plant }
  end

  def simulate_one_day
    output = []
    @plants.each { |plant| output << plant.grow }
    @animals.each do |animal|
      output << animal.speak
      output << animal.eat
      output << animal.sleep
    end
    output
  end
end
