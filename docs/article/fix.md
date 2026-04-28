# Ruby 版への品質チェック導入手順

本ドキュメントは、Ruby 版デザインパターン記事（第 3 章）に品質チェックトピックを追記し、実装コード（`apps/ruby/design-pattern/`）に RuboCop を導入した手順をまとめたものです。

---

## ステップ 1: 記事の追記

### 対象ファイル

`docs/article/ruby/03-tdd-and-tooling.md`

### 追記内容

前作 [テスト駆動開発から始めるプログラミング入門](../../tmp/getting-started-tdd/docs/article/ruby/05-package-management-and-static-analysis.md) の品質チェックトピックを参照し、以下のセクションを「カバレッジ測定」セクションの後に追加した。

1. **静的コード解析: RuboCop** --- `.rubocop.yml` の設定例と主要ルール解説
2. **コード複雑度のチェック** --- 循環的複雑度（Cyclomatic Complexity）と認知的複雑度（Perceived Complexity）の解説、閾値 7 以下の制限
3. **品質チェックの一括実行** --- `rake check` タスク（`rubocop` + `test` を順番に実行）の定義
4. **各言語の品質ツール比較** --- Ruby / Java / TypeScript / Python の品質ツール対応表

### まとめセクションの更新

- RuboCop による静的解析と `bundle exec rake check` による一括実行を追加

### コミット

```
docs(ruby): 第 3 章に品質チェックトピックを追記
```

---

## ステップ 2: RuboCop の導入と全コード自動修正

### 2.1 Gemfile に rubocop を追加

```ruby
# Gemfile に追加
gem 'rubocop', '~> 1.68', require: false
```

```bash
bundle install
```

### 2.2 Rakefile に check タスクを追加

```ruby
task :rubocop do
  sh 'bundle exec rubocop'
end

task check: %i[rubocop test]
```

### 2.3 .rubocop.yml を作成

基本設定として以下を定義した。

```yaml
AllCops:
  TargetRubyVersion: 3.3
  NewCops: enable
  SuggestExtensions: false

Style/Documentation:
  Enabled: false

Style/FrozenStringLiteralComment:
  Enabled: true

Metrics/MethodLength:
  Max: 20

Metrics/CyclomaticComplexity:
  Max: 7

Metrics/PerceivedComplexity:
  Max: 7
```

### 2.4 自動修正の実行

```bash
bundle exec rubocop --autocorrect-all
```

**結果**: 393 件検出 → 301 件自動修正

主な自動修正内容:

| 修正内容 | 件数 |
|---------|------|
| `"string"` → `'string'`（StringLiterals） | 多数 |
| `[:a, :b]` → `%i[a b]`（SymbolArray） | 数件 |
| `while ... end` → `... while ...`（WhileUntilModifier） | 数件 |

### 2.5 手動対応が必要な違反のルール除外

自動修正で解消しなかった違反は、パターン実装の教材としての意図を尊重し、`.rubocop.yml` でルール除外を設定した。

| ルール | 除外理由 |
|--------|---------|
| `Naming/AccessorMethodName` | 一次資料（Russ Olsen 本）の `get_time_required` 等の API に忠実 |
| `Naming/PredicatePrefix` | `has_next?` は一次資料の API |
| `Style/OneClassPerFile` | パターン実装では関連クラスを 1 ファイルにまとめる |
| `Lint/MissingSuper` | サブクラスが意図的に `super` を省略するケースがある |
| `Style/ClassVars` | Singleton パターンの教材としてクラス変数 `@@` の使用を解説 |
| `Style/OptionalBooleanParameter` | Builder パターンの一次資料に忠実な boolean パラメータ |
| `Lint/DuplicateMethods` | Builder の `computer` メソッド（getter と validation の二重定義） |
| `Metrics/CyclomaticComplexity` (Interpreter) | Parser の `parse_expression` は構造上複雑度 9 になる |
| `Metrics/MethodLength` (Interpreter) | Parser のメソッドが 23 行（上限 20） |
| `Metrics/AbcSize` | Interpreter / Builder テストの ABC サイズを緩和（Max: 25） |
| `Layout/LineLength` | Max: 200 に緩和（Strategy テストの Unicode エスケープ行） |

### 2.6 最終確認

```bash
bundle exec rake check
```

**結果**:

- RuboCop: 37 files inspected, **no offenses detected**
- minitest: 74 tests, 200 assertions, **0 failures, 0 errors**
- Line Coverage: 96.85%
- Branch Coverage: 78.69%

### コミット

```
chore(ruby): RuboCop を導入し全コードを自動修正
```

---

## 他言語への横展開

この手順は他の言語にも適用できる。各言語の対応ツールは以下の通り。

| 用途 | Ruby | Java | TypeScript | Python |
|------|------|------|-----------|--------|
| 静的解析 | RuboCop | Checkstyle + PMD | ESLint | Ruff |
| フォーマッター | RuboCop | Checkstyle | Prettier | Ruff |
| カバレッジ | SimpleCov | JaCoCo | @vitest/coverage-v8 | pytest-cov |
| 複雑度チェック | RuboCop Metrics | PMD | ESLint complexity | Ruff McCabe |
| 一括実行 | `rake check` | `./gradlew check` | `npm run lint && npm test` | `ruff check && pytest` |
