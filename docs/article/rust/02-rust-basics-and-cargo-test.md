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

```rust
#[derive(Debug, PartialEq, Eq)]
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

    fn withdraw(&mut self, amount: i64) -> bool {
        if self.balance < amount {
            return false;
        }
        self.balance -= amount;
        true
    }
}
```

最初の `Green` でも、後続の例で再利用しやすいように `new` と `deposit` だけでなく `withdraw` までそろえておくと流れが安定します。

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

## 静的コード解析: clippy

Rust には `clippy` という強力な lint ツールが標準で付属しています。`rustup` でインストールした Rust ツールチェーンにはデフォルトで含まれます。

### clippy とは

`clippy` はコンパイラでは検出しない、より高レベルなコード品質の問題を検出します。

```bash
# lint 実行（warnings を表示）
cargo clippy

# warnings をエラーとして扱う（CI 向け）
cargo clippy -- -D warnings

# 自動修正
cargo clippy --fix --allow-dirty
```

### 検出できる問題の例

| カテゴリ | 説明 | 例 |
|---------|------|----|
| `style` | 慣用的でないコード | `if x == true` → `if x` |
| `complexity` | 不必要に複雑なコード | ネストした `if` の折りたたみ |
| `correctness` | バグの可能性 | 到達不可能なコード |
| `perf` | パフォーマンス改善 | 不要なクローン |
| `pedantic` | より厳密なチェック | doc comment の書式 |

### 意図的な許可

パターン実装の教材では、意図的に clippy のルールを許可する場合があります。

```rust
#[allow(clippy::should_implement_trait)]
pub fn not(self) -> Expression {
    // Interpreter パターンの DSL API として `not` メソッド名を使用
    Expression::Not(Box::new(self))
}
```

---

## コード複雑度のチェック

Rust のコンパイラと clippy は、以下の点でコードの複雑度を間接的にチェックします:

- **型の複雑度** (`type_complexity`): 複雑な型は `type` エイリアスで整理する
- **折りたたみ可能な `if`** (`collapsible_if`): ネストを減らす
- **認知的複雑度** (`cognitive_complexity`): `#[warn(clippy::cognitive_complexity)]` で有効化可能

```rust
// clippy が type_complexity を指摘する例 → type alias で解決
pub type Formatter = Box<dyn Fn(&str, &[String]) -> String>;

pub struct Report {
    pub formatter: Formatter,  // Box<dyn Fn(...)> を直接書かない
}
```

---

## 品質チェックの一括実行

Rust では `cargo` コマンドを組み合わせて品質チェックを実行します。

```bash
# lint + テスト を順番に実行
cargo clippy -- -D warnings && cargo test
```

Makefile を使う場合:

```makefile
.PHONY: clippy test check

clippy:
	cargo clippy -- -D warnings

test:
	cargo test

check: clippy test
```

---

## 各言語の品質ツール比較

| 用途 | Rust | Ruby | Java | TypeScript | Python |
|------|------|------|------|-----------|--------|
| 静的解析 | clippy | RuboCop | Checkstyle + PMD | ESLint | Ruff |
| フォーマッター | rustfmt | RuboCop | Checkstyle | Prettier | Ruff |
| カバレッジ | cargo-tarpaulin | SimpleCov | JaCoCo | @vitest/coverage-v8 | pytest-cov |
| 複雑度チェック | clippy cognitive_complexity | RuboCop Metrics | PMD | ESLint complexity | Ruff McCabe |
| 一括実行 | `cargo clippy && cargo test` | `rake check` | `./gradlew check` | `npm run lint && npm test` | `ruff check && pytest` |

**Rust の特徴**: `clippy` と `rustfmt` がツールチェーンに含まれており、外部依存なしで品質チェックを実行できます。コンパイラ自体が強力な型チェックを行うため、他言語より多くのバグがコンパイル時に検出されます。

---

## まとめ

Rust のテストは `#[cfg(test)]` モジュール内に `#[test]` 属性付きの関数として書きます。`cargo test` コマンドでコンパイルと実行が一度に行われ、TDD サイクル（Red-Green-Refactor）を素早く回せます。`cargo clippy` による静的解析で、コンパイラでは検出できないコード品質の問題も早期に発見できます。次章では Rust のパターン実装を支える所有権・トレイト・列挙型を学びます。
