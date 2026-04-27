package pattern.proxy;

/**
 * 保護プロキシ。
 * 所有者のみがアクセスできるよう制御する。
 */
public class AccountProtectionProxy implements BankAccount {
    private final BankAccount realAccount;
    private final String ownerName;

    public AccountProtectionProxy(BankAccount realAccount, String ownerName) {
        this.realAccount = realAccount;
        this.ownerName = ownerName;
    }

    @Override
    public void deposit(int amount) {
        checkAccess();
        realAccount.deposit(amount);
    }

    @Override
    public void withdraw(int amount) {
        checkAccess();
        realAccount.withdraw(amount);
    }

    @Override
    public int getBalance() {
        checkAccess();
        return realAccount.getBalance();
    }

    private void checkAccess() {
        String currentUser = System.getProperty("user.name");
        if (!ownerName.equals(currentUser)) {
            throw new IllegalAccessError(
                    "Illegal access: " + currentUser + " cannot access account.");
        }
    }
}
