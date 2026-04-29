package pattern.proxy;

import org.junit.jupiter.api.Test;

import java.util.concurrent.atomic.AtomicBoolean;
import java.util.function.Supplier;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

class ProxyTest {

    @Test
    void realBankAccountDepositsAndWithdraws() {
        BankAccount account = new RealBankAccount(100);

        account.deposit(50);
        assertEquals(150, account.getBalance());

        account.withdraw(30);
        assertEquals(120, account.getBalance());
    }

    @Test
    void protectionProxyAllowsOwnerAccess() {
        BankAccount real = new RealBankAccount(100);
        String currentUser = System.getProperty("user.name");
        BankAccount proxy = new AccountProtectionProxy(real, currentUser);

        proxy.deposit(50);
        assertEquals(150, proxy.getBalance());
    }

    @Test
    void protectionProxyDeniesNonOwnerAccess() {
        BankAccount real = new RealBankAccount(100);
        BankAccount proxy = new AccountProtectionProxy(real, "not_the_owner");

        assertThrows(IllegalAccessError.class, () -> proxy.deposit(50));
        assertThrows(IllegalAccessError.class, proxy::getBalance);
    }

    @Test
    void virtualProxyDefersCreationUntilFirstUse() {
        AtomicBoolean created = new AtomicBoolean(false);
        Supplier<BankAccount> supplier = () -> {
            created.set(true);
            return new RealBankAccount(100);
        };

        VirtualAccountProxy proxy = new VirtualAccountProxy(supplier);
        assertFalse(created.get());

        proxy.deposit(50);
        assertTrue(created.get());
        assertEquals(150, proxy.getBalance());
    }

    @Test
    void virtualProxyCreatesSubjectOnlyOnce() {
        int[] callCount = {0};
        Supplier<BankAccount> supplier = () -> {
            callCount[0]++;
            return new RealBankAccount(0);
        };

        VirtualAccountProxy proxy = new VirtualAccountProxy(supplier);
        proxy.deposit(10);
        proxy.deposit(20);
        proxy.getBalance();

        assertEquals(1, callCount[0]);
    }
}
