<?php

declare(strict_types=1);

namespace DesignPattern\Composite;

abstract class Task
{
    protected string $name;

    public function __construct(string $name)
    {
        $this->name = $name;
    }

    public function getName(): string
    {
        return $this->name;
    }

    abstract public function getTimeRequired(): float;

    public function totalBasicTasks(): int
    {
        return 1;
    }
}

class AddDryIngredientsTask extends Task
{
    public function __construct()
    {
        parent::__construct('小麦粉と砂糖を加える');
    }

    public function getTimeRequired(): float
    {
        return 1.0;
    }
}

class AddLiquidsTask extends Task
{
    public function __construct()
    {
        parent::__construct('卵とバターを加える');
    }

    public function getTimeRequired(): float
    {
        return 0.5;
    }
}

class MixTask extends Task
{
    public function __construct()
    {
        parent::__construct('混ぜる');
    }

    public function getTimeRequired(): float
    {
        return 3.0;
    }
}

class FillPanTask extends Task
{
    public function __construct()
    {
        parent::__construct('型に入れる');
    }

    public function getTimeRequired(): float
    {
        return 0.5;
    }
}

class BakeTask extends Task
{
    public function __construct()
    {
        parent::__construct('焼く');
    }

    public function getTimeRequired(): float
    {
        return 25.0;
    }
}

class FrostTask extends Task
{
    public function __construct()
    {
        parent::__construct('デコレーションする');
    }

    public function getTimeRequired(): float
    {
        return 10.0;
    }
}

class PackTask extends Task
{
    public function __construct()
    {
        parent::__construct('箱詰めする');
    }

    public function getTimeRequired(): float
    {
        return 5.0;
    }
}

class CompositeTask extends Task
{
    /** @var Task[] */
    protected array $subTasks = [];

    public function addSubTask(Task $task): void
    {
        $this->subTasks[] = $task;
    }

    public function removeSubTask(Task $task): void
    {
        $this->subTasks = array_values(
            array_filter($this->subTasks, fn(Task $t) => $t !== $task)
        );
    }

    public function getTimeRequired(): float
    {
        return array_sum(array_map(fn(Task $t) => $t->getTimeRequired(), $this->subTasks));
    }

    public function totalBasicTasks(): int
    {
        return array_sum(array_map(fn(Task $t) => $t->totalBasicTasks(), $this->subTasks));
    }

    /** @return Task[] */
    public function getSubTasks(): array
    {
        return $this->subTasks;
    }
}

class MakeBatterTask extends CompositeTask
{
    public function __construct()
    {
        parent::__construct('生地を作る');
        $this->addSubTask(new AddDryIngredientsTask());
        $this->addSubTask(new AddLiquidsTask());
        $this->addSubTask(new MixTask());
    }
}

class MakeCakeTask extends CompositeTask
{
    public function __construct()
    {
        parent::__construct('ケーキを作る');
        $this->addSubTask(new MakeBatterTask());
        $this->addSubTask(new FillPanTask());
        $this->addSubTask(new BakeTask());
        $this->addSubTask(new FrostTask());
        $this->addSubTask(new PackTask());
    }
}
