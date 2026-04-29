# 執筆計画アウトライン

## 概要

「デザインパターンからはじめるプログラミング入門」シリーズの執筆計画です。`docs/reference/ruby-design-pattern/` の Ruby 実装（Russ Olsen 『Design Patterns in Ruby』に基づく 13 パターン）を一次資料として、14 言語で統一的な章構成の記事として再構成します。

前作「テスト駆動開発から始めるプログラミング入門」の続編として位置づけ、TDD 第 3 部（オブジェクト指向設計）で扱った Strategy / Template Method などのリファクタリングを起点に、GoF の代表パターン全体へ拡張します。

## 一次資料

| 資料 | パス | 内容 |
|------|------|------|
| Ruby 実装 | `docs/reference/ruby-design-pattern/` | 13 パターンの Ruby + minitest 実装 |
| 出典書籍 | Russ Olsen 『Design Patterns in Ruby』 | Ruby 視点での GoF パターン解説 |
| 補完書籍 | GoF 『Design Patterns』 | パターンの原典 |
| 連携 | [前作 TDD 入門](getting-start-tdd/index.md)（IT8 まで完了） | 14 言語の Nix 環境とテスティング基盤を再利用 |

## 対象パターン

`docs/reference/ruby-design-pattern/` に含まれる 13 パターンを全て扱います。

| カテゴリ | パターン | Ruby 素材ディレクトリ |
|----------|----------|----------------------|
| 振る舞い | Template Method | `template_method/` |
| 振る舞い | Strategy | `strategy/` |
| 振る舞い | Observer | `observer/` |
| 構造 | Composite | `composite/` |
| 振る舞い | Iterator | `Iterator/` |
| 振る舞い | Command | `command/` |
| 構造 | Adapter | `adapter/` |
| 構造 | Proxy | `proxy/` |
| 構造 | Decorator | `decorator/` |
| 生成 | Singleton | `singleton/` |
| 生成 | Factory（Method / Abstract） | `factory/` |
| 生成 | Builder | `builder/` |
| 振る舞い | Interpreter | `interpreter/` |

## 対象言語

前作 TDD 入門と同じ 14 言語（`ops/nix/environments/` で管理）。

| 環境名 | 言語 | パターン理解の重点 |
|--------|------|------------------|
| ruby | Ruby | 源流。ブロック、Module、メタプログラミング |
| java | Java | GoF 本のメインターゲット。インターフェースと継承 |
| javascript | JavaScript | プロトタイプ、関数オブジェクト、動的ディスパッチ |
| typescript | TypeScript | 静的型付け、ジェネリクス、ユニオン型 |
| python | Python | ダックタイピング、デコレータ言語機能 |
| php | PHP | 漸進的型付け、トレイト |
| go | Go | 構造的型、継承なしでの委譲・組み込み |
| rust | Rust | トレイト、所有権、列挙型による多態 |
| csharp | C# | LINQ、デリゲート、拡張メソッド |
| fsharp | F# | 関数型ファースト、判別共用体、Computation Expression |
| clojure | Clojure | プロトコル、マルチメソッド、不変データ |
| scala | Scala | 型クラス、暗黙、パターンマッチ |
| elixir | Elixir | プロセス、Behaviour、関数のパイプライン |
| haskell | Haskell | 型クラス、モナド、純粋関数 |

## 章構成

全 16 章を 4 部に分けます。Russ Olsen 本の章順を踏襲し、難易度の低い振る舞いパターン（Template Method、Strategy）から始めて、構造、生成、解釈の順に進みます。

### 第 1 部: パターンとは何か

`docs/reference/ruby-design-pattern/` 全体の前提を整理する導入部。Russ Olsen 本の Part I 相当。

| 章 | テーマ | 内容 |
|----|--------|------|
| 1 | デザインパターンとパターン思考 | GoF の歴史、Olsen 本のアプローチ、パターンが解く「変更コスト」の問題、本シリーズの読み方 |
| 2 | パターンを支える基本原則 | SOLID 原則、「変化するものを分離する」「インターフェースを軸に設計する」「継承より委譲を選ぶ」「あなたが必要なものだけ書く」 |
| 3 | 開発環境と TDD 基盤 | 前作 TDD 入門の第 2 部「開発環境と自動化」の構成（バージョン管理、パッケージ管理 / 静的解析、タスクランナー / CI/CD）を踏襲し、本シリーズ用に簡約・再構成 |

