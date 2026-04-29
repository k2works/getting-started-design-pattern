# PHP 編 - デザインパターンからはじめるプログラミング入門

## 概要

Russ Olsen 『Design Patterns in Ruby』 を一次資料に、GoF の代表的な 13 デザインパターンを PHP の TDD（PHPUnit）で実装しながら学ぶ記事シリーズです。

**対象読者**: TDD の基本サイクル（Red-Green-Refactor）を習得済みの PHP プログラマー

**前提**: [テスト駆動開発から始めるプログラミング入門](../../getting-start-tdd/index.md) の PHP 編を完了していること（推奨）

**実装コード**: `apps/php/design-pattern/`

---

## スタイルガイド

### 記事の構成

各パターン章（章 4-16）は以下の統一構成で記述します。

1. **はじめに** - パターンの動機と解決する問題
2. **パターンの構造** - クラス図（PlantUML）と登場人物の説明
3. **TDD で作る** - Red-Green-Refactor サイクルで段階的に実装
4. **PHP らしい実装** - 型宣言、Trait、SplObjectStorage 等の PHP 固有表現
5. **まとめ** - パターンの適用指針、使いどころと注意点

### コード規約

- ソースファイル: `src/{PatternName}/*.php`
- テストファイル: `tests/{PatternName}Test.php`
- テストフレームワーク: PHPUnit 11
- コードスタイル: PSR-12 準拠
- PHP バージョン: 8.x（型宣言、named arguments、match 式を活用）

---

## 目次

### 第 1 部: パターンとは何か

| 章 | タイトル | 内容 |
|----|---------|------|
| 1 | [デザインパターンとパターン思考](01-introduction-to-patterns.md) | GoF の歴史、パターンが解く「変更コスト」の問題 |
| 2 | [パターンを支える基本原則](02-principles-and-patterns.md) | SOLID 原則、変化するものを分離する、継承より委譲 |
| 3 | [開発環境と TDD 基盤](03-tdd-and-tooling.md) | PHP 8.x + PHPUnit 11 + Composer のセットアップ |

### 第 2 部: 振る舞いの取り扱い

| 章 | パターン | 学びの中心 |
|----|---------|-----------|
| 4 | [Template Method](04-template-method.md) | abstract クラスでフックメソッドを定義し、具象クラスで差分を埋める |
| 5 | [Strategy](05-strategy.md) | callable と __invoke() で戦略を差し替え可能にする |
| 6 | [Observer](06-observer.md) | SplObjectStorage でイベント駆動の通知を実装する |

### 第 3 部: 構造の取り扱い

| 章 | パターン | 学びの中心 |
|----|---------|-----------|
| 7 | [Composite](07-composite.md) | 再帰的なツリー構造で部分と全体を統一的に扱う |
| 8 | [Iterator](08-iterator.md) | IteratorAggregate と Countable で PHP の foreach を活かす |
| 9 | [Command](09-command.md) | 操作をオブジェクト化し、実行と取り消しを分離する |
| 10 | [Adapter](10-adapter.md) | インターフェース変換で既存コードを再利用する |
| 11 | [Proxy](11-proxy.md) | Protection Proxy と Virtual Proxy でアクセスを制御する |
| 12 | [Decorator](12-decorator.md) | WriterDecorator でラッピングによる機能追加を行う |

### 第 4 部: オブジェクトの生成

| 章 | パターン | 学びの中心 |
|----|---------|-----------|
| 13 | [Singleton](13-singleton.md) | private コンストラクタと getInstance() で唯一性を保証する |
| 14 | [Factory](14-factory.md) | Factory Method と Abstract Factory で生成を分離する |
| 15 | [Builder](15-builder.md) | 流暢なインターフェースとバリデーションで複雑なオブジェクトを構築する |
| 16 | [Interpreter](16-interpreter.md) | 式オブジェクトの再帰的構成で DSL を実装する |
