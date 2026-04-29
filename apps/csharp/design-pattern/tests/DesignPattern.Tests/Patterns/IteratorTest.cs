using DesignPattern.Patterns.Iterator;

namespace DesignPattern.Tests.Patterns;

public class IteratorTest
{
    private Portfolio CreateSamplePortfolio()
    {
        var portfolio = new Portfolio();
        portfolio.Add(new Account("Savings", 1000m));
        portfolio.Add(new Account("Checking", 500m));
        portfolio.Add(new Account("Investment", 5000m));
        return portfolio;
    }

    [Fact]
    public void Portfolio_IsEnumerable()
    {
        var portfolio = CreateSamplePortfolio();

        Assert.Equal(3, portfolio.Count);
    }

    [Fact]
    public void Portfolio_CanBeIteratedWithForeach()
    {
        var portfolio = CreateSamplePortfolio();
        var names = new List<string>();

        foreach (var account in portfolio)
        {
            names.Add(account.Name);
        }

        Assert.Equal(["Savings", "Checking", "Investment"], names);
    }

    [Fact]
    public void Portfolio_TotalBalance_SumsAllAccounts()
    {
        var portfolio = CreateSamplePortfolio();

        Assert.Equal(6500m, portfolio.TotalBalance);
    }

    [Fact]
    public void Portfolio_HighValueAccounts_FiltersCorrectly()
    {
        var portfolio = CreateSamplePortfolio();

        var highValue = portfolio.HighValueAccounts(1000m).ToList();

        Assert.Equal(2, highValue.Count);
        Assert.Contains(highValue, a => a.Name == "Savings");
        Assert.Contains(highValue, a => a.Name == "Investment");
    }

    [Fact]
    public void Portfolio_SortedByBalance_ReturnsAscending()
    {
        var portfolio = CreateSamplePortfolio();

        var sorted = portfolio.SortedByBalance().ToList();

        Assert.Equal("Checking", sorted[0].Name);
        Assert.Equal("Investment", sorted[2].Name);
    }

    [Fact]
    public void Portfolio_AccountNames_ReturnsProjection()
    {
        var portfolio = CreateSamplePortfolio();

        var names = portfolio.AccountNames().ToList();

        Assert.Equal(["Savings", "Checking", "Investment"], names);
    }

    [Fact]
    public void Account_CompareTo_OrdersByBalance()
    {
        var low = new Account("Low", 100m);
        var high = new Account("High", 1000m);

        Assert.True(low.CompareTo(high) < 0);
    }
}
