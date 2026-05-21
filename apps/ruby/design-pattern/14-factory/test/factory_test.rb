require_relative "test_helper"
require_relative "../lib/organisms"
require_relative "../lib/pond"
require_relative "../lib/organism_factory"
require_relative "../lib/habitat"

class DuckPondTest < Minitest::Test
  def test_simulate_one_day_includes_duck_and_water_lily_actions
    pond = DuckPond.new(number_animals: 2, number_plants: 1)
    output = pond.simulate_one_day

    assert_includes output, "WaterLily is growing."
    assert_includes output, "Quack!"
    assert_includes output, "Duck is eating."
    assert_includes output, "Duck is sleeping."
  end

  def test_correct_number_of_organisms_are_simulated
    pond = DuckPond.new(number_animals: 3, number_plants: 2)
    output = pond.simulate_one_day

    assert_equal 2, output.count("WaterLily is growing.")
    assert_equal 3, output.count("Quack!")
  end
end

class HabitatWithOrganismFactoryTest < Minitest::Test
  def test_jungle_habitat_simulates_tree_and_tiger_actions
    jungle_factory = OrganismFactory.new(Tree, Tiger)
    jungle = Habitat.new(2, 3, jungle_factory)
    output = jungle.simulate_one_day

    assert_equal 3, output.count("Tree is growing.")
    assert_equal 2, output.count("Roar!")
    assert_includes output, "Tiger is eating."
  end

  def test_organism_factory_creates_correct_types
    factory = OrganismFactory.new(Algae, Duck)

    assert_instance_of Duck, factory.new_animal
    assert_instance_of Algae, factory.new_plant
  end
end
