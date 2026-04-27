# TypeScript 編 - デザインパターンからはじめるプログラミング入門

## 概要

ジェネリクス、ユニオン型、型ガードを活用して、GoF の 13 デザインパターンを型安全に TDD（Jest + ts-jest）で実装しながら学ぶ記事シリーズです。

**実装コード**: `apps/typescript/design-pattern/`

---

## 目次

### 第 1 部: パターンとは何か

| 章 | タイトル |
|----|---------|
| 1 | [デザインパターンとパターン思考](01-introduction-to-patterns.md) |
| 2 | [パターンを支える基本原則](02-principles-and-patterns.md) |
| 3 | [開発環境と TDD 基盤](03-tdd-and-tooling.md) |

### 第 2 部: 振る舞いの取り扱い

| 章 | パターン | TypeScript の特徴 |
|----|---------|------------------|
| 4 | [Template Method](04-template-method.md) | abstract class + abstract method |
| 5 | [Strategy](05-strategy.md) | 型付き関数型 `(r: Report) => string` |
| 6 | [Observer](06-observer.md) | interface Observer + ジェネリクス |
| 7 | [Composite](07-composite.md) | abstract class + ジェネリクス |
| 8 | [Iterator](08-iterator.md) | Iterable / Iterator プロトコル |

### 第 3 部: 操作と関係の表現

| 章 | パターン | TypeScript の特徴 |
|----|---------|------------------|
| 9 | [Command](09-command.md) | interface Command |
| 10 | [Adapter](10-adapter.md) | interface による明示的契約 |
| 11 | [Proxy](11-proxy.md) | Proxy\<T\> + ProxyHandler\<T\> |
| 12 | [Decorator](12-decorator.md) | interface 委譲 |

### 第 4 部: オブジェクトの作成と解釈

| 章 | パターン | TypeScript の特徴 |
|----|---------|------------------|
| 13 | [Singleton](13-singleton.md) | private constructor |
| 14 | [Factory](14-factory.md) | ジェネリクス + new() 制約 |
| 15 | [Builder](15-builder.md) | Readonly\<T\> + メソッドチェーン |
| 16 | [Interpreter](16-interpreter.md) | 型安全な AST |
