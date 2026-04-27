<?php

declare(strict_types=1);

namespace DesignPattern\Singleton;

class SingletonLogger
{
    private static ?SingletonLogger $instance = null;

    /** @var string[] */
    private array $log = [];

    private function __construct()
    {
        // 外部からのインスタンス化を禁止
    }

    private function __clone()
    {
        // クローンを禁止
    }

    public static function getInstance(): self
    {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    public static function resetInstance(): void
    {
        self::$instance = null;
    }

    public function log(string $message): void
    {
        $this->log[] = $message;
    }

    /** @return string[] */
    public function getLog(): array
    {
        return $this->log;
    }

    public function clear(): void
    {
        $this->log = [];
    }
}
