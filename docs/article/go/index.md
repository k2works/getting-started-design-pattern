# Go 編 - デザインパターンからはじめるプログラミング入門

## 概要

継承なし・インターフェースは暗黙的・関数は第一級という Go の特性を活かして、GoF の 13 デザインパターンを TDD（標準 testing パッケージ）で実装しながら学ぶ記事シリーズです。

**テーマ**: 「継承なしでパターンを実現する」

**実装コード**: `apps/go/design-pattern/`

---

## 目次

### 第 1 部: パターンとは何か

| 章 | タイトル |
|----|---------|
| 1 | [デザインパターンとパターン思考](01-introduction-to-patterns.md) |
| 2 | [パターンを支える基本原則](02-principles-and-patterns.md) |
| 3 | [開発環境と TDD 基盤](03-tdd-and-tooling.md) |

### 第 2 部: 振る舞いの取り扱い

| 章 | パターン | Go の特徴 |
|----|---------|----------|
| 4 | [Template Method](04-template-method.md) | 関数フィールドを持つ struct |
| 5 | [Strategy](05-strategy.md) | 関数型 / 第一級関数 |
| 6 | [Observer](06-observer.md) | コールバックスライス |
| 7 | [Composite](07-composite.md) | interface + struct |
| 8 | [Iterator](08-iterator.md) | range ベースの反復 |

### 第 3 部: 操作と関係の表現

| 章 | パターン | Go の特徴 |
|----|---------|----------|
| 9 | [Command](09-command.md) | interface + ファイル操作 |
| 10 | [Adapter](10-adapter.md) | 暗黙的インターフェース実装 |
| 11 | [Proxy](11-proxy.md) | interface ラッピング |
| 12 | [Decorator](12-decorator.md) | interface ラッピング + 合成 |

### 第 4 部: オブジェクトの作成と解釈

| 章 | パターン | Go の特徴 |
|----|---------|----------|
| 13 | [Singleton](13-singleton.md) | sync.Once |
| 14 | [Factory](14-factory.md) | ファクトリ関数 + interface |
| 15 | [Builder](15-builder.md) | メソッドチェーン + エラー返却 |
| 16 | [Interpreter](16-interpreter.md) | 再帰的 AST + interface |
