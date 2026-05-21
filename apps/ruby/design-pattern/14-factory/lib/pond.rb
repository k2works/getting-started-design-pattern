require_relative "organisms"

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

class DuckPond < Pond
  def initialize(number_animals: 3, number_plants: 2)
    super(number_animals, Duck, number_plants, WaterLily)
  end
end

class FrogPond < Pond
  def initialize(number_animals: 3, number_plants: 2)
    super(number_animals, Frog, number_plants, Algae)
  end
end
