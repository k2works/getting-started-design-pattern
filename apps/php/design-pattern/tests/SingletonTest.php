<?php

declare(strict_types=1);

namespace DesignPattern\Tests;

use DesignPattern\Singleton\SingletonLogger;
use PHPUnit\Framework\TestCase;

class SingletonTest extends TestCase
{
    protected function setUp(): void
    {
        SingletonLogger::resetInstance();
    }

    public function testGetInstanceReturnsSameObject(): void
    {
        $logger1 = SingletonLogger::getInstance();
        $logger2 = SingletonLogger::getInstance();

        $this->assertSame($logger1, $logger2);
    }

    public function testLogMessages(): void
    {
        $logger = SingletonLogger::getInstance();
        $logger->log('テスト開始');
        $logger->log('テスト完了');

        $this->assertSame(['テスト開始', 'テスト完了'], $logger->getLog());
    }

    public function testClearLog(): void
    {
        $logger = SingletonLogger::getInstance();
        $logger->log('メッセージ');
        $logger->clear();

        $this->assertEmpty($logger->getLog());
    }

    public function testSharedStateBetweenReferences(): void
    {
        $logger1 = SingletonLogger::getInstance();
        $logger1->log('from logger1');

        $logger2 = SingletonLogger::getInstance();
        $logger2->log('from logger2');

        $this->assertSame(['from logger1', 'from logger2'], $logger1->getLog());
    }

    public function testResetInstance(): void
    {
        $logger1 = SingletonLogger::getInstance();
        $logger1->log('before reset');

        SingletonLogger::resetInstance();
        $logger2 = SingletonLogger::getInstance();

        $this->assertEmpty($logger2->getLog());
        $this->assertNotSame($logger1, $logger2);
    }
}
