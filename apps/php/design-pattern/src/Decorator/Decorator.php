<?php

declare(strict_types=1);

namespace DesignPattern\Decorator;

interface Writer
{
    public function writeLine(string $line): void;

    public function getOutput(): array;
}

class SimpleWriter implements Writer
{
    /** @var string[] */
    private array $output = [];

    public function writeLine(string $line): void
    {
        $this->output[] = $line;
    }

    public function getOutput(): array
    {
        return $this->output;
    }
}

abstract class WriterDecorator implements Writer
{
    protected Writer $wrapped;

    public function __construct(Writer $wrapped)
    {
        $this->wrapped = $wrapped;
    }

    public function getOutput(): array
    {
        return $this->wrapped->getOutput();
    }
}

class NumberingWriter extends WriterDecorator
{
    private int $lineNumber = 1;

    public function writeLine(string $line): void
    {
        $this->wrapped->writeLine("{$this->lineNumber}: {$line}");
        $this->lineNumber++;
    }
}

class TimeStampingWriter extends WriterDecorator
{
    private ?string $fixedTime;

    public function __construct(Writer $wrapped, ?string $fixedTime = null)
    {
        parent::__construct($wrapped);
        $this->fixedTime = $fixedTime;
    }

    public function writeLine(string $line): void
    {
        $time = $this->fixedTime ?? date('Y-m-d H:i:s');
        $this->wrapped->writeLine("[{$time}] {$line}");
    }
}
