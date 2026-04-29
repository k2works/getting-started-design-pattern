# Haskell 編 - デザインパターンからはじめるプログラミング入門

## 概要

型クラスとモナドによる純粋関数型パターン -- 代数的データ型（ADT）、パターンマッチ、高階関数、関数合成を活かして、GoF の 13 デザインパターンを TDD（HUnit）で実装しながら学ぶ記事シリーズです。

**実装コード**: `apps/haskell/design-pattern/`

---

## 目次

### 第 1 部: パターンとは何か

| 章 | タイトル |
|----|---------|
| 1 | [デザインパターンとパターン思考](01-introduction-to-patterns.md) |
| 2 | [パターンを支える基本原則](02-principles-and-patterns.md) |
| 3 | [開発環境と TDD 基盤](03-tdd-and-tooling.md) |

### 第 2 部: 振る舞いの取り扱い

| 章 | パターン | Haskell の特徴 |
|----|---------|---------------|
| 4 | [Template Method](04-template-method.md) | 関数フィールドを持つレコード |
| 5 | [Strategy](05-strategy.md) | 高階関数 / 型エイリアス |
| 6 | [Observer](06-observer.md) | IORef + コールバック / 純粋版 |
| 7 | [Composite](07-composite.md) | 再帰的 ADT |
| 8 | [Iterator](08-iterator.md) | リスト関数 / fold / map / filter |
| 9 | [Command](09-command.md) | 関数ペア（実行 + 取り消し） |

### 第 3 部: 構造を巧みに使う

| 章 | パターン | Haskell の特徴 |
|----|---------|---------------|
| 10 | [Adapter](10-adapter.md) | 型クラスによるインターフェース統一 |
| 11 | [Proxy](11-proxy.md) | newtype ラッパー / 遅延評価 |
| 12 | [Decorator](12-decorator.md) | 関数合成 (.) |

### 第 4 部: オブジェクトの生成と言語処理

| 章 | パターン | Haskell の特徴 |
|----|---------|---------------|
| 13 | [Singleton](13-singleton.md) | モジュールレベル定義（CAF） |
| 14 | [Factory](14-factory.md) | ADT + スマートコンストラクタ |
| 15 | [Builder](15-builder.md) | レコード更新構文 / 関数チェーン |
| 16 | [Interpreter](16-interpreter.md) | ADT で AST + 再帰的評価 |

---

## 環境構築

```bash
# Nix 環境
nix-shell ops/nix/environments/haskell/shell.nix

# テスト実行
cd apps/haskell/design-pattern
cabal test
```

## 各パターンと Haskell イディオムの対応

| GoF パターン | Haskell イディオム |
|-------------|------------------|
| Template Method | 関数フィールドレコード |
| Strategy | 高階関数 |
| Observer | IORef / 純粋状態遷移 |
| Composite | 再帰的 ADT |
| Iterator | リスト + fold/map/filter |
| Command | 関数ペア |
| Adapter | 型クラス |
| Proxy | newtype / 遅延評価 |
| Decorator | 関数合成 |
| Singleton | モジュール（CAF） |
| Factory | ADT + スマートコンストラクタ |
| Builder | レコード更新構文 |
| Interpreter | ADT（AST）+ パターンマッチ |
