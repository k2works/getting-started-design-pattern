package pattern.proxy;

import java.util.function.Supplier;

/**
 * 仮想プロキシ（遅延初期化）。
 * Supplier を使い、最初のアクセス時にのみ実体を生成する。
 */
public class VirtualAccountProxy implements BankAccount {
    private final Supplier<BankAccount> supplier;
    private BankAccount subject;

    public VirtualAccountProxy(Supplier<BankAccount> supplier) {
        this.supplier = supplier;
    }

    @Override
    public void deposit(int amount) {
        getSubject().deposit(amount);
    }

    @Override
    public void withdraw(int amount) {
        getSubject().withdraw(amount);
    }

    @Override
    public int getBalance() {
        return getSubject().getBalance();
    }

    private BankAccount getSubject() {
        if (subject == null) {
            subject = supplier.get();
        }
        return subject;
    }
}
