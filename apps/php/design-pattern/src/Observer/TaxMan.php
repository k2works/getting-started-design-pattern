<?php

declare(strict_types=1);

namespace DesignPattern\Observer;

class TaxMan implements Observer
{
    /** @var string[] */
    private array $log = [];

    public function update(Employee $employee): void
    {
        $this->log[] = sprintf(
            '%s に新しい税金の通知を送信しました',
            $employee->getName()
        );
    }

    /** @return string[] */
    public function getLog(): array
    {
        return $this->log;
    }
}
