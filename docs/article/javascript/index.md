# JavaScript 編 - デザインパターンからはじめるプログラミング入門

## 概要

プロトタイプベースのオブジェクト指向、関数（第一級オブジェクト）、ES6+ の Proxy API を活かして、GoF の 13 デザインパターンを TDD（Jest）で実装しながら学ぶ記事シリーズです。

**実装コード**: `apps/javascript/design-pattern/`

---

## 目次

### 第 1 部: パターンとは何か

| 章 | タイトル |
|----|---------|
| 1 | [デザインパターンとパターン思考](01-introduction-to-patterns.md) |
| 2 | [パターンを支える基本原則](02-principles-and-patterns.md) |
| 3 | [開発環境と TDD 基盤](03-tdd-and-tooling.md) |

### 第 2 部: 振る舞いの取り扱い

| 章 | パターン | JavaScript の特徴 |
|----|---------|------------------|
| 4 | [Template Method](04-template-method.md) | クラス継承 + メソッドオーバーライド |
| 5 | [Strategy](05-strategy.md) | アロー関数 / 関数オブジェクト |
| 6 | [Observer](06-observer.md) | EventEmitter パターン |
| 7 | [Composite](07-composite.md) | Duck Typing |
| 8 | [Iterator](08-iterator.md) | Symbol.iterator / ジェネレータ |

### 第 3 部: 操作と関係の表現

| 章 | パターン | JavaScript の特徴 |
|----|---------|------------------|
| 9 | [Command](09-command.md) | 関数オブジェクト / クロージャ |
| 10 | [Adapter](10-adapter.md) | オブジェクトラッパー |
| 11 | [Proxy](11-proxy.md) | ES6 Proxy API |
| 12 | [Decorator](12-decorator.md) | 高階関数 / 関数合成 |

### 第 4 部: オブジェクトの作成と解釈

| 章 | パターン | JavaScript の特徴 |
|----|---------|------------------|
| 13 | [Singleton](13-singleton.md) | モジュールスコープ / クロージャ |
| 14 | [Factory](14-factory.md) | ファクトリ関数 |
| 15 | [Builder](15-builder.md) | メソッドチェーン |
| 16 | [Interpreter](16-interpreter.md) | 再帰的 AST |
