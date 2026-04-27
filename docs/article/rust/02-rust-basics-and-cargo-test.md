# 第 2 章：Rust の基礎と cargo test

## はじめに

Rust でデザインパターンを実装するために、まず基本的な文法と `cargo test` によるテスト駆動開発（TDD）の流れを理解します。

## プロジェクトのセットアップ

```bash
cargo new design-pattern --lib
cd design-pattern
cargo test
```

## 基本文法

### 変数と型

```rust
let x: i64 = 42;           // 不変束縛
let mut y: String = String::from("hello");  // 可変束縛
y.push_str(" world");
```

### 関数

```rust
fn add(a: i64, b: i64) -> i64 {
    a + b  // 最後の式が戻り値
}
```

### 構造体

```rust
struct Account {
    name: String,
    balance: i64,
}

impl Account {
    fn new(name: &str, balance: i64) -> Self {
        Self {
            name: name.to_string(),
            balance,
        }
    }

    fn deposit(&mut self, amount: i64) {
        self.balance += amount;
    }
}
```

## TDD で作る：最初のテスト

### Red: 失敗するテストを書く

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn new_account_has_correct_balance() {
        let account = Account::new("Savings", 1000);
        assert_eq!(account.balance, 1000);
    }

    #[test]
    fn deposit_increases_balance() {
        let mut account = Account::new("Savings", 1000);
        account.deposit(500);
        assert_eq!(account.balance, 1500);
    }
}
```

### Green: テストを通す

上記の `Account` 構造体と `impl` ブロックを実装します。

### Refactor: 改善する

テストが通った状態で、命名や構造を見直します。

## cargo test の便利な使い方

```bash
cargo test                          # 全テスト実行
cargo test template_method          # モジュール名でフィルタ
cargo test -- --show-output         # println! の出力を表示
cargo test -- --test-threads=1      # シングルスレッドで実行
```

## 他言語比較

| 機能 | Rust | Java | Python |
|------|------|------|--------|
| テスト配置 | 同一ファイル `#[cfg(test)]` | 別ファイル | 別ファイル |
| テスト実行 | `cargo test` | JUnit / Maven | pytest |
| アサーション | `assert_eq!`, `assert!` | `assertEquals` | `assert` |
| テスト発見 | `#[test]` 属性 | `@Test` アノテーション | `test_` プレフィックス |

## まとめ

Rust のテストは `#[cfg(test)]` モジュール内に `#[test]` 属性付きの関数として書きます。`cargo test` コマンドでコンパイルと実行が一度に行われ、TDD サイクル（Red-Green-Refactor）を素早く回せます。次章では Rust のパターン実装を支える所有権・トレイト・列挙型を学びます。
