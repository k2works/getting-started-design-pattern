<?php

declare(strict_types=1);

namespace DesignPattern\Observer;

class Payroll implements Observer
{
    /** @var string[] */
    private array $log = [];

    public function update(Employee $employee): void
    {
        $this->log[] = sprintf(
            '%s の給与を %.0f に変更しました',
            $employee->getName(),
            $employee->getSalary()
        );
    }

    /** @return string[] */
    public function getLog(): array
    {
        return $this->log;
    }
}
