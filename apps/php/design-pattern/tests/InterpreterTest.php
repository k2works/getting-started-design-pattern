<?php

declare(strict_types=1);

namespace DesignPattern\Tests;

use DesignPattern\Interpreter\All;
use DesignPattern\Interpreter\AndExpression;
use DesignPattern\Interpreter\Bigger;
use DesignPattern\Interpreter\FileName;
use DesignPattern\Interpreter\NotExpression;
use DesignPattern\Interpreter\OrExpression;
use PHPUnit\Framework\TestCase;

class InterpreterTest extends TestCase
{
    private string $testDir;

    protected function setUp(): void
    {
        $this->testDir = sys_get_temp_dir() . '/design_pattern_interpreter_test_' . uniqid();
        mkdir($this->testDir, 0777, true);

        file_put_contents($this->testDir . '/small.txt', 'hi');
        file_put_contents($this->testDir . '/big.txt', str_repeat('x', 200));
        file_put_contents($this->testDir . '/image.png', str_repeat('y', 300));
        file_put_contents($this->testDir . '/doc.txt', str_repeat('z', 50));
    }

    protected function tearDown(): void
    {
        $files = glob($this->testDir . '/*');
        if ($files) {
            array_map('unlink', $files);
        }
        if (is_dir($this->testDir)) {
            rmdir($this->testDir);
        }
    }

    public function testAllExpression(): void
    {
        $expr = new All();
        $result = $expr->evaluate($this->testDir);

        $this->assertCount(4, $result);
    }

    public function testFileNameExpression(): void
    {
        $expr = new FileName('*.txt');
        $result = $expr->evaluate($this->testDir);

        $this->assertCount(3, $result);
        foreach ($result as $path) {
            $this->assertStringEndsWith('.txt', $path);
        }
    }

    public function testBiggerExpression(): void
    {
        $expr = new Bigger(100);
        $result = $expr->evaluate($this->testDir);

        $this->assertCount(2, $result);
    }

    public function testAndExpression(): void
    {
        $expr = new AndExpression(new FileName('*.txt'), new Bigger(100));
        $result = $expr->evaluate($this->testDir);

        $this->assertCount(1, $result);
        $this->assertStringContainsString('big.txt', $result[0]);
    }

    public function testOrExpression(): void
    {
        $expr = new OrExpression(new FileName('*.png'), new Bigger(100));
        $result = $expr->evaluate($this->testDir);

        // image.png (matches both) + big.txt (matches bigger)
        $this->assertCount(2, $result);
    }

    public function testNotExpression(): void
    {
        $expr = new NotExpression(new FileName('*.txt'));
        $result = $expr->evaluate($this->testDir);

        $this->assertCount(1, $result);
        $this->assertStringContainsString('image.png', $result[0]);
    }

    public function testComplexExpression(): void
    {
        // txt files that are NOT bigger than 100 bytes
        $expr = new AndExpression(
            new FileName('*.txt'),
            new NotExpression(new Bigger(100))
        );
        $result = $expr->evaluate($this->testDir);

        $names = array_map('basename', $result);
        $this->assertContains('small.txt', $names);
        $this->assertContains('doc.txt', $names);
        $this->assertNotContains('big.txt', $names);
    }
}
