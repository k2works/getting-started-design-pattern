# Rust で学ぶデザインパターン

## 所有権とトレイトによる安全なパターン実装

Rust はメモリ安全性を言語レベルで保証し、所有権（Ownership）・借用（Borrowing）・ライフタイム（Lifetime）という独自の概念により、ガベージコレクタなしで安全なプログラムを書くことができます。本シリーズでは、この Rust の強みを活かしてデザインパターンを実装し、「安全で高速なパターン実装」を学びます。

## 目次

### 第 1 部：基礎編

1. [パターン入門](01-introduction-to-patterns.md) — デザインパターンとは何か、なぜ Rust で学ぶのか
2. [Rust の基礎と cargo test](02-rust-basics-and-cargo-test.md) — Rust の基本文法とテスト駆動開発の始め方
3. [所有権・トレイト・列挙型](03-ownership-traits-enums.md) — Rust のパターン実装を支える 3 本柱

### 第 2 部：振る舞いに関するパターン

4. [Template Method](04-template-method.md) — トレイトのデフォルト実装でアルゴリズムの骨格を定義する
5. [Strategy](05-strategy.md) — クロージャでアルゴリズムを差し替え可能にする
6. [Observer](06-observer.md) — クロージャベースの通知メカニズム
7. [Command](07-command.md) — 操作をオブジェクト化し、実行と取り消しを可能にする
8. [Iterator](08-iterator.md) — Rust 標準の Iterator トレイトでコレクションを走査する

### 第 3 部：構造に関するパターン

9. [Composite](09-composite.md) — 列挙型で木構造を安全に表現する
10. [Adapter](10-adapter.md) — トレイトでインターフェースの不一致を解消する
11. [Proxy](11-proxy.md) — アクセス制御と遅延初期化をトレイトで実現する
12. [Decorator](12-decorator.md) — トレイトオブジェクトで動的に機能を追加する

### 第 4 部：生成に関するパターンと DSL

13. [Singleton](13-singleton.md) — OnceLock でスレッドセーフな唯一のインスタンスを提供する
14. [Factory](14-factory.md) — 列挙型とファクトリ関数でオブジェクト生成を抽象化する
15. [Builder](15-builder.md) — メソッドチェーンと Result で安全にオブジェクトを構築する
16. [Interpreter](16-interpreter.md) — 列挙型で AST を構築し、再帰的に評価する
