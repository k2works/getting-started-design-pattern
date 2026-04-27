<?php

declare(strict_types=1);

namespace DesignPattern\Tests;

use DesignPattern\Factory\Duck;
use DesignPattern\Factory\DuckPond;
use DesignPattern\Factory\Frog;
use DesignPattern\Factory\FrogPond;
use DesignPattern\Factory\Habitat;
use DesignPattern\Factory\OrganismFactory;
use DesignPattern\Factory\Tiger;
use DesignPattern\Factory\Tree;
use PHPUnit\Framework\TestCase;

class FactoryTest extends TestCase
{
    public function testDuckBehavior(): void
    {
        $duck = new Duck('ドナルド');

        $this->assertSame('ドナルド', $duck->getName());
        $this->assertStringContainsString('パンを食べています', $duck->eat());
        $this->assertSame('ガーガー', $duck->speak());
    }

    public function testFrogBehavior(): void
    {
        $frog = new Frog('ケロ吉');

        $this->assertStringContainsString('虫を食べています', $frog->eat());
        $this->assertSame('ケロケロ', $frog->speak());
    }

    public function testDuckPondFactoryMethod(): void
    {
        $pond = new DuckPond();

        $this->assertInstanceOf(Duck::class, $pond->getAnimal());
        $this->assertStringContainsString('ドナルド', $pond->describe());
    }

    public function testFrogPondFactoryMethod(): void
    {
        $pond = new FrogPond();

        $this->assertInstanceOf(Frog::class, $pond->getAnimal());
        $this->assertStringContainsString('ケロ吉', $pond->describe());
    }

    public function testAbstractFactoryWithTigerAndTree(): void
    {
        $factory = new OrganismFactory(Tiger::class, Tree::class);
        $habitat = new Habitat($factory, 'シェレカン', '大きな木');

        $this->assertInstanceOf(Tiger::class, $habitat->getAnimal());
        $this->assertInstanceOf(Tree::class, $habitat->getPlant());
        $this->assertStringContainsString('シェレカン', $habitat->describe());
    }

    public function testAbstractFactoryAnimalBehavior(): void
    {
        $factory = new OrganismFactory(Tiger::class, Tree::class);
        $habitat = new Habitat($factory, 'タイガー', '杉');

        $this->assertSame('ガオー', $habitat->getAnimal()->speak());
        $this->assertStringContainsString('肉を食べています', $habitat->getAnimal()->eat());
    }

    public function testAbstractFactoryPlantBehavior(): void
    {
        $factory = new OrganismFactory(Duck::class, Tree::class);
        $habitat = new Habitat($factory, 'アヒル', '松');

        $this->assertStringContainsString('大きく成長しています', $habitat->getPlant()->grow());
    }
}
