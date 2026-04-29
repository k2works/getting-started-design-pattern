using DesignPattern.Patterns.Proxy;

namespace DesignPattern.Tests.Patterns;

public class ProxyTest
{
    [Fact]
    public void RealBankAccount_Deposit_IncreasesBalance()
    {
        var account = new RealBankAccount(100m);
        account.Deposit(50m);

        Assert.Equal(150m, account.Balance);
    }

    [Fact]
    public void RealBankAccount_Withdraw_DecreasesBalance()
    {
        var account = new RealBankAccount(100m);
        account.Withdraw(30m);

        Assert.Equal(70m, account.Balance);
    }

    [Fact]
    public void RealBankAccount_Withdraw_InsufficientFunds()
    {
        var account = new RealBankAccount(100m);
        var result = account.Withdraw(200m);

        Assert.Contains("Insufficient funds", result);
        Assert.Equal(100m, account.Balance);
    }

    [Fact]
    public void ProtectionProxy_DeniesAccessWithoutAuth()
    {
        var real = new RealBankAccount(100m);
        var proxy = new ProtectionProxy(real, "secret123");

        var result = proxy.Deposit(50m);

        Assert.Contains("Access denied", result);
    }

    [Fact]
    public void ProtectionProxy_AllowsAccessAfterAuth()
    {
        var real = new RealBankAccount(100m);
        var proxy = new ProtectionProxy(real, "secret123");
        proxy.Authenticate("secret123");

        var result = proxy.Deposit(50m);

        Assert.Contains("Deposited", result);
        Assert.Equal(150m, proxy.Balance);
    }

    [Fact]
    public void ProtectionProxy_RejectsWrongPassword()
    {
        var real = new RealBankAccount(100m);
        var proxy = new ProtectionProxy(real, "secret123");
        var authResult = proxy.Authenticate("wrong");

        Assert.Contains("failed", authResult);
    }

    [Fact]
    public void VirtualProxy_DoesNotCreateUntilAccessed()
    {
        var proxy = new VirtualProxy(() => new RealBankAccount(100m));

        Assert.False(proxy.IsCreated);
    }

    [Fact]
    public void VirtualProxy_CreatesOnFirstAccess()
    {
        var proxy = new VirtualProxy(() => new RealBankAccount(100m));

        var balance = proxy.Balance;

        Assert.True(proxy.IsCreated);
        Assert.Equal(100m, balance);
        Assert.Single(proxy.Log);
    }
}
