# frozen_string_literal: true

require_relative "../../test/test_helper"
require_relative "../lib/factory"

class DuckPondTest < Minitest::Test
  def test_simulate_one_day
    pond = DuckPond.new(number_animals: 2, number_plants: 1)
    output = pond.simulate_one_day

    assert_includes output, "WaterLily is growing."
    assert_includes output, "Quack!"
    assert_includes output, "Duck is eating."
    assert_includes output, "Duck is sleeping."
  end

  def test_correct_number_of_organisms
    pond = DuckPond.new(number_animals: 3, number_plants: 2)
    output = pond.simulate_one_day

    assert_equal 2, output.count("WaterLily is growing.")
    assert_equal 3, output.count("Quack!")
  end
end

class FrogPondTest < Minitest::Test
  def test_simulate_one_day
    pond = FrogPond.new(number_animals: 2, number_plants: 1)
    output = pond.simulate_one_day

    assert_includes output, "Algae is growing."
    assert_includes output, "Croak!"
    assert_includes output, "Frog is eating."
    assert_includes output, "Frog is sleeping."
  end
end

class HabitatWithOrganismFactoryTest < Minitest::Test
  def test_jungle_habitat
    jungle_factory = OrganismFactory.new(Tree, Tiger)
    jungle = Habitat.new(2, 3, jungle_factory)
    output = jungle.simulate_one_day

    assert_equal 3, output.count("Tree is growing.")
    assert_equal 2, output.count("Roar!")
    assert_includes output, "Tiger is eating."
    assert_includes output, "Tiger is sleeping."
  end

  def test_pond_habitat
    pond_factory = OrganismFactory.new(WaterLily, Frog)
    pond = Habitat.new(2, 2, pond_factory)
    output = pond.simulate_one_day

    assert_equal 2, output.count("WaterLily is growing.")
    assert_equal 2, output.count("Croak!")
  end

  def test_organism_factory_creates_correct_types
    factory = OrganismFactory.new(Algae, Duck)

    assert_instance_of Duck, factory.new_animal
    assert_instance_of Algae, factory.new_plant
  end
end
