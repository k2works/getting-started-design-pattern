<?php

declare(strict_types=1);

namespace DesignPattern\Factory;

// --- Animal interface and implementations ---

interface Animal
{
    public function getName(): string;

    public function eat(): string;

    public function speak(): string;
}

class Duck implements Animal
{
    private string $name;

    public function __construct(string $name)
    {
        $this->name = $name;
    }

    public function getName(): string
    {
        return $this->name;
    }

    public function eat(): string
    {
        return "{$this->name} はパンを食べています";
    }

    public function speak(): string
    {
        return 'ガーガー';
    }
}

class Frog implements Animal
{
    private string $name;

    public function __construct(string $name)
    {
        $this->name = $name;
    }

    public function getName(): string
    {
        return $this->name;
    }

    public function eat(): string
    {
        return "{$this->name} は虫を食べています";
    }

    public function speak(): string
    {
        return 'ケロケロ';
    }
}

class Tiger implements Animal
{
    private string $name;

    public function __construct(string $name)
    {
        $this->name = $name;
    }

    public function getName(): string
    {
        return $this->name;
    }

    public function eat(): string
    {
        return "{$this->name} は肉を食べています";
    }

    public function speak(): string
    {
        return 'ガオー';
    }
}

// --- Plant interface and implementations ---

interface Plant
{
    public function getName(): string;

    public function grow(): string;
}

class WaterLily implements Plant
{
    private string $name;

    public function __construct(string $name)
    {
        $this->name = $name;
    }

    public function getName(): string
    {
        return $this->name;
    }

    public function grow(): string
    {
        return "{$this->name} は水面に広がっています";
    }
}

class Algae implements Plant
{
    private string $name;

    public function __construct(string $name)
    {
        $this->name = $name;
    }

    public function getName(): string
    {
        return $this->name;
    }

    public function grow(): string
    {
        return "{$this->name} は水中で増殖しています";
    }
}

class Tree implements Plant
{
    private string $name;

    public function __construct(string $name)
    {
        $this->name = $name;
    }

    public function getName(): string
    {
        return $this->name;
    }

    public function grow(): string
    {
        return "{$this->name} は大きく成長しています";
    }
}

// --- Factory Method pattern: Pond ---

abstract class Pond
{
    private Animal $animal;
    private Plant $plant;

    public function __construct()
    {
        $this->animal = $this->createAnimal();
        $this->plant = $this->createPlant();
    }

    abstract protected function createAnimal(): Animal;

    abstract protected function createPlant(): Plant;

    public function getAnimal(): Animal
    {
        return $this->animal;
    }

    public function getPlant(): Plant
    {
        return $this->plant;
    }

    public function describe(): string
    {
        return sprintf(
            '%s と %s がいます',
            $this->animal->getName(),
            $this->plant->getName()
        );
    }
}

class DuckPond extends Pond
{
    protected function createAnimal(): Animal
    {
        return new Duck('ドナルド');
    }

    protected function createPlant(): Plant
    {
        return new WaterLily('蓮の花');
    }
}

class FrogPond extends Pond
{
    protected function createAnimal(): Animal
    {
        return new Frog('ケロ吉');
    }

    protected function createPlant(): Plant
    {
        return new Algae('藻');
    }
}

// --- Abstract Factory pattern: OrganismFactory + Habitat ---

class OrganismFactory
{
    /** @var class-string<Animal> */
    private string $animalClass;
    /** @var class-string<Plant> */
    private string $plantClass;

    /**
     * @param class-string<Animal> $animalClass
     * @param class-string<Plant> $plantClass
     */
    public function __construct(string $animalClass, string $plantClass)
    {
        $this->animalClass = $animalClass;
        $this->plantClass = $plantClass;
    }

    public function createAnimal(string $name): Animal
    {
        return new ($this->animalClass)($name);
    }

    public function createPlant(string $name): Plant
    {
        return new ($this->plantClass)($name);
    }
}

class Habitat
{
    private Animal $animal;
    private Plant $plant;

    public function __construct(OrganismFactory $factory, string $animalName, string $plantName)
    {
        $this->animal = $factory->createAnimal($animalName);
        $this->plant = $factory->createPlant($plantName);
    }

    public function getAnimal(): Animal
    {
        return $this->animal;
    }

    public function getPlant(): Plant
    {
        return $this->plant;
    }

    public function describe(): string
    {
        return sprintf(
            '%s と %s がいます',
            $this->animal->getName(),
            $this->plant->getName()
        );
    }
}
