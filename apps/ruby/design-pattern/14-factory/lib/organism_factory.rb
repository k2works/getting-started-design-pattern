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
