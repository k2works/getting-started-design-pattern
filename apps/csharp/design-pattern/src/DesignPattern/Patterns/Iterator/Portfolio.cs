using System.Collections;

namespace DesignPattern.Patterns.Iterator;

public class Account : IComparable<Account>
{
    public string Name { get; }
    public decimal Balance { get; }

    public Account(string name, decimal balance)
    {
        Name = name;
        Balance = balance;
    }

    public int CompareTo(Account? other) =>
        Balance.CompareTo(other?.Balance ?? 0);

    public override string ToString() => $"{Name}: {Balance:C}";
}

public class Portfolio : IEnumerable<Account>
{
    private readonly List<Account> _accounts = new();

    public void Add(Account account) => _accounts.Add(account);

    public int Count => _accounts.Count;

    public decimal TotalBalance =>
        _accounts.Sum(a => a.Balance);

    public IEnumerable<Account> HighValueAccounts(decimal threshold) =>
        _accounts.Where(a => a.Balance >= threshold);

    public IEnumerable<Account> SortedByBalance() =>
        _accounts.OrderBy(a => a);

    public IEnumerable<string> AccountNames() =>
        _accounts.Select(a => a.Name);

    public IEnumerator<Account> GetEnumerator() =>
        _accounts.GetEnumerator();

    IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();
}
