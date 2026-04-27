<?php

declare(strict_types=1);

namespace DesignPattern\Iterator;

class Account
{
    private string $name;
    private float $balance;

    public function __construct(string $name, float $balance)
    {
        $this->name = $name;
        $this->balance = $balance;
    }

    public function getName(): string
    {
        return $this->name;
    }

    public function getBalance(): float
    {
        return $this->balance;
    }

    public function compareTo(Account $other): int
    {
        return $this->balance <=> $other->balance;
    }
}

/**
 * @implements \IteratorAggregate<int, Account>
 */
class Portfolio implements \IteratorAggregate, \Countable
{
    /** @var Account[] */
    private array $accounts = [];

    public function addAccount(Account $account): void
    {
        $this->accounts[] = $account;
    }

    public function totalBalance(): float
    {
        return array_sum(array_map(fn(Account $a) => $a->getBalance(), $this->accounts));
    }

    public function count(): int
    {
        return count($this->accounts);
    }

    /** @return Account[] */
    public function sortedByBalance(): array
    {
        $sorted = $this->accounts;
        usort($sorted, fn(Account $a, Account $b) => $a->compareTo($b));
        return $sorted;
    }

    public function any(callable $predicate): bool
    {
        foreach ($this->accounts as $account) {
            if ($predicate($account)) {
                return true;
            }
        }
        return false;
    }

    public function all(callable $predicate): bool
    {
        foreach ($this->accounts as $account) {
            if (!$predicate($account)) {
                return false;
            }
        }
        return true;
    }

    /** @return \ArrayIterator<int, Account> */
    public function getIterator(): \ArrayIterator
    {
        return new \ArrayIterator($this->accounts);
    }
}
