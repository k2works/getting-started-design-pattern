<?php

declare(strict_types=1);

namespace DesignPattern\Tests;

use DesignPattern\Decorator\NumberingWriter;
use DesignPattern\Decorator\SimpleWriter;
use DesignPattern\Decorator\TimeStampingWriter;
use PHPUnit\Framework\TestCase;

class DecoratorTest extends TestCase
{
    public function testSimpleWriter(): void
    {
        $writer = new SimpleWriter();
        $writer->writeLine('Hello');
        $writer->writeLine('World');

        $this->assertSame(['Hello', 'World'], $writer->getOutput());
    }

    public function testNumberingWriter(): void
    {
        $writer = new NumberingWriter(new SimpleWriter());
        $writer->writeLine('Hello');
        $writer->writeLine('World');

        $this->assertSame(['1: Hello', '2: World'], $writer->getOutput());
    }

    public function testTimeStampingWriter(): void
    {
        $writer = new TimeStampingWriter(new SimpleWriter(), '2024-01-01 12:00:00');
        $writer->writeLine('Hello');

        $this->assertSame(['[2024-01-01 12:00:00] Hello'], $writer->getOutput());
    }

    public function testNumberingThenTimeStamping(): void
    {
        // Numbering(外) -> TimeStamping(内) -> SimpleWriter
        // Numbering が "1: Hello" を作り、TimeStamping が "[ts] 1: Hello" にする
        $writer = new NumberingWriter(
            new TimeStampingWriter(new SimpleWriter(), '2024-01-01 12:00:00')
        );
        $writer->writeLine('Hello');
        $writer->writeLine('World');

        $expected = [
            '[2024-01-01 12:00:00] 1: Hello',
            '[2024-01-01 12:00:00] 2: World',
        ];
        $this->assertSame($expected, $writer->getOutput());
    }

    public function testTimeStampingThenNumbering(): void
    {
        // TimeStamping(外) -> Numbering(内) -> SimpleWriter
        // TimeStamping が "[ts] Hello" を作り、Numbering が "1: [ts] Hello" にする
        $writer = new TimeStampingWriter(
            new NumberingWriter(new SimpleWriter()),
            '2024-01-01 12:00:00'
        );
        $writer->writeLine('Hello');
        $writer->writeLine('World');

        $expected = [
            '1: [2024-01-01 12:00:00] Hello',
            '2: [2024-01-01 12:00:00] World',
        ];
        $this->assertSame($expected, $writer->getOutput());
    }
}
