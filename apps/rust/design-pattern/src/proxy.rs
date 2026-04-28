//! Proxy pattern
//!
//! Protection Proxy: restricts access based on owner identity.
//! Virtual Proxy: delays creation of the real object until first use.

pub trait BankAccount {
    fn deposit(&mut self, amount: i64);
    fn withdraw(&mut self, amount: i64) -> Result<(), String>;
    fn balance(&self) -> i64;
}

pub struct RealBankAccount {
    balance: i64,
}

impl RealBankAccount {
    pub fn new(initial_balance: i64) -> Self {
        Self {
            balance: initial_balance,
        }
    }
}

impl BankAccount for RealBankAccount {
    fn deposit(&mut self, amount: i64) {
        self.balance += amount;
    }

    fn withdraw(&mut self, amount: i64) -> Result<(), String> {
        if amount > self.balance {
            Err("Insufficient funds".to_string())
        } else {
            self.balance -= amount;
            Ok(())
        }
    }

    fn balance(&self) -> i64 {
        self.balance
    }
}

pub struct ProtectionProxy {
    account: RealBankAccount,
    owner: String,
}

impl ProtectionProxy {
    pub fn new(account: RealBankAccount, owner: &str) -> Self {
        Self {
            account,
            owner: owner.to_string(),
        }
    }

    fn check_access(&self, user: &str) -> Result<(), String> {
        if user == self.owner {
            Ok(())
        } else {
            Err(format!("Access denied for user: {}", user))
        }
    }

    pub fn deposit_as(&mut self, user: &str, amount: i64) -> Result<(), String> {
        self.check_access(user)?;
        self.account.deposit(amount);
        Ok(())
    }

    pub fn withdraw_as(&mut self, user: &str, amount: i64) -> Result<(), String> {
        self.check_access(user)?;
        self.account.withdraw(amount)
    }

    pub fn balance_as(&self, user: &str) -> Result<i64, String> {
        self.check_access(user)?;
        Ok(self.account.balance())
    }
}

pub struct VirtualProxy {
    initial_balance: i64,
    account: Option<RealBankAccount>,
}

impl VirtualProxy {
    pub fn new(initial_balance: i64) -> Self {
        Self {
            initial_balance,
            account: None,
        }
    }

    fn ensure_account(&mut self) -> &mut RealBankAccount {
        if self.account.is_none() {
            self.account = Some(RealBankAccount::new(self.initial_balance));
        }
        self.account.as_mut().unwrap()
    }

    pub fn is_initialized(&self) -> bool {
        self.account.is_some()
    }
}

impl BankAccount for VirtualProxy {
    fn deposit(&mut self, amount: i64) {
        self.ensure_account().deposit(amount);
    }

    fn withdraw(&mut self, amount: i64) -> Result<(), String> {
        self.ensure_account().withdraw(amount)
    }

    fn balance(&self) -> i64 {
        match &self.account {
            Some(acc) => acc.balance(),
            None => self.initial_balance,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn real_account_deposit_and_withdraw() {
        let mut acc = RealBankAccount::new(100);
        acc.deposit(50);
        assert_eq!(acc.balance(), 150);
        acc.withdraw(30).unwrap();
        assert_eq!(acc.balance(), 120);
    }

    #[test]
    fn real_account_rejects_overdraft() {
        let mut acc = RealBankAccount::new(100);
        let result = acc.withdraw(200);
        assert!(result.is_err());
    }

    #[test]
    fn protection_proxy_allows_owner() {
        let acc = RealBankAccount::new(100);
        let mut proxy = ProtectionProxy::new(acc, "alice");
        proxy.deposit_as("alice", 50).unwrap();
        assert_eq!(proxy.balance_as("alice").unwrap(), 150);
    }

    #[test]
    fn protection_proxy_denies_non_owner() {
        let acc = RealBankAccount::new(100);
        let mut proxy = ProtectionProxy::new(acc, "alice");
        assert!(proxy.deposit_as("bob", 50).is_err());
        assert!(proxy.balance_as("bob").is_err());
    }

    #[test]
    fn virtual_proxy_delays_initialization() {
        let proxy = VirtualProxy::new(100);
        assert!(!proxy.is_initialized());
        assert_eq!(proxy.balance(), 100);
    }

    #[test]
    fn virtual_proxy_initializes_on_deposit() {
        let mut proxy = VirtualProxy::new(100);
        proxy.deposit(50);
        assert!(proxy.is_initialized());
        assert_eq!(proxy.balance(), 150);
    }
}
