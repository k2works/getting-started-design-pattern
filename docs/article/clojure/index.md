# Clojure 編 - デザインパターンからはじめるプログラミング入門

## 概要

GoF の代表的な 13 デザインパターンを Clojure の TDD（clojure.test）で実装しながら学ぶ記事シリーズです。オブジェクト指向言語で生まれたパターンの多くは、関数型言語では言語機能そのものに吸収されます。Clojure のプロトコル、マルチメソッド、不変データ構造��高階関数、遅延シーケンスといった機能が、従来のパターンをどのように代替・簡素化するかを探ります。

**対象読者**: TDD の基本サイクル（Red-Green-Refactor）を習得済みの Clojure プログラマー

**実装コード**: `apps/clojure/design-pattern/`

---

## スタイルガイド

### 記事の構成

各パターン章（章 4-16）は以下の統一構成で記述します。

1. **はじめに** - パターンの動機と解決する問題
2. **パターンの構造** - クラス図（PlantUML）と登場人物の説明
3. **TDD で作る** - Red-Green-Refactor サイクルで段階的に実装
4. **他言語との比較** - 他の言語での実装方法との比較
5. **まとめ** - パターンの適用指針、使いどころと注意点

### コード規約

- テストファイル: `test/design_pattern/{pattern_name}_test.clj`
- 実装ファイル: `src/design_pattern/{pattern_name}.clj`
- テストフレームワーク: clojure.test
- コードスタイル: Clojure 標準（2 スペースインデント）

---

## 目次

### 第 1 部: パターンとは何か

| 章 | タイトル | 内容 |
|----|---------|------|
| 1 | [デザインパターンへの誘い](01-introduction-to-patterns.md) | GoF の歴史、パターンの Clojure 的解釈 |
| 2 | [パターンを支える基本原則](02-principles-and-patterns.md) | 不変性、データ指向、ホモイコニシティ、SOLID 原則 |
| 3 | [開発環境と TDD 基盤](03-tdd-and-tooling.md) | Leiningen + clojure.test + Eastwood のセットアップ |

### 第 2 部: 振る舞いの取り扱い

| 章 | パターン | 学びの中心 |
|----|---------|-----------|
| 4 | [Template Method](04-template-method.md) | 高階関数とマップでアルゴリズムの骨格を定義 |
| 5 | [Strategy](05-strategy.md) | 関数を引数として渡すことでアルゴリズムを差し替え |
| 6 | [Observer](06-observer.md) | atom + add-watch による出版/購読モデル |
| 7 | [Composite](07-composite.md) | 再帰データ構造とマルチメソッドで部分と全体を同一視 |
| 8 | [Iterator](08-iterator.md) | seq 抽象と遅延シーケンスによる内部/外部イテレータ |

### 第 3 部: 操作と関係の表現

| 章 | パターン | 学びの中心 |
|----|---------|-----------|
| 9 | [Command](09-command.md) | マップとクロージャで操作をオブジェクト化、Undo/Redo |
| 10 | [Adapter](10-adapter.md) | プロトコルと reify による型適合、データ変換 |
| 11 | [Proxy](11-proxy.md) | delay/force、Protection Proxy、Logging/Caching Proxy |
| 12 | [Decorator](12-decorator.md) | 高階関数のネストによる振る舞いの装飾 |

### 第 4 部: オブジェクトの作成と解釈

| 章 | パターン | 学びの中心 |
|----|---------|-----------|
| 13 | [Singleton](13-singleton.md) | def/defonce + atom による名前空間レベルの唯一性 |
| 14 | [Factory](14-factory.md) | マルチメソッドによる Factory Method と Abstract Factory |
| 15 | [Builder](15-builder.md) | -> マクロと assoc による段階的構築、Director パターン |
| 16 | [Interpreter](16-interpreter.md) | マップ AST + マルチメソッド評価、RPN パーサ�� |
