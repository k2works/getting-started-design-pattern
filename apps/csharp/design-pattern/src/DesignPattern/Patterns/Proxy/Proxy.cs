namespace DesignPattern.Patterns.Proxy;

public interface IBankAccount
{
    string Deposit(decimal amount);
    string Withdraw(decimal amount);
    decimal Balance { get; }
}

public class RealBankAccount : IBankAccount
{
    private decimal _balance;

    public RealBankAccount(decimal initialBalance)
    {
        _balance = initialBalance;
    }

    public decimal Balance => _balance;

    public string Deposit(decimal amount)
    {
        _balance += amount;
        return $"Deposited {amount:C}. Balance: {_balance:C}";
    }

    public string Withdraw(decimal amount)
    {
        if (amount > _balance)
            return $"Insufficient funds. Balance: {_balance:C}";

        _balance -= amount;
        return $"Withdrew {amount:C}. Balance: {_balance:C}";
    }
}

public class ProtectionProxy : IBankAccount
{
    private readonly IBankAccount _realAccount;
    private readonly string _ownerPassword;

    public ProtectionProxy(IBankAccount realAccount, string ownerPassword)
    {
        _realAccount = realAccount;
        _ownerPassword = ownerPassword;
    }

    public decimal Balance => _realAccount.Balance;

    private bool _authenticated;

    public string Authenticate(string password)
    {
        _authenticated = password == _ownerPassword;
        return _authenticated ? "Authentication successful" : "Authentication failed";
    }

    public string Deposit(decimal amount)
    {
        if (!_authenticated)
            return "Access denied: not authenticated";
        return _realAccount.Deposit(amount);
    }

    public string Withdraw(decimal amount)
    {
        if (!_authenticated)
            return "Access denied: not authenticated";
        return _realAccount.Withdraw(amount);
    }
}

public class VirtualProxy : IBankAccount
{
    private readonly Lazy<IBankAccount> _realAccount;
    private readonly List<string> _log = new();

    public List<string> Log => _log;

    public VirtualProxy(Func<IBankAccount> factory)
    {
        _realAccount = new Lazy<IBankAccount>(() =>
        {
            _log.Add("Creating real bank account (lazy initialization)");
            return factory();
        });
    }

    public bool IsCreated => _realAccount.IsValueCreated;

    public decimal Balance => _realAccount.Value.Balance;

    public string Deposit(decimal amount) => _realAccount.Value.Deposit(amount);

    public string Withdraw(decimal amount) => _realAccount.Value.Withdraw(amount);
}