#### 第 3 章の構成について

第 3 章「開発環境と TDD 基盤」は、前作 [テスト駆動開発から始めるプログラミング入門](getting-start-tdd/index.md) の **第 2 部「開発環境と自動化」（第 4 〜 6 章）** の構成を出発点とします。

参照: `tmp/getting-started-tdd/docs/article/outline.md` の第 2 部。

| 元章（TDD 入門 第 2 部） | 本シリーズ第 3 章での対応セクション | 内容 |
|--------------------------|-----------------------------------|------|
| 第 4 章 バージョン管理と Conventional Commits | 3.1 バージョン管理と Conventional Commits | Git フロー、Conventional Commits ルール、コミット規律 |
| 第 5 章 パッケージ管理と静的解析 | 3.2 パッケージ管理と静的解析 | 各言語のパッケージマネージャ、リンター、フォーマッター、カバレッジ |
| 第 6 章 タスクランナーと CI/CD | 3.3 タスクランナーと CI/CD | タスクランナー、自動化、CI/CD パイプライン構築 |

本シリーズではすでに前作で構築した 14 言語の Nix 環境とテスティング基盤を再利用するため、各セクションは「前作の差分・補足」を中心に簡潔にまとめます。前作を未読の読者に対しては、該当章へのリンクを冒頭に掲示します。

### 第 2 部: 振る舞いの取り扱い

`docs/reference/ruby-design-pattern/` の中でも最も基本的な振る舞い系パターン群。Russ Olsen 本の Part II 前半相当。

| 章 | パターン | Ruby 素材 | 主要ファイル | 学びの中心 |
|----|----------|-----------|--------------|-----------|
| 4 | Template Method | `template_method/` | `report.rb` / `html_report.rb` / `plaine_text_report.rb` | 抽象基底クラスでフックメソッドを定義し、具象クラスで差分を埋める |
| 5 | Strategy | `strategy/` | `report.rb` + ブロックによる formatter | 委譲によるアルゴリズム差し替え、Ruby の Proc / ブロックの活用 |
| 6 | Observer | `observer/` | `employee.rb` / `payroll.rb` / `tax_man.rb` | 出版/購読モデル、Ruby 標準 `Observable` モジュール |
| 7 | Composite | `composite/` | `task.rb` / `composite_task.rb` / `make_cake_task.rb` | 部分と全体の同一視、再帰構造、ケーキ作りタスクツリー |
| 8 | Iterator | `Iterator/` | `array_iterator.rb` / `account.rb` / `portfolio.rb` | 内部イテレータ vs 外部イテレータ、Enumerable の取り込み |

### 第 3 部: 操作と関係の表現

操作のオブジェクト化と、オブジェクト同士をつなぐ構造系パターン。Russ Olsen 本の Part II 中盤相当。

| 章 | パターン | Ruby 素材 | 主要ファイル | 学びの中心 |
|----|----------|-----------|--------------|-----------|
| 9 | Command | `command/` | `command.rb` / `create_file.rb` / `delete_file.rb` / `composite_command.rb` | 操作のオブジェクト化、Undo/Redo、コマンドの合成 |
| 10 | Adapter | `adapter/` | `british_text_object.rb` / `british_text_object_adapter.rb` / `string_io_adapter.rb` | クラスベース Adapter、特異メソッドによる軽量 Adapter |
| 11 | Proxy | `proxy/` | `bank_account.rb` / `account_protection_proxy.rb` / `virtual_account_proxy.rb` | 保護 Proxy、仮想 Proxy、`method_missing` による透過的委譲 |
| 12 | Decorator | `decorator/` | `simple_writer.rb` / `numbering_writer.rb` / `time_stamping_writer.rb` / `numbering_writer_module.rb` | クラスベース Decorator、Module による Mixin Decorator |

### 第 4 部: オブジェクトの作成と解釈

生成系パターンと、文法を解釈する Interpreter。Russ Olsen 本の Part II 後半相当。

