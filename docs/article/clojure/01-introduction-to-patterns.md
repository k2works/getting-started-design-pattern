# 第 1 章 デザインパターンへの誘い

## はじめに

デザインパターンとは、ソフトウェア設計で繰り返し現れる問題に対する再利用可能な解決策のカタログです。1994 年に GoF（Gang of Four）が体系化した 23 のパターンは、オブジェクト指向プログラミングの文脈で生まれました。

## Clojure と デザインパターン

Clojure は関数型プログラミング言語であり、JVM 上で動作します。不変データ、第一級関数、マルチメソッド、プロトコルといった言語機能を持ち、オブジェクト指向言語とは異なるアプローチで問題を解決します。

多くの GoF パターンは、オブジェクト指向言語の制約を回避するための工夫でした。Clojure ではそれらの制約がそもそも存在しないため、パターンが言語機能に吸収されることが多くあります。

## パターンの Clojure 的解釈

| GoF パターン | Clojure での対応 |
|:---|:---|
| Template Method | 高階関数 |
| Strategy | 関数を引数として渡す |
| Observer | atom + add-watch |
| Composite | 再帰的データ構造 + マルチメソッド |
| Iterator | シーケンス抽象（lazy-seq） |
| Command | マップ（:execute, :undo） |
| Adapter | プロトコル + reify |
| Proxy | delay/force、関数ラッパー |
| Decorator | 関数合成（comp） |
| Singleton | def / defonce |
| Factory | マルチメソッド |
| Builder | スレッディングマクロ（->） |
| Interpreter | データとしての AST + マルチメソッド |

## 本シリーズの構成

4 部 16 章で構成し、各章ではパターンの意図、Clojure での実装、テストコードを示します。

## Clojure プロジェクトの構成

```
apps/clojure/design-pattern/
├── project.clj
├── src/design_pattern/
│   ├── template_method.clj
│   ├── strategy.clj
│   └── ...
└── test/design_pattern/
    ├── template_method_test.clj
    └── ...
```

テストの実行は以下のコマンドで行います。

```bash
lein test
```

## 静的コード解析: Eastwood

### Eastwood とは

Eastwood は Clojure の静的コード解析（Lint）ツールです。暗黙の依存関係、未使用の変数、間違った引数の数などを検出します。

### インストール

```clojure
;; project.clj に追加
:plugins [[jonase/eastwood "1.4.3"]]
:aliases {"check" ["do" ["eastwood"] ["test"]]}
```

### Eastwood の実行

```bash
# 静的解析の実行
lein eastwood

# 静的解析 + テストの一括実行
lein check
```

### Eastwood の主要なルール

| ルール | 説明 |
|--------|------|
| `implicit-dependencies` | 明示的に require されていない名前空間の使用 |
| `unused-ret-vals` | 戻り値が使われていない関数呼び出し |
| `wrong-arity` | 引数の数が間違っている関数呼び出し |
| `suspicious-expression` | 疑わしい式（常に true になる条件など） |
| `unused-namespaces` | 使用されていない require |

### コード複雑度のチェック

Clojure の関数型スタイルと不変データ構造は、自然にコードの複雑度を低く保ちます。

| 手法 | 説明 |
|------|------|
| Eastwood | 暗黙の依存関係、未使用変数の検出 |
| `lein check` | コンパイル時チェック |
| 不変データ | 状態の変化を atom に限定し、予測可能性を向上 |
| REPL | 対話的な開発で即座にフィードバックを得る |

### 品質チェックの一括実行

```bash
# 静的解析 + テスト
lein check
```

### 各言語の品質ツール比較

| 用途 | Clojure | Ruby | Java | TypeScript | Python |
|------|---------|------|------|-----------|--------|
| パッケージ管理 | Leiningen | Bundler | Gradle | npm | uv |
| テスト | clojure.test | minitest | JUnit 5 | Jest | pytest |
| 静的解析 | Eastwood | RuboCop | Checkstyle + PMD | ESLint | Ruff |
| フォーマッター | cljfmt | RuboCop | Checkstyle | Prettier | Ruff |
| カバレッジ | cloverage | SimpleCov | JaCoCo | @vitest/coverage-v8 | pytest-cov |
| 複雑度チェック | Eastwood | RuboCop Metrics | PMD | ESLint complexity | Ruff McCabe |
