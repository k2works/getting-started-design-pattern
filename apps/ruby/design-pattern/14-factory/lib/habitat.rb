require_relative "organism_factory"
require_relative "organisms"

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
