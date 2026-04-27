package pattern.iterator;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.stream.Stream;
import java.util.stream.StreamSupport;

/**
 * ポートフォリオクラス（Iterator パターン - Iterable を活用）
 *
 * Iterable を実装することで、拡張 for ループや Stream API が使える。
 */
public class Portfolio implements Iterable<Account> {

    private final List<Account> accounts = new ArrayList<>();

    public void addAccount(Account account) {
        accounts.add(account);
    }

    @Override
    public Iterator<Account> iterator() {
        return accounts.iterator();
    }

    public Stream<Account> stream() {
        return StreamSupport.stream(spliterator(), false);
    }
}
