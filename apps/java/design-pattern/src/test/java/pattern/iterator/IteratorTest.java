package pattern.iterator;

import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class IteratorTest {

    @Test
    void accountHasNameAndBalance() {
        Account account = new Account("普通預金", 1000);
        assertEquals("普通預金", account.getName());
        assertEquals(1000, account.getBalance());
    }

    @Test
    void accountsAreComparableByBalance() {
        Account low = new Account("普通預金", 1000);
        Account high = new Account("定期預金", 5000);

        assertTrue(low.compareTo(high) < 0);
        assertTrue(high.compareTo(low) > 0);
        assertEquals(0, low.compareTo(new Account("別口座", 1000)));
    }

    @Test
    void accountsCanBeSortedByBalance() {
        List<Account> accounts = new ArrayList<>();
        accounts.add(new Account("定期預金", 5000));
        accounts.add(new Account("普通預金", 1000));
        accounts.add(new Account("投資信託", 3000));

        Collections.sort(accounts);

        assertEquals("普通預金", accounts.get(0).getName());
        assertEquals("投資信託", accounts.get(1).getName());
        assertEquals("定期預金", accounts.get(2).getName());
    }

    @Test
    void portfolioIsIterable() {
        Portfolio portfolio = new Portfolio();
        portfolio.addAccount(new Account("普通預金", 1000));
        portfolio.addAccount(new Account("定期預金", 5000));

        List<String> names = new ArrayList<>();
        for (Account account : portfolio) {
            names.add(account.getName());
        }

        assertEquals(2, names.size());
        assertEquals("普通預金", names.get(0));
        assertEquals("定期預金", names.get(1));
    }

    @Test
    void portfolioSupportsStreamOperations() {
        Portfolio portfolio = new Portfolio();
        portfolio.addAccount(new Account("普通預金", 1000));
        portfolio.addAccount(new Account("定期預金", 5000));
        portfolio.addAccount(new Account("投資信託", 3000));

        int totalBalance = portfolio.stream()
                .mapToInt(Account::getBalance)
                .sum();

        assertEquals(9000, totalBalance);
    }

    @Test
    void portfolioCanFilterHighBalanceAccounts() {
        Portfolio portfolio = new Portfolio();
        portfolio.addAccount(new Account("普通預金", 1000));
        portfolio.addAccount(new Account("定期預金", 5000));
        portfolio.addAccount(new Account("投資信託", 3000));

        List<Account> highBalance = portfolio.stream()
                .filter(a -> a.getBalance() >= 3000)
                .toList();

        assertEquals(2, highBalance.size());
    }

    @Test
    void emptyPortfolioIteratesOverNothing() {
        Portfolio portfolio = new Portfolio();
        List<Account> accounts = new ArrayList<>();
        for (Account account : portfolio) {
            accounts.add(account);
        }

        assertTrue(accounts.isEmpty());
    }
}
