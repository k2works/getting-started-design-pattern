# 第 3 章: 開発環境と TDD 基盤

## はじめに

Haskell でテスト駆動開発（TDD）を行うための環境を構築します。Cabal をビルドツールとして、HUnit をテストフレームワークとして使用します。

---

## 環境構築

### Nix による環境管理

```bash
nix-shell ops/nix/environments/haskell/shell.nix
```

### プロジェクト構成

```
apps/haskell/design-pattern/
+-- design-pattern.cabal    -- ビルド定義
+-- src/                    -- ソースコード
+-- test/                   -- テストコード
    +-- Main.hs             -- テストランナー
```

### Cabal ファイル

```cabal
cabal-version: 3.0
name:          design-pattern
version:       1.0.0

library
  exposed-modules: TemplateMethod, Strategy, ...
  build-depends:   base >=4.14 && <5, containers
  hs-source-dirs:  src

test-suite tests
  type:          exitcode-stdio-1.0
  main-is:       Main.hs
  build-depends: base, design-pattern, HUnit
  hs-source-dirs: test
```

---

## HUnit によるテスト

### テストの書き方

```haskell
module TemplateMethodTest (tests) where

import Test.HUnit
import TemplateMethod

tests :: Test
tests = TestLabel "TemplateMethod" $ TestList
  [ testHtmlFormat
  , testPlainTextFormat
  ]

testHtmlFormat :: Test
testHtmlFormat = TestCase $ do
  let result = generateReport htmlFormat "月次報告" ["順調"]
  assertBool "HTML タグを含む" ("<html>" `isInfixOf` result)
```

### テストランナー

```haskell
module Main where

import Test.HUnit
import System.Exit
import qualified TemplateMethodTest

main :: IO ()
main = do
  counts <- runTestTT $ TestList [TemplateMethodTest.tests]
  if errors counts + failures counts == 0
    then exitSuccess
    else exitFailure
```

---

## TDD サイクル

### 1. Red: 失敗するテストを書く

```bash
$ cabal test
# コンパイルエラー（モジュールが存在しない）
```

### 2. Green: テストを通す最小のコードを書く

```haskell
module TemplateMethod (generateReport, htmlFormat) where

htmlFormat :: ReportFormat
htmlFormat = ...
```

### 3. Refactor: 設計を改善する

テストが通った状態で、命名の改善や重複の除去を行います。

---

## テスト実行

```bash
cd apps/haskell/design-pattern
cabal test
```

```
Cases: 62  Tried: 62  Errors: 0  Failures: 0
Test suite tests: PASS
```

---

## 静的コード解析: GHC -Wall + HLint

### GHC -Wall（コンパイラ警告）

`.cabal` ファイルで `ghc-options: -Wall` を設定することで、コンパイル時に以下を検出します。

```cabal
library
  ghc-options: -Wall

test-suite tests
  ghc-options: -Wall
```

| 警告 | 説明 |
|------|------|
| `-Wmissing-signatures` | 型シグネチャの欠如 |
| `-Wunused-binds` | 未使用の束縛 |
| `-Wincomplete-patterns` | パターンマッチの網羅性不足 |
| `-Wname-shadowing` | 変数のシャドーイング |

### HLint

HLint は Haskell の静的解析ツールで、コードの改善提案を行います。

```bash
# 解析の実行
hlint src/ test/

# JSON 形式で出力
hlint src/ test/ --json
```

### .hlint.yaml の設定

教材コードとして意図的なスタイルを維持するため、一部のルールを無効化しています。

```yaml
# .hlint.yaml
# 明示的なラムダは学習者にとって読みやすい
- ignore: {name: "Avoid lambda using `infix`"}
- ignore: {name: "Use const"}
# 明示的なパターンマッチは学習者にとって意図が明確
- ignore: {name: "Use record patterns"}
- ignore: {name: "Replace case with fromMaybe"}
```

### HLint の主なルール

| カテゴリ | 説明 |
|---------|------|
| Warning | 修正すべき問題（`Use id`, `Redundant lambda`） |
| Suggestion | コードの簡素化提案（`Use const`, `Avoid lambda`） |
| Error | 潜在的バグの指摘 |

---

## コード複雑度のチェック

Haskell の型システムは非常に強力で、多くの実行時エラーをコンパイル時に検出します。

| 手法 | 説明 |
|------|------|
| GHC -Wall | コンパイラレベルの警告で品質を保証 |
| HLint | イディオマティックな Haskell への改善提案 |
| 型システム | 代数的データ型とパターンマッチで網羅性を保証 |
| 純粋関数 | 副作用の分離により、関数単位でのテストが容易 |

Haskell では、型システムが他の言語における静的解析ツールの多くの役割を担います。例えば、`Maybe` 型による null 安全性、パターンマッチの網羅性チェックなどは、言語レベルで保証されます。

---

## 品質チェックの一括実行

コンパイラ警告チェック、静的解析、テストを一括で実行するコマンドです。

```bash
# ビルド（-Wall で警告チェック）+ HLint + テスト
cabal build && hlint src/ test/ && cabal test
```

### 各言語の品質ツール比較

| 用途 | Haskell | Ruby | Java | TypeScript | Python |
|------|---------|------|------|-----------|--------|
| パッケージ管理 | Cabal | Bundler | Gradle | npm | uv |
| テスト | HUnit | minitest | JUnit 5 | Jest | pytest |
| 静的解析 | GHC -Wall + HLint | RuboCop | Checkstyle + PMD | ESLint | Ruff |
| フォーマッター | Ormolu / Fourmolu | RuboCop | Checkstyle | Prettier | Ruff |
| カバレッジ | HPC | SimpleCov | JaCoCo | @vitest/coverage-v8 | pytest-cov |
| 複雑度チェック | HLint + 型システム | RuboCop Metrics | PMD | ESLint complexity | Ruff McCabe |

---

## まとめ

- Haskell の型システムはコンパイル時に多くのバグを検出する
- HUnit による TDD と組み合わせることで、型では検出できないビジネスロジックの正しさも保証できる
- GHC `-Wall` で潜在的問題を検出し、HLint でイディオマティックな改善を行う
- `cabal build && hlint src/ test/ && cabal test` で品質チェックを一括実行できる
- 次章から、具体的なデザインパターンの実装に入る