| 章 | パターン | Ruby 素材 | 主要ファイル | 学びの中心 |
|----|----------|-----------|--------------|-----------|
| 13 | Singleton | `singleton/` | `simple_logger.rb` / `singleton_logger.rb` / `class_based_logger.rb` / `module_based_logger.rb` | Ruby の `Singleton` モジュール、クラスベース、モジュールベースの 3 つの実装比較 |
| 14 | Factory | `factory/` | `pond.rb` / `duck_pond.rb` / `frog_pond.rb` / `organism_factory.rb` / `habitat.rb` | Factory Method（テンプレートメソッドの応用）と Abstract Factory（生態系の組み合わせ）の段階的進化 |
| 15 | Builder | `builder/` | `computer.rb` / `computer_builder.rb` / `desktop_builder.rb` / `laptop_builder.rb` | 段階的構築、ビルダー側のバリデーション、`method_missing` による DSL ビルダー |
| 16 | Interpreter | `interpreter/` | `expression.rb` / `all.rb` / `bigger.rb` / `and.rb` / `or.rb` / `not.rb` / `parser.rb` | 文法の AST 表現、Composite との関係、内部 DSL への発展 |

## 言語ごとのバリエーション方針

すべての言語で全 16 章を執筆しますが、言語特性により扱い方を変えます。

### 動的型付け OOP 言語（Ruby / JavaScript / Python / PHP）

Russ Olsen 本のアプローチをほぼそのまま適用できます。ダックタイピング、ブロック / クロージャ、メタプログラミング、`method_missing` 系の動的委譲を活用した「軽量な」パターン実装を中心に解説します。

### 静的型付け OOP 言語（Java / TypeScript / C#）

GoF 本に近い古典的な実装が自然です。インターフェース、抽象クラス、ジェネリクスの活用、また C# の場合はデリゲート / 拡張メソッド / LINQ による現代的な簡略化を併記します。

### システム言語（Go / Rust）

継承がない言語でのパターン表現に焦点を当てます。

| パターン | Go | Rust |
|----------|-----|------|
| Template Method | 構造体の埋め込み + フック関数 | トレイトのデフォルト実装 |
| Strategy | 関数値・インターフェース | クロージャ・dyn Trait |
| Iterator | for-range + チャネル | `Iterator` トレイト |
| Decorator | 構造体の組み込み | `impl Trait` の合成 |

### 関数型言語（F# / Clojure / Scala / Elixir / Haskell）

「パターンが不要 / 言語機能で代替される」ことを率直に示し、対応する関数型イディオムを提示します。

| GoF パターン | 関数型での代替 |
|--------------|---------------|
| Strategy | 高階関数（関数を引数で渡す） |
| Template Method | 高階関数 + 部分適用 |
| Observer | リアクティブストリーム / Pub-Sub プロセス（Elixir） |
| Iterator | 遅延シーケンス / Stream / リスト内包 |
| Command | 関数のデータ化、`Cmd` データ型 |
| Singleton | モジュール / トップレベル束縛 |
| Decorator | 関数合成 |
| Visitor | 代数的データ型 + パターンマッチ |
| Interpreter | ADT による AST、再帰関数による評価器 |

これらの差分を、対応する各章の言語固有セクションと、`all/` の統合解説で詳しく扱います。

## 多言語統合解説（all/）

最終章として、各パターンを横断的に比較する統合解説を `docs/article/all/` 配下に配置します。

| ファイル | 内容 |
|----------|------|
| `index.md` | 統合解説の入口 |
| `01-pattern-thinking-across-languages.md` | パターン思考の言語横断比較 |
| `02-oop-vs-fp.md` | OOP パターン と関数型代替の対応表 |
| `03-language-idioms.md` | 各言語のイディオム集（Ruby ブロック / Python デコレータ / Go 埋め込み / Rust トレイト / Haskell 型クラスなど） |
| `04-pattern-anti-patterns.md` | 過剰適用・誤用パターン、いつ使わないかの判断基準 |

## ファイル構成

```
docs/article/
├── index.md                          # 記事トップページ（目次）
├── outline.md                        # 本ファイル（執筆計画）
├── workflow.md                       # 執筆ワークフロー
├── ruby/                             # Ruby（源流。最優先で完成させる）
│   ├── index.md
│   ├── 01-introduction-to-patterns.md
│   ├── 02-principles-and-patterns.md
│   ├── 03-tdd-and-tooling.md
│   ├── 04-template-method.md
│   ├── 05-strategy.md
│   ├── 06-observer.md
│   ├── 07-composite.md
│   ├── 08-iterator.md
│   ├── 09-command.md
│   ├── 10-adapter.md
│   ├── 11-proxy.md
│   ├── 12-decorator.md
│   ├── 13-singleton.md
│   ├── 14-factory.md
│   ├── 15-builder.md
│   └── 16-interpreter.md
├── java/                             # Java
├── javascript/                       # JavaScript
├── typescript/                       # TypeScript
├── python/                           # Python
├── php/                              # PHP
├── go/                               # Go
├── rust/                             # Rust
├── csharp/                           # C#
├── fsharp/                           # F#
├── clojure/                          # Clojure
├── scala/                            # Scala
├── elixir/                           # Elixir
├── haskell/                          # Haskell
└── all/                              # 多言語統合解説
    ├── index.md
    ├── 01-pattern-thinking-across-languages.md
    ├── 02-oop-vs-fp.md
    ├── 03-language-idioms.md
    └── 04-pattern-anti-patterns.md
```

