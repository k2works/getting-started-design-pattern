# Java 編 - デザインパターンからはじめるプログラミング入門

## 概要

GoF 『Design Patterns』 のメインターゲット言語である Java で、13 デザインパターンをインターフェースと抽象クラスを使って TDD（JUnit 5）で実装しながら学ぶ記事シリーズです。

**対象読者**: Java の基本文法を習得済みで、オブジェクト指向設計を深く理解したい開発者

**実装コード**: `apps/java/design-pattern/`

**Ruby 版との関係**: 各章に「Ruby との比較」セクションを設け、動的型付け vs 静的型付けでのパターン表現の違いを解説します。

---

## スタイルガイド

### 記事の構成

各パターン章（章 4-16）は以下の統一構成で記述します。

1. **はじめに** - パターンの動機と解決する問題
2. **パターンの構造** - クラス図（PlantUML）と登場人物の説明
3. **TDD で作る** - Red-Green-Refactor サイクルで段階的に実装
4. **Ruby との比較** - 動的型付け vs 静的型付けでの違い
5. **まとめ** - パターンの適用指針、使いどころと注意点

### コード規約

- パッケージ: `pattern.{パターン名}`（例: `pattern.templatemethod`）
- テストクラス: `{パターン名}Test.java`
- テストフレームワーク: JUnit 5
- Java バージョン: 17（LTS）

---

## 目次

### 第 1 部: パターンとは何か

| 章 | タイトル | 内容 |
|----|---------|------|
| 1 | [デザインパターンとパターン思考](01-introduction-to-patterns.md) | GoF の歴史、Java とパターンの関係 |
| 2 | [パターンを支える基本原則](02-principles-and-patterns.md) | SOLID 原則、インターフェース指向設計 |
| 3 | [開発環境と TDD 基盤](03-tdd-and-tooling.md) | JDK 17 + Gradle + JUnit 5 + JaCoCo |

### 第 2 部: 振る舞いの取り扱い

| 章 | パターン | 学びの中心 |
|----|---------|-----------|
| 4 | [Template Method](04-template-method.md) | 抽象クラスとフックメソッド |
| 5 | [Strategy](05-strategy.md) | インターフェース + ラムダ式（Java 8+） |
| 6 | [Observer](06-observer.md) | リスナーパターン、関数型インターフェース |
| 7 | [Composite](07-composite.md) | 再帰構造、ジェネリクス |
| 8 | [Iterator](08-iterator.md) | Iterable / Iterator、拡張 for 文 |

### 第 3 部: 操作と関係の表現

| 章 | パターン | 学びの中心 |
|----|---------|-----------|
| 9 | [Command](09-command.md) | 関数型インターフェース、Undo/Redo |
| 10 | [Adapter](10-adapter.md) | クラス Adapter vs オブジェクト Adapter |
| 11 | [Proxy](11-proxy.md) | 動的プロキシ（java.lang.reflect.Proxy） |
| 12 | [Decorator](12-decorator.md) | java.io の Decorator 構造 |

### 第 4 部: オブジェクトの作成と解釈

| 章 | パターン | 学びの中心 |
|----|---------|-----------|
| 13 | [Singleton](13-singleton.md) | enum Singleton（Effective Java 推奨） |
| 14 | [Factory](14-factory.md) | Factory Method と Abstract Factory |
| 15 | [Builder](15-builder.md) | 流暢なインターフェース（メソッドチェーン） |
| 16 | [Interpreter](16-interpreter.md) | AST 表現、Visitor との関係 |
