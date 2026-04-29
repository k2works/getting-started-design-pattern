# Ruby 編 - デザインパターンからはじめるプログラミング入門

## 概要

Russ Olsen 『Design Patterns in Ruby』 を一次資料に、GoF の代表的な 13 デザインパターンを Ruby の TDD（minitest）で実装しながら学ぶ記事シリーズです。

**対象読者**: TDD の基本サイクル（Red-Green-Refactor）を習得済みの Ruby プログラマー

**前提**: [テスト駆動開発から始めるプログラミング入門](../../getting-start-tdd/index.md) の Ruby 編を完了していること（推奨）

**実装コード**: `apps/ruby/design-pattern/`

---

## スタイルガイド

### 記事の構成

各パターン章（章 4-16）は以下の統一構成で記述します。

1. **はじめに** - パターンの動機と解決する問題
2. **パターンの構造** - クラス図（PlantUML）と登場人物の説明
3. **TDD で作る** - Red-Green-Refactor サイクルで段階的に実装
4. **Ruby らしい実装** - ブロック、Module、メタプログラミング等の Ruby 固有表現
5. **まとめ** - パターンの適用指針、使いどころと注意点

### コード規約

- テストファイル: `test/{pattern_name}_test.rb`
- 実装ファイル: `lib/{pattern_name}.rb`
- テストフレームワーク: minitest
- コードスタイル: Ruby 標準（2 スペースインデント）

---

## 目次

### 第 1 部: パターンとは何か

| 章 | タイトル | 内容 |
|----|---------|------|
| 1 | [デザインパターンとパターン思考](01-introduction-to-patterns.md) | GoF の歴史、パターンが解く「変更コスト」の問題 |
| 2 | [パターンを支える基本原則](02-principles-and-patterns.md) | SOLID 原則、変化するものを分離する、継承より委譲 |
| 3 | [開発環境と TDD 基盤](03-tdd-and-tooling.md) | Ruby 3.3 + minitest + simplecov のセットアップ |

### 第 2 部: 振る舞いの取り扱い

| 章 | パターン | 学びの中心 |
|----|---------|-----------|
| 4 | [Template Method](04-template-method.md) | 抽象基底クラスでフックメソッドを定義し、具象クラスで差分を埋める |
| 5 | [Strategy](05-strategy.md) | 委譲によるアルゴリズム差し替え、Ruby の Proc / ブロック |
| 6 | [Observer](06-observer.md) | 出版/購読モデル、Ruby 標準 Observable モジュール |
| 7 | [Composite](07-composite.md) | 部分と全体の同一視、再帰構造 |
| 8 | [Iterator](08-iterator.md) | 内部 vs 外部イテレータ、Enumerable |

### 第 3 部: 操作と関係の表現

| 章 | パターン | 学びの中心 |
|----|---------|-----------|
| 9 | [Command](09-command.md) | 操作のオブジェクト化、Undo/Redo |
| 10 | [Adapter](10-adapter.md) | クラスベース Adapter、特異メソッドによる軽量 Adapter |
| 11 | [Proxy](11-proxy.md) | 保護 Proxy、仮想 Proxy、method_missing |
| 12 | [Decorator](12-decorator.md) | クラスベース Decorator、Module Mixin Decorator |

### 第 4 部: オブジェクトの作成と解釈

| 章 | パターン | 学びの中心 |
|----|---------|-----------|
| 13 | [Singleton](13-singleton.md) | Singleton モジュール、クラスベース、モジュールベース |
| 14 | [Factory](14-factory.md) | Factory Method と Abstract Factory |
| 15 | [Builder](15-builder.md) | 段階的構築、method_missing DSL ビルダー |
| 16 | [Interpreter](16-interpreter.md) | AST 表現、Composite との関係、内部 DSL |
