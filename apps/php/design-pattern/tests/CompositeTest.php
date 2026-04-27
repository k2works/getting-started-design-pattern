<?php

declare(strict_types=1);

namespace DesignPattern\Tests;

use DesignPattern\Composite\AddDryIngredientsTask;
use DesignPattern\Composite\CompositeTask;
use DesignPattern\Composite\MakeBatterTask;
use DesignPattern\Composite\MakeCakeTask;
use PHPUnit\Framework\TestCase;

class CompositeTest extends TestCase
{
    public function testLeafTaskTimeRequired(): void
    {
        $task = new AddDryIngredientsTask();
        $this->assertSame(1.0, $task->getTimeRequired());
    }

    public function testLeafTaskName(): void
    {
        $task = new AddDryIngredientsTask();
        $this->assertSame('小麦粉と砂糖を加える', $task->getName());
    }

    public function testLeafTaskBasicTaskCount(): void
    {
        $task = new AddDryIngredientsTask();
        $this->assertSame(1, $task->totalBasicTasks());
    }

    public function testMakeBatterCompositeTime(): void
    {
        $task = new MakeBatterTask();
        // AddDryIngredients(1.0) + AddLiquids(0.5) + Mix(3.0) = 4.5
        $this->assertSame(4.5, $task->getTimeRequired());
    }

    public function testMakeBatterBasicTaskCount(): void
    {
        $task = new MakeBatterTask();
        $this->assertSame(3, $task->totalBasicTasks());
    }

    public function testMakeCakeCompositeTime(): void
    {
        $task = new MakeCakeTask();
        // MakeBatter(4.5) + FillPan(0.5) + Bake(25.0) + Frost(10.0) + Pack(5.0) = 45.0
        $this->assertSame(45.0, $task->getTimeRequired());
    }

    public function testMakeCakeBasicTaskCount(): void
    {
        $task = new MakeCakeTask();
        // 3 (batter) + 1 + 1 + 1 + 1 = 7
        $this->assertSame(7, $task->totalBasicTasks());
    }

    public function testRemoveSubTask(): void
    {
        $composite = new CompositeTask('テスト');
        $leaf = new AddDryIngredientsTask();
        $composite->addSubTask($leaf);
        $this->assertSame(1.0, $composite->getTimeRequired());

        $composite->removeSubTask($leaf);
        $this->assertSame(0.0, $composite->getTimeRequired());
    }
}
