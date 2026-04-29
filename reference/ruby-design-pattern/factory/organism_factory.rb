#
# == 有機体ファクトリークラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class OrganismFactory
  def initialize(plant_class, animal_class)
    @plant_class = plant_class
    @animal_class = animal_class
  end

  def new_animal(name)
    @animal_class.new(name)
  end

  def new_plant(name)
    @plant_class.new(name)
  end
end
