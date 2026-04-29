<?php

declare(strict_types=1);

namespace DesignPattern\Tests;

use DesignPattern\Command\CompositeCommand;
use DesignPattern\Command\CreateFileCommand;
use DesignPattern\Command\DeleteFileCommand;
use PHPUnit\Framework\TestCase;

class CommandTest extends TestCase
{
    private string $testDir;

    protected function setUp(): void
    {
        $this->testDir = sys_get_temp_dir() . '/design_pattern_command_test_' . uniqid();
        mkdir($this->testDir, 0777, true);
    }

    protected function tearDown(): void
    {
        // Clean up test files
        $files = glob($this->testDir . '/*');
        if ($files) {
            array_map('unlink', $files);
        }
        if (is_dir($this->testDir)) {
            rmdir($this->testDir);
        }
    }

    public function testCreateFileCommand(): void
    {
        $path = $this->testDir . '/test.txt';
        $cmd = new CreateFileCommand($path, 'hello');

        $cmd->execute();

        $this->assertFileExists($path);
        $this->assertSame('hello', file_get_contents($path));
    }

    public function testCreateFileCommandUndo(): void
    {
        $path = $this->testDir . '/test.txt';
        $cmd = new CreateFileCommand($path, 'hello');

        $cmd->execute();
        $cmd->undo();

        $this->assertFileDoesNotExist($path);
    }

    public function testDeleteFileCommand(): void
    {
        $path = $this->testDir . '/test.txt';
        file_put_contents($path, 'content');
        $cmd = new DeleteFileCommand($path);

        $cmd->execute();

        $this->assertFileDoesNotExist($path);
    }

    public function testDeleteFileCommandUndo(): void
    {
        $path = $this->testDir . '/test.txt';
        file_put_contents($path, 'original');
        $cmd = new DeleteFileCommand($path);

        $cmd->execute();
        $cmd->undo();

        $this->assertFileExists($path);
        $this->assertSame('original', file_get_contents($path));
    }

    public function testCompositeCommand(): void
    {
        $path1 = $this->testDir . '/a.txt';
        $path2 = $this->testDir . '/b.txt';

        $composite = new CompositeCommand('バッチ作成');
        $composite->addCommand(new CreateFileCommand($path1, 'aaa'));
        $composite->addCommand(new CreateFileCommand($path2, 'bbb'));

        $composite->execute();

        $this->assertFileExists($path1);
        $this->assertFileExists($path2);
    }

    public function testCompositeCommandUndo(): void
    {
        $path1 = $this->testDir . '/a.txt';
        $path2 = $this->testDir . '/b.txt';

        $composite = new CompositeCommand('バッチ作成');
        $composite->addCommand(new CreateFileCommand($path1, 'aaa'));
        $composite->addCommand(new CreateFileCommand($path2, 'bbb'));

        $composite->execute();
        $composite->undo();

        $this->assertFileDoesNotExist($path1);
        $this->assertFileDoesNotExist($path2);
    }

    public function testCommandDescription(): void
    {
        $cmd = new CreateFileCommand('/tmp/x.txt', '');
        $this->assertStringContainsString('ファイル作成', $cmd->getDescription());
    }
}
