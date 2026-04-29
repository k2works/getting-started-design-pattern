package pattern.proxy;

/**
 * 銀行口座インターフェース（Subject）。
 */
public interface BankAccount {
    void deposit(int amount);

    void withdraw(int amount);

    int getBalance();
}
