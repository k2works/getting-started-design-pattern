<?php

declare(strict_types=1);

namespace DesignPattern\Builder;

class Drive
{
    private string $type;
    private int $sizeGb;

    public function __construct(string $type, int $sizeGb)
    {
        $this->type = $type;
        $this->sizeGb = $sizeGb;
    }

    public function getType(): string
    {
        return $this->type;
    }

    public function getSizeGb(): int
    {
        return $this->sizeGb;
    }
}

class Motherboard
{
    private string $model;

    public function __construct(string $model)
    {
        $this->model = $model;
    }

    public function getModel(): string
    {
        return $this->model;
    }
}

class Computer
{
    private string $display;
    private Motherboard $motherboard;
    /** @var Drive[] */
    private array $drives;
    private int $memoryGb;

    /**
     * @param Drive[] $drives
     */
    public function __construct(
        string $display,
        Motherboard $motherboard,
        array $drives,
        int $memoryGb
    ) {
        $this->display = $display;
        $this->motherboard = $motherboard;
        $this->drives = $drives;
        $this->memoryGb = $memoryGb;
    }

    public function getDisplay(): string
    {
        return $this->display;
    }

    public function getMotherboard(): Motherboard
    {
        return $this->motherboard;
    }

    /** @return Drive[] */
    public function getDrives(): array
    {
        return $this->drives;
    }

    public function getMemoryGb(): int
    {
        return $this->memoryGb;
    }

    public function describe(): string
    {
        $driveInfo = implode(
            ', ',
            array_map(fn(Drive $d) => "{$d->getType()} {$d->getSizeGb()}GB", $this->drives)
        );
        return "Computer: {$this->display}, {$this->motherboard->getModel()}, {$this->memoryGb}GB RAM, [{$driveInfo}]";
    }
}

abstract class ComputerBuilder
{
    protected ?string $display = null;
    protected ?Motherboard $motherboard = null;
    /** @var Drive[] */
    protected array $drives = [];
    protected ?int $memoryGb = null;

    public function setDisplay(string $display): static
    {
        $this->display = $display;
        return $this;
    }

    public function setMotherboard(Motherboard $motherboard): static
    {
        $this->motherboard = $motherboard;
        return $this;
    }

    public function addDrive(Drive $drive): static
    {
        $this->drives[] = $drive;
        return $this;
    }

    public function setMemoryGb(int $memoryGb): static
    {
        $this->memoryGb = $memoryGb;
        return $this;
    }

    abstract protected function validate(): void;

    public function build(): Computer
    {
        $this->validate();
        return new Computer(
            $this->display,
            $this->motherboard,
            $this->drives,
            $this->memoryGb
        );
    }

    public function reset(): static
    {
        $this->display = null;
        $this->motherboard = null;
        $this->drives = [];
        $this->memoryGb = null;
        return $this;
    }
}

class DesktopBuilder extends ComputerBuilder
{
    protected function validate(): void
    {
        if ($this->display === null) {
            throw new \RuntimeException('ディスプレイが設定されていません');
        }
        if ($this->motherboard === null) {
            throw new \RuntimeException('マザーボードが設定されていません');
        }
        if ($this->memoryGb === null) {
            throw new \RuntimeException('メモリが設定されていません');
        }
        if (empty($this->drives)) {
            throw new \RuntimeException('ドライブが1つも追加されていません');
        }
    }
}

class LaptopBuilder extends ComputerBuilder
{
    protected function validate(): void
    {
        if ($this->display === null) {
            throw new \RuntimeException('ディスプレイが設定されていません');
        }
        if ($this->motherboard === null) {
            throw new \RuntimeException('マザーボードが設定されていません');
        }
        if ($this->memoryGb === null) {
            throw new \RuntimeException('メモリが設定されていません');
        }
        if (count($this->drives) > 2) {
            throw new \RuntimeException('ラップトップのドライブは2つまでです');
        }
    }
}
