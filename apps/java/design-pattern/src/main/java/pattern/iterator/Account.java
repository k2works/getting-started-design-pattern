package pattern.iterator;

/**
 * 口座クラス（Iterator パターン）
 *
 * Comparable を実装し、残高による自然順序を持つ。
 */
public class Account implements Comparable<Account> {

    private final String name;
    private final int balance;

    public Account(String name, int balance) {
        this.name = name;
        this.balance = balance;
    }

    public String getName() {
        return name;
    }

    public int getBalance() {
        return balance;
    }

    @Override
    public int compareTo(Account other) {
        return Integer.compare(this.balance, other.balance);
    }
}
