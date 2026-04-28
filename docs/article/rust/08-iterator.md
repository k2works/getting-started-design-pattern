# 第 8 章：Iterator

## はじめに

Iterator パターンは、コレクションの内部構造を公開せずに要素を順番に走査するパターンです。Rust では標準ライブラリの `Iterator` トレイトと `IntoIterator` トレイトが言語に深く統合されています。

## パターンの構造

```plantuml
@startuml
class Account {
  +name: String
  +balance: i64
}

class Portfolio {
  -accounts: Vec<Account>
  +add_account(account)
  +len(): usize
  +iter(): Iter<Account>
  +total_balance(): i64
}

interface IntoIterator {
  +into_iter(): Iterator
}

Portfolio ..|> IntoIterator
Portfolio "1" o--> "*" Account
@enduml
```

## TDD で作る

### Red

```rust
#[test]
fn for_loop_works_via_into_iterator() {
    let p = sample_portfolio();
    let mut count = 0;
    for _account in &p {
        count += 1;
    }
    assert_eq!(count, 3);
}
```

### Green

```rust
#[derive(Debug, Clone)]
pub struct Account {
    pub name: String,
    pub balance: i64,
}

pub struct Portfolio {
    accounts: Vec<Account>,
}

impl Portfolio {
    pub fn new(accounts: Vec<Account>) -> Self {
        Self { accounts }
    }

    pub fn add_account(&mut self, account: Account) {
        self.accounts.push(account);
    }

    pub fn iter(&self) -> std::slice::Iter<'_, Account> {
        self.accounts.iter()
    }

    pub fn total_balance(&self) -> i64 {
        self.accounts.iter().map(|a| a.balance).sum()
    }
}

impl<'a> IntoIterator for &'a Portfolio {
    type Item = &'a Account;
    type IntoIter = std::slice::Iter<'a, Account>;

    fn into_iter(self) -> Self::IntoIter {
        self.accounts.iter()
    }
}
```

`&Portfolio` に `IntoIterator` を実装しておくと、所有権を消費せずに `for account in &portfolio` と書けます。

### Refactor

`iter()` メソッドを公開し、`map`, `filter`, `sum` などのイテレータアダプタを活用できるようにします。

## 他言語比較

| 言語 | Iterator の実現方法 |
|------|-------------------|
| Java | `Iterable<T>` + `Iterator<T>` |
| Python | `__iter__` + `__next__` |
| Ruby | `Enumerable` + `each` |
| **Rust** | **`IntoIterator` + `Iterator` トレイト** |

Rust の Iterator は遅延評価（lazy）であり、`collect()` するまで実際の計算は行われません。

## まとめ

Rust の Iterator パターンは言語に組み込まれており、`IntoIterator` を実装するだけで `for` ループやイテレータアダプタ（`map`, `filter`, `fold` 等）がすべて使えるようになります。カスタムコレクションでも Rust の慣用的な方法で走査を提供できます。
