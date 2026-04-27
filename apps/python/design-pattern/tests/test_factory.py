"""Factory パターンのテスト"""

from src.factory import (
    Algae,
    Duck,
    DuckPond,
    Frog,
    FrogPond,
    Habitat,
    OrganismFactory,
    Tiger,
    Tree,
    WaterLily,
)


class TestAnimals:
    def test_アヒルが鳴く(self):
        assert Duck().speak() == "Quack!"

    def test_カエルが鳴く(self):
        assert Frog().speak() == "Croak!"

    def test_トラが鳴く(self):
        assert Tiger().speak() == "Roar!"


class TestFactoryMethod:
    def test_アヒルの池のシミュレーション(self):
        pond = DuckPond(number_animals=2, number_plants=1)
        output = pond.simulate_one_day()
        assert "WaterLily is growing." in output
        assert "Quack!" in output
        assert "Duck is eating." in output
        assert "Duck is sleeping." in output

    def test_カエルの池のシミュレーション(self):
        pond = FrogPond(number_animals=1, number_plants=1)
        output = pond.simulate_one_day()
        assert "Algae is growing." in output
        assert "Croak!" in output


class TestAbstractFactory:
    def test_ジャングルの生息地(self):
        factory = OrganismFactory(Tree, Tiger)
        habitat = Habitat(1, 1, factory)
        output = habitat.simulate_one_day()
        assert "Tree is growing." in output
        assert "Roar!" in output

    def test_池の生息地(self):
        factory = OrganismFactory(WaterLily, Duck)
        habitat = Habitat(2, 2, factory)
        output = habitat.simulate_one_day()
        assert output.count("WaterLily is growing.") == 2
        assert output.count("Quack!") == 2

    def test_ファクトリの切り替え(self):
        pond_factory = OrganismFactory(Algae, Frog)
        jungle_factory = OrganismFactory(Tree, Tiger)

        pond = Habitat(1, 1, pond_factory)
        jungle = Habitat(1, 1, jungle_factory)

        assert "Croak!" in pond.simulate_one_day()
        assert "Roar!" in jungle.simulate_one_day()
