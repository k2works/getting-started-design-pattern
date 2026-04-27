"""Factory パターン

Factory Method（Pond サブクラス）と
Abstract Factory（OrganismFactory + Habitat）の両方を実装。
"""

from __future__ import annotations

from typing import Protocol


# === 動物プロトコル ===


class Animal(Protocol):
    def speak(self) -> str: ...
    def eat(self) -> str: ...
    def sleep(self) -> str: ...


class Duck:
    def speak(self) -> str:
        return "Quack!"

    def eat(self) -> str:
        return "Duck is eating."

    def sleep(self) -> str:
        return "Duck is sleeping."


class Frog:
    def speak(self) -> str:
        return "Croak!"

    def eat(self) -> str:
        return "Frog is eating."

    def sleep(self) -> str:
        return "Frog is sleeping."


class Tiger:
    def speak(self) -> str:
        return "Roar!"

    def eat(self) -> str:
        return "Tiger is eating."

    def sleep(self) -> str:
        return "Tiger is sleeping."


# === 植物プロトコル ===


class Plant(Protocol):
    def grow(self) -> str: ...


class WaterLily:
    def grow(self) -> str:
        return "WaterLily is growing."


class Algae:
    def grow(self) -> str:
        return "Algae is growing."


class Tree:
    def grow(self) -> str:
        return "Tree is growing."


# === Factory Method パターン ===


class Pond:
    """池の基底クラス（Factory Method）"""

    def __init__(
        self,
        number_animals: int,
        animal_class: type,
        number_plants: int,
        plant_class: type,
    ) -> None:
        self._animals = [animal_class() for _ in range(number_animals)]
        self._plants = [plant_class() for _ in range(number_plants)]

    def simulate_one_day(self) -> list[str]:
        output: list[str] = []
        for plant in self._plants:
            output.append(plant.grow())
        for animal in self._animals:
            output.append(animal.speak())
            output.append(animal.eat())
            output.append(animal.sleep())
        return output


class DuckPond(Pond):
    def __init__(self, number_animals: int = 3, number_plants: int = 2) -> None:
        super().__init__(number_animals, Duck, number_plants, WaterLily)


class FrogPond(Pond):
    def __init__(self, number_animals: int = 3, number_plants: int = 2) -> None:
        super().__init__(number_animals, Frog, number_plants, Algae)


# === Abstract Factory パターン ===


class OrganismFactory:
    """生物工場（Abstract Factory）"""

    def __init__(self, plant_class: type, animal_class: type) -> None:
        self._plant_class = plant_class
        self._animal_class = animal_class

    def new_animal(self) -> Animal:
        return self._animal_class()

    def new_plant(self) -> Plant:
        return self._plant_class()


class Habitat:
    """生息地（Abstract Factory を使用）"""

    def __init__(
        self,
        number_animals: int,
        number_plants: int,
        organism_factory: OrganismFactory,
    ) -> None:
        self._animals = [organism_factory.new_animal() for _ in range(number_animals)]
        self._plants = [organism_factory.new_plant() for _ in range(number_plants)]

    def simulate_one_day(self) -> list[str]:
        output: list[str] = []
        for plant in self._plants:
            output.append(plant.grow())
        for animal in self._animals:
            output.append(animal.speak())
            output.append(animal.eat())
            output.append(animal.sleep())
        return output
