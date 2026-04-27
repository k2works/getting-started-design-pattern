# デザインパターンからはじめるプログラミング入門

本記事シリーズは、GoF（Gang of Four）の代表的な 13 のデザインパターンを題材に、よいソフトウェア（変更を楽に安全にできて役に立つソフトウェア）を作るための設計の規律を、複数のプログラミング言語で実践的に学ぶためのガイドです。

Russ Olsen 『Design Patterns in Ruby』 を源流に、Ruby の実装を出発点として 14 言語で同じパターンを実装し、各言語の設計思想とパターンが解こうとする本質的な問題を探求します。

## 前提

本シリーズは [テスト駆動開発から始めるプログラミング入門](../article/getting-start-tdd/index.md) の続編として位置づけられます。TDD の Red-Green-Refactor サイクルに慣れていることを前提に、第 3 部「オブジェクト指向設計」をさらに深掘りします。

## 言語別解説

| 言語 | 環境 | 特徴 |
|------|------|------|
| [Ruby](ruby/index.md) | CRuby | 源流。動的型付け、すべてがオブジェクト、DSL 親和性 |
| [Java](java/index.md) | JVM | 静的型付け、OOP の正統。GoF 本のメインターゲット言語 |
| [JavaScript](javascript/index.md) | Node.js | 動的型付け、プロトタイプベース、関数オブジェクト |
| [TypeScript](typescript/index.md) | Node.js | JavaScript + 静的型付け、ジェネリクス |
| [Python](python/index.md) | CPython | 動的型付け、ダックタイピング、デコレータ言語機能 |
| [PHP](php/index.md) | PHP | 動的型付け、漸進的型付け、Web 特化 |
| [Go](go/index.md) | Go | 静的型付け、構造的型、継承なし |
| [Rust](rust/index.md) | Rust | 所有権、トレイト、ゼロコスト抽象化 |
| [C#](csharp/index.md) | .NET | LINQ、デリゲート、拡張メソッド |
| [F#](fsharp/index.md) | .NET | 関数型ファースト、判別共用体 |
| [Clojure](clojure/index.md) | JVM | LISP、不変データ、プロトコル / マルチメソッド |
| [Scala](scala/index.md) | JVM | OOP と FP の融合、暗黙の引数、型クラス |
| [Elixir](elixir/index.md) | Erlang VM | プロセスとパターンマッチング、Behaviour |
| [Haskell](haskell/index.md) | GHC | 純粋関数型、型クラス、モナド |

## 多言語統合解説

[多言語統合解説](all/index.md) では、14 言語の実装を横断的に比較し、デザインパターンの本質と各言語固有の表現を統合的に解説します。関数型言語ではパターンが「不要になる / 言語機能で置き換わる」ケースも多く、その差分こそが学びの中心になります。

## 章構成

本シリーズは 16 章を 4 部に分けて構成します。Russ Olsen 本の章順を踏襲し、振る舞い系のシンプルなパターン（Template Method、Strategy）から学習を始めることで、難易度の段階的な引き上げを行います。

### 第 1 部: パターンとは何か

| 章 | テーマ | 内容 |
|----|--------|------|
| 1 | [デザインパターンとパターン思考](01-introduction-to-patterns.md) | パターンの起源、GoF と Russ Olsen、なぜ今学ぶのか |
| 2 | [パターンを支える基本原則](02-principles-and-patterns.md) | SOLID 原則、GoF が掲げる 4 つの設計指針 |
| 3 | [開発環境と TDD 基盤](03-tdd-and-tooling.md) | 14 言語の Nix 環境、テスティングフレームワーク、リファクタリングの作法 |

### 第 2 部: 振る舞いの取り扱い

| 章 | パターン | 解く問題 |
|----|----------|----------|
| 4 | [Template Method](04-template-method.md) | アルゴリズムの骨組みを共有し、可変部分だけを差し替える |
| 5 | [Strategy](05-strategy.md) | アルゴリズム自体を実行時に切り替える |
| 6 | [Observer](06-observer.md) | 状態変化を関心のあるオブジェクト群に通知する |
| 7 | [Composite](07-composite.md) | 部分と全体を同じインターフェースで扱う |
| 8 | [Iterator](08-iterator.md) | コレクションの内部構造を隠して順次走査する |

### 第 3 部: 操作と関係の表現

| 章 | パターン | 解く問題 |
|----|----------|----------|
| 9 | [Command](09-command.md) | 操作をオブジェクトとして扱い、取り消し・キュー化・記録を可能にする |
| 10 | [Adapter](10-adapter.md) | 互換性のないインターフェースを橋渡しする |
| 11 | [Proxy](11-proxy.md) | 実オブジェクトの前面に立ち、アクセス制御・遅延生成・遠隔呼び出しを行う |
| 12 | [Decorator](12-decorator.md) | 既存オブジェクトに段階的に責務を追加する |

### 第 4 部: オブジェクトの作成と解釈

| 章 | パターン | 解く問題 |
|----|----------|----------|
| 13 | [Singleton](13-singleton.md) | 唯一のインスタンスを保証する |
| 14 | [Factory](14-factory.md) | Factory Method / Abstract Factory で「どのクラスを生成するか」を分離する |
| 15 | [Builder](15-builder.md) | 複雑なオブジェクトを段階的・宣言的に組み立てる |
| 16 | [Interpreter](16-interpreter.md) | 文法を AST として表現し、評価する |

## 対象読者

- TDD の基本サイクルを習得済みのプログラマー
- オブジェクト指向設計をより深く理解したい方
- 言語ごとの設計思想の違いに興味がある方
- レガシーコードのリファクタリング指針を探している方
- 関数型言語で「パターンが不要になる理由」を知りたい方

## 共通のテーマ

- Russ Olsen 『Design Patterns in Ruby』 の Ruby 実装を出発点とする
- 各章で「問題の発見 → 素朴な実装 → パターンによる改善」という TDD リファクタリングの流れを踏む
- 言語ごとのイディオムと、パターンが「言語機能で代替される」ケースを比較する
- すべての実装は `apps/{言語}/` 配下に配置し、テストで動作を保証する

## 参照

- 『Design Patterns in Ruby』 - Russ Olsen
- 『Design Patterns: Elements of Reusable Object-Oriented Software』 - GoF（Gamma, Helm, Johnson, Vlissides）
- 『リファクタリング 第 2 版』 - Martin Fowler
- 『テスト駆動開発』 - Kent Beck
- 『Clean Architecture』 - Robert C. Martin
- 『エクストリームプログラミング』 - Kent Beck
- [テスト駆動開発から始めるプログラミング入門（前編）](../article/getting-start-tdd/index.md)