## 実装コードの配置

各言語の実装コードは `apps/` ディレクトリに配置します。前作 TDD 入門で構築した言語別プロジェクトと同居する形で、`apps/{lang}/design-pattern/` のサブディレクトリを切ります。

```
apps/
├── ruby/
│   ├── fizzbuzz/                     # 前作 TDD 入門（既存）
│   └── design-pattern/               # 本シリーズ
│       ├── 04-template-method/
│       ├── 05-strategy/
│       ├── ...
│       └── 16-interpreter/
├── java/
│   └── design-pattern/
│       └── ...
├── javascript/
├── typescript/
├── python/
├── php/
├── go/
├── rust/
├── csharp/
├── fsharp/
├── clojure/
├── scala/
├── elixir/
└── haskell/
```

## イテレーション計画（暫定）

前作 TDD 入門の進捗ペース（1 言語 1 イテレーション）を踏襲します。

| イテレーション | 対象 | 成果物 | 備考 |
|---------------|------|--------|------|
| IT0 | 計画策定 | `index.md` / `outline.md` / `workflow.md` | ✅ 本ドキュメント群 |
| IT1 | Ruby（源流） | 16 章 + `apps/ruby/design-pattern/` | 一次資料の Ruby 実装をベースに執筆 |
| IT2 | Java | 16 章 + `apps/java/design-pattern/` | GoF 古典実装 |
| IT3 | Python | 16 章 + `apps/python/design-pattern/` | デコレータ言語機能の活用 |
| IT4 | JavaScript | 16 章 + `apps/javascript/design-pattern/` | プロトタイプベース、関数オブジェクトでの軽量実装 |
| IT5 | TypeScript | 16 章 + `apps/typescript/design-pattern/` | 静的型付け、ジェネリクス、ユニオン型の活用 |
| IT6 | C# | 16 章 + `apps/csharp/design-pattern/` | OOP の現代的な簡略化（LINQ / デリゲート / 拡張メソッド） |
| IT7 | F# | 16 章 + `apps/fsharp/design-pattern/` | 関数型ファースト、判別共用体での代替 |
| IT8 | PHP | 16 章 + `apps/php/design-pattern/` | 漸進的型付けの活用 |
| IT9 | Go | 16 章 + `apps/go/design-pattern/` | 継承なしのパターン表現 |
| IT10 | Rust | 16 章 + `apps/rust/design-pattern/` | トレイト中心の表現 |
| IT11 | Clojure | 16 章 + `apps/clojure/design-pattern/` | プロトコル / マルチメソッド |
| IT12 | Scala | 16 章 + `apps/scala/design-pattern/` | 型クラスの活用 |
| IT13 | Elixir | 16 章 + `apps/elixir/design-pattern/` | プロセスと Behaviour |
| IT14 | Haskell | 16 章 + `apps/haskell/design-pattern/` | 純粋関数型での代替 |
| IT15 | 多言語統合解説 | `all/` 配下 4 章 | 言語横断の総括 |

## 進捗管理

進捗の詳細は `workflow.md` の進捗管理表に記載します。

## 参照

- 『Design Patterns in Ruby』 - Russ Olsen
- 『Design Patterns: Elements of Reusable Object-Oriented Software』 - Gamma / Helm / Johnson / Vlissides
- 『リファクタリング 第 2 版』 - Martin Fowler
- 『テスト駆動開発』 - Kent Beck
- [前作: テスト駆動開発から始めるプログラミング入門](getting-start-tdd/index.md)
- [一次資料: ruby-design-pattern](https://github.com/nslocum/design-patterns-in-ruby) を改変した `docs/reference/ruby-design-pattern/`
