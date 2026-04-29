require './pond'

#
# == 生態環境クラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class Habitat < Pond
  def initialize(number_animals, number_plants, organism_factory)
    @organism_factory = organism_factory

    @animals = []
    number_animals.times do |i|
      animal = @organism_factory.new_animal("動物#{i}")
      @animals << animal
    end

    @plants = []
    number_plants.times do |i|
      plant = @organism_factory.new_plant("植物#{i}")
      @plants << plant
    end
  end
end