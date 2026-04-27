<?php

declare(strict_types=1);

namespace DesignPattern\Proxy;

interface BankAccount
{
    public function deposit(float $amount): void;

    public function withdraw(float $amount): void;

    public function getBalance(): float;
}

class RealBankAccount implements BankAccount
{
    private float $balance;

    public function __construct(float $balance = 0.0)
    {
        $this->balance = $balance;
    }

    public function deposit(float $amount): void
    {
        $this->balance += $amount;
    }

    public function withdraw(float $amount): void
    {
        if ($amount > $this->balance) {
            throw new \RuntimeException('残高不足です');
        }
        $this->balance -= $amount;
    }

    public function getBalance(): float
    {
        return $this->balance;
    }
}

class ProtectionProxy implements BankAccount
{
    private RealBankAccount $realAccount;
    private string $ownerName;

    public function __construct(RealBankAccount $realAccount, string $ownerName)
    {
        $this->realAccount = $realAccount;
        $this->ownerName = $ownerName;
    }

    public function deposit(float $amount): void
    {
        $this->realAccount->deposit($amount);
    }

    public function withdraw(float $amount): void
    {
        $this->realAccount->withdraw($amount);
    }

    public function getBalance(): float
    {
        return $this->realAccount->getBalance();
    }

    public function getOwnerName(): string
    {
        return $this->ownerName;
    }
}

class VirtualProxy implements BankAccount
{
    /** @var callable(): RealBankAccount */
    private $factory;
    private ?RealBankAccount $realAccount = null;

    /** @param callable(): RealBankAccount $factory */
    public function __construct(callable $factory)
    {
        $this->factory = $factory;
    }

    public function deposit(float $amount): void
    {
        $this->getRealAccount()->deposit($amount);
    }

    public function withdraw(float $amount): void
    {
        $this->getRealAccount()->withdraw($amount);
    }

    public function getBalance(): float
    {
        return $this->getRealAccount()->getBalance();
    }

    public function isLoaded(): bool
    {
        return $this->realAccount !== null;
    }

    private function getRealAccount(): RealBankAccount
    {
        if ($this->realAccount === null) {
            $this->realAccount = ($this->factory)();
        }
        return $this->realAccount;
    }
}
