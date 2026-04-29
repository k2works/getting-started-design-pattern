<?php

declare(strict_types=1);

namespace DesignPattern\Tests;

use DesignPattern\Proxy\ProtectionProxy;
use DesignPattern\Proxy\RealBankAccount;
use DesignPattern\Proxy\VirtualProxy;
use PHPUnit\Framework\TestCase;

class ProxyTest extends TestCase
{
    public function testRealBankAccountDeposit(): void
    {
        $account = new RealBankAccount(1000);
        $account->deposit(500);

        $this->assertSame(1500.0, $account->getBalance());
    }

    public function testRealBankAccountWithdraw(): void
    {
        $account = new RealBankAccount(1000);
        $account->withdraw(300);

        $this->assertSame(700.0, $account->getBalance());
    }

    public function testRealBankAccountInsufficientFunds(): void
    {
        $account = new RealBankAccount(100);

        $this->expectException(\RuntimeException::class);
        $this->expectExceptionMessage('残高不足');
        $account->withdraw(200);
    }

    public function testProtectionProxy(): void
    {
        $real = new RealBankAccount(5000);
        $proxy = new ProtectionProxy($real, '山田太郎');

        $proxy->deposit(1000);
        $this->assertSame(6000.0, $proxy->getBalance());
        $this->assertSame('山田太郎', $proxy->getOwnerName());
    }

    public function testVirtualProxyLazyLoading(): void
    {
        $loaded = false;
        $proxy = new VirtualProxy(function () use (&$loaded) {
            $loaded = true;
            return new RealBankAccount(10000);
        });

        $this->assertFalse($proxy->isLoaded());

        $balance = $proxy->getBalance();
        $this->assertTrue($proxy->isLoaded());
        $this->assertSame(10000.0, $balance);
    }

    public function testVirtualProxyOperations(): void
    {
        $proxy = new VirtualProxy(fn() => new RealBankAccount(5000));

        $proxy->deposit(1000);
        $proxy->withdraw(2000);

        $this->assertSame(4000.0, $proxy->getBalance());
    }
}
