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

## まとめ

Haskell の型システムはコンパイル時に多くのバグを検出します。HUnit による TDD と組み合わせることで、型では検出できないビジネスロジックの正しさも保証できます。次章から、具体的なデザインパターンの実装に入ります。
