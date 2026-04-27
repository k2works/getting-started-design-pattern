<?php

declare(strict_types=1);

namespace DesignPattern\Tests;

use DesignPattern\Iterator\Account;
use DesignPattern\Iterator\Portfolio;
use PHPUnit\Framework\TestCase;

class IteratorTest extends TestCase
{
    private Portfolio $portfolio;

    protected function setUp(): void
    {
        $this->portfolio = new Portfolio();
        $this->portfolio->addAccount(new Account('普通預金', 100000));
        $this->portfolio->addAccount(new Account('定期預金', 500000));
        $this->portfolio->addAccount(new Account('投資信託', 300000));
    }

    public function testTotalBalance(): void
    {
        $this->assertSame(900000.0, $this->portfolio->totalBalance());
    }

    public function testCount(): void
    {
        $this->assertCount(3, $this->portfolio);
    }

    public function testIteration(): void
    {
        $names = [];
        foreach ($this->portfolio as $account) {
            $names[] = $account->getName();
        }
        $this->assertSame(['普通預金', '定期預金', '投資信託'], $names);
    }

    public function testSortedByBalance(): void
    {
        $sorted = $this->portfolio->sortedByBalance();
        $this->assertSame('普通預金', $sorted[0]->getName());
        $this->assertSame('投資信託', $sorted[1]->getName());
        $this->assertSame('定期預金', $sorted[2]->getName());
    }

    public function testAny(): void
    {
        $this->assertTrue(
            $this->portfolio->any(fn(Account $a) => $a->getBalance() >= 500000)
        );
        $this->assertFalse(
            $this->portfolio->any(fn(Account $a) => $a->getBalance() >= 1000000)
        );
    }

    public function testAll(): void
    {
        $this->assertTrue(
            $this->portfolio->all(fn(Account $a) => $a->getBalance() > 0)
        );
        $this->assertFalse(
            $this->portfolio->all(fn(Account $a) => $a->getBalance() >= 300000)
        );
    }

    public function testAccountCompareTo(): void
    {
        $a = new Account('A', 100);
        $b = new Account('B', 200);

        $this->assertLessThan(0, $a->compareTo($b));
        $this->assertGreaterThan(0, $b->compareTo($a));
        $this->assertSame(0, $a->compareTo(new Account('C', 100)));
    }
}
