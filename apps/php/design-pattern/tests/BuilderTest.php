<?php

declare(strict_types=1);

namespace DesignPattern\Tests;

use DesignPattern\Builder\Computer;
use DesignPattern\Builder\DesktopBuilder;
use DesignPattern\Builder\Drive;
use DesignPattern\Builder\LaptopBuilder;
use DesignPattern\Builder\Motherboard;
use PHPUnit\Framework\TestCase;

class BuilderTest extends TestCase
{
    public function testBuildDesktop(): void
    {
        $builder = new DesktopBuilder();
        $computer = $builder
            ->setDisplay('27インチ 4K')
            ->setMotherboard(new Motherboard('ASUS ROG'))
            ->addDrive(new Drive('SSD', 1000))
            ->setMemoryGb(32)
            ->build();

        $this->assertSame('27インチ 4K', $computer->getDisplay());
        $this->assertSame('ASUS ROG', $computer->getMotherboard()->getModel());
        $this->assertCount(1, $computer->getDrives());
        $this->assertSame(32, $computer->getMemoryGb());
    }

    public function testBuildLaptop(): void
    {
        $builder = new LaptopBuilder();
        $computer = $builder
            ->setDisplay('15インチ FHD')
            ->setMotherboard(new Motherboard('Intel NUC'))
            ->addDrive(new Drive('SSD', 512))
            ->setMemoryGb(16)
            ->build();

        $this->assertSame('15インチ FHD', $computer->getDisplay());
        $this->assertSame(16, $computer->getMemoryGb());
    }

    public function testDesktopRequiresDisplay(): void
    {
        $builder = new DesktopBuilder();
        $builder->setMotherboard(new Motherboard('X'))
            ->addDrive(new Drive('SSD', 500))
            ->setMemoryGb(16);

        $this->expectException(\RuntimeException::class);
        $this->expectExceptionMessage('ディスプレイが設定されていません');
        $builder->build();
    }

    public function testDesktopRequiresDrive(): void
    {
        $builder = new DesktopBuilder();
        $builder->setDisplay('Monitor')
            ->setMotherboard(new Motherboard('X'))
            ->setMemoryGb(16);

        $this->expectException(\RuntimeException::class);
        $this->expectExceptionMessage('ドライブが1つも追加されていません');
        $builder->build();
    }

    public function testLaptopMaxTwoDrives(): void
    {
        $builder = new LaptopBuilder();
        $builder->setDisplay('14インチ')
            ->setMotherboard(new Motherboard('Y'))
            ->addDrive(new Drive('SSD', 256))
            ->addDrive(new Drive('SSD', 512))
            ->addDrive(new Drive('HDD', 1000))
            ->setMemoryGb(8);

        $this->expectException(\RuntimeException::class);
        $this->expectExceptionMessage('ラップトップのドライブは2つまでです');
        $builder->build();
    }

    public function testComputerDescribe(): void
    {
        $computer = new Computer(
            'テスト画面',
            new Motherboard('テストMB'),
            [new Drive('SSD', 500)],
            16
        );

        $desc = $computer->describe();
        $this->assertStringContainsString('テスト画面', $desc);
        $this->assertStringContainsString('テストMB', $desc);
        $this->assertStringContainsString('SSD 500GB', $desc);
        $this->assertStringContainsString('16GB RAM', $desc);
    }

    public function testBuilderReset(): void
    {
        $builder = new DesktopBuilder();
        $builder->setDisplay('Monitor')
            ->setMotherboard(new Motherboard('MB'))
            ->addDrive(new Drive('SSD', 500))
            ->setMemoryGb(16);

        $builder->reset();

        $this->expectException(\RuntimeException::class);
        $builder->build();
    }
}
