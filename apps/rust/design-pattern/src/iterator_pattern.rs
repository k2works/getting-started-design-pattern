/// Iterator pattern
///
/// Portfolio holds a collection of Accounts and exposes
/// iteration via Rust's standard IntoIterator / iter().

#[derive(Debug, Clone, PartialEq)]
pub struct Account {
    pub name: String,
    pub balance: i64,
}

impl Account {
    pub fn new(name: &str, balance: i64) -> Self {
        Self {
            name: name.to_string(),
            balance,
        }
    }
}

#[derive(Debug, Clone)]
pub struct Portfolio {
    accounts: Vec<Account>,
}

impl Portfolio {
    pub fn new() -> Self {
        Self {
            accounts: Vec::new(),
        }
    }

    pub fn add_account(&mut self, account: Account) {
        self.accounts.push(account);
    }

    pub fn len(&self) -> usize {
        self.accounts.len()
    }

    pub fn is_empty(&self) -> bool {
        self.accounts.is_empty()
    }

    pub fn iter(&self) -> std::slice::Iter<'_, Account> {
        self.accounts.iter()
    }

    pub fn total_balance(&self) -> i64 {
        self.iter().map(|a| a.balance).sum()
    }
}

impl Default for Portfolio {
    fn default() -> Self {
        Self::new()
    }
}

impl<'a> IntoIterator for &'a Portfolio {
    type Item = &'a Account;
    type IntoIter = std::slice::Iter<'a, Account>;

    fn into_iter(self) -> Self::IntoIter {
        self.accounts.iter()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn sample_portfolio() -> Portfolio {
        let mut p = Portfolio::new();
        p.add_account(Account::new("Savings", 1000));
        p.add_account(Account::new("Checking", 2000));
        p.add_account(Account::new("Investment", 5000));
        p
    }

    #[test]
    fn empty_portfolio() {
        let p = Portfolio::new();
        assert!(p.is_empty());
        assert_eq!(p.len(), 0);
    }

    #[test]
    fn add_accounts_increases_length() {
        let p = sample_portfolio();
        assert_eq!(p.len(), 3);
    }

    #[test]
    fn iterate_over_accounts() {
        let p = sample_portfolio();
        let names: Vec<&str> = p.iter().map(|a| a.name.as_str()).collect();
        assert_eq!(names, vec!["Savings", "Checking", "Investment"]);
    }

    #[test]
    fn total_balance_sums_all_accounts() {
        let p = sample_portfolio();
        assert_eq!(p.total_balance(), 8000);
    }

    #[test]
    fn for_loop_works_via_into_iterator() {
        let p = sample_portfolio();
        let mut count = 0;
        for _account in &p {
            count += 1;
        }
        assert_eq!(count, 3);
    }
}
