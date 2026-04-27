package pattern.proxy;

/**
 * 実際の銀行口座（Real Subject）。
 */
public class RealBankAccount implements BankAccount {
    private int balance;

    public RealBankAccount(int startingBalance) {
        this.balance = startingBalance;
    }

    @Override
    public void deposit(int amount) {
        balance += amount;
    }

    @Override
    public void withdraw(int amount) {
        balance -= amount;
    }

    @Override
    public int getBalance() {
        return balance;
    }
}
