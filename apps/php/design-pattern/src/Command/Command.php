<?php

declare(strict_types=1);

namespace DesignPattern\Command;

interface Command
{
    public function execute(): void;

    public function undo(): void;

    public function getDescription(): string;
}

class CreateFileCommand implements Command
{
    private string $path;
    private string $contents;

    public function __construct(string $path, string $contents = '')
    {
        $this->path = $path;
        $this->contents = $contents;
    }

    public function execute(): void
    {
        file_put_contents($this->path, $this->contents);
    }

    public function undo(): void
    {
        if (file_exists($this->path)) {
            unlink($this->path);
        }
    }

    public function getDescription(): string
    {
        return "ファイル作成: {$this->path}";
    }
}

class DeleteFileCommand implements Command
{
    private string $path;
    private string $savedContents = '';

    public function __construct(string $path)
    {
        $this->path = $path;
    }

    public function execute(): void
    {
        if (file_exists($this->path)) {
            $this->savedContents = file_get_contents($this->path);
            unlink($this->path);
        }
    }

    public function undo(): void
    {
        file_put_contents($this->path, $this->savedContents);
    }

    public function getDescription(): string
    {
        return "ファイル削除: {$this->path}";
    }
}

class CompositeCommand implements Command
{
    /** @var Command[] */
    private array $commands = [];
    private string $description;

    public function __construct(string $description = '複合コマンド')
    {
        $this->description = $description;
    }

    public function addCommand(Command $command): void
    {
        $this->commands[] = $command;
    }

    public function execute(): void
    {
        foreach ($this->commands as $command) {
            $command->execute();
        }
    }

    public function undo(): void
    {
        foreach (array_reverse($this->commands) as $command) {
            $command->undo();
        }
    }

    public function getDescription(): string
    {
        return $this->description;
    }

    /** @return Command[] */
    public function getCommands(): array
    {
        return $this->commands;
    }
}
