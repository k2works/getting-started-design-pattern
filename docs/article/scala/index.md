# Scala 編 - デザインパターンからはじめるプログラミング入門

## 概要

型クラスと暗黙の引数（given/using）、enum による代数的データ型（ADT）、パターンマッチ、第一級関数を活かして、GoF の 13 デザインパターンを TDD（munit）で実装しながら学ぶ記事シリーズです。

**実装コード**: `apps/scala/design-pattern/`

---

## 目次

### 第 1 部: パターンとは何か

| 章 | タイトル |
|----|---------|
| 1 | [デザインパターンとパターン思考](01-introduction-to-patterns.md) |
| 2 | [パターンを支える基本原則](02-principles-and-patterns.md) |
| 3 | [開発環境と TDD 基盤](03-tdd-and-tooling.md) |

### 第 2 部: 振る舞いの取り扱い

| 章 | パターン | Scala の特徴 |
|----|---------|-------------|
| 4 | [Template Method](04-template-method.md) | trait のデフォルト実装 + 抽象メソッド |
| 5 | [Strategy](05-strategy.md) | 第一級関数 / 型エイリアス |
| 6 | [Observer](06-observer.md) | trait ミックスイン |
| 7 | [Composite](07-composite.md) | enum（ADT）+ 拡張メソッド |
| 8 | [Iterator](08-iterator.md) | Iterable trait / given Ordering |

### 第 3 部: 操作と関係の表現

| 章 | パターン | Scala の特徴 |
|----|---------|-------------|
| 9 | [Command](09-command.md) | trait + ケースクラス |
| 10 | [Adapter](10-adapter.md) | trait による適合 |
| 11 | [Proxy](11-proxy.md) | lazy val / アクセス制御 |
| 12 | [Decorator](12-decorator.md) | スタッカブル trait パターン |

### 第 4 部: オブジェクトの作成と解釈

| 章 | パターン | Scala の特徴 |
|----|---------|-------------|
| 13 | [Singleton](13-singleton.md) | object（ビルトインシングルトン） |
| 14 | [Factory](14-factory.md) | enum + companion object |
| 15 | [Builder](15-builder.md) | case class copy / フルーエント API |
| 16 | [Interpreter](16-interpreter.md) | enum ADT + パターンマッチ |
