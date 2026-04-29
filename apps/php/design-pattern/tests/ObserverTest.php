<?php

declare(strict_types=1);

namespace DesignPattern\Tests;

use DesignPattern\Observer\Employee;
use DesignPattern\Observer\Payroll;
use DesignPattern\Observer\TaxMan;
use PHPUnit\Framework\TestCase;

class ObserverTest extends TestCase
{
    public function testPayrollIsNotifiedOnSalaryChange(): void
    {
        $employee = new Employee('田中', 'エンジニア', 500000);
        $payroll = new Payroll();
        $employee->addObserver($payroll);

        $employee->setSalary(600000);

        $this->assertCount(1, $payroll->getLog());
        $this->assertStringContainsString('田中', $payroll->getLog()[0]);
        $this->assertStringContainsString('600000', $payroll->getLog()[0]);
    }

    public function testTaxManIsNotifiedOnSalaryChange(): void
    {
        $employee = new Employee('鈴木', 'マネージャー', 700000);
        $taxMan = new TaxMan();
        $employee->addObserver($taxMan);

        $employee->setSalary(800000);

        $this->assertCount(1, $taxMan->getLog());
        $this->assertStringContainsString('鈴木', $taxMan->getLog()[0]);
    }

    public function testMultipleObserversNotified(): void
    {
        $employee = new Employee('佐藤', 'リード', 600000);
        $payroll = new Payroll();
        $taxMan = new TaxMan();
        $employee->addObserver($payroll);
        $employee->addObserver($taxMan);

        $employee->setSalary(700000);

        $this->assertCount(1, $payroll->getLog());
        $this->assertCount(1, $taxMan->getLog());
    }

    public function testRemoveObserver(): void
    {
        $employee = new Employee('高橋', 'PM', 650000);
        $payroll = new Payroll();
        $employee->addObserver($payroll);
        $employee->removeObserver($payroll);

        $employee->setSalary(750000);

        $this->assertCount(0, $payroll->getLog());
    }

    public function testTitleChangeNotifiesObservers(): void
    {
        $employee = new Employee('山田', 'ジュニア', 400000);
        $payroll = new Payroll();
        $employee->addObserver($payroll);

        $employee->setTitle('シニア');

        $this->assertCount(1, $payroll->getLog());
        $this->assertSame('シニア', $employee->getTitle());
    }

    public function testInitialState(): void
    {
        $employee = new Employee('伊藤', 'CTO', 1000000);

        $this->assertSame('伊藤', $employee->getName());
        $this->assertSame('CTO', $employee->getTitle());
        $this->assertSame(1000000.0, $employee->getSalary());
    }
}
