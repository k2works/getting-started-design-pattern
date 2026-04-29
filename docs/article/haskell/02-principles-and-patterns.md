# 第 2 章: パターンを支える基本原則

## はじめに

デザインパターンは単独で存在するわけではなく、いくつかの基本原則に支えられています。Haskell ではこれらの原則が型システムと言語仕様に組み込まれています。

---

## 変更に強い設計の原則

### 変わるものを変わらないものから分離する

```haskell
-- 変わらないもの: レポートの骨格
generateReport :: ReportFormat -> String -> [String] -> String
generateReport fmt title body =
  outputStart fmt title
  ++ concatMap (outputLine fmt) body
  ++ outputEnd fmt title

-- 変わるもの: フォーマットの詳細（レコードで注入）
data ReportFormat = ReportFormat
  { outputStart :: String -> String
  , outputLine  :: String -> String
  , outputEnd   :: String -> String
  }
```

### インターフェースに対してプログラミングする

Haskell では**型クラス**がインターフェースの役割を果たします。

```haskell
class Renderable a where
  render :: a -> String

-- 具体的な型はインスタンスとして適合
instance Renderable OldPrinter where
  render p = "=== " ++ opHeader p ++ " ==="
```

### 継承よりも委譲を選ぶ

Haskell にはクラス継承がありません。代わりに**関数合成**と**レコード**で委譲を実現します。

```haskell
-- 関数合成による委譲
decorated :: Writer
decorated = withChecksum . withLineNumber . withTimestamp "2024-01-01" $ baseWriter
```

---

## SOLID 原則と Haskell

| 原則 | Haskell での実現 |
|------|----------------|
| 単一責任 | モジュール分割、小さな関数 |
| 開放閉鎖 | 型クラスのインスタンス追加 |
| リスコフの置換 | パラメトリック多相 |
| インターフェース分離 | 型クラスの細分化 |
| 依存性逆転 | 高階関数によるコールバック注入 |

---

## Haskell 固有の原則

### 参照透過性

同じ引数に対して常に同じ結果を返す関数は、テストが容易で推論しやすいです。

```haskell
-- 純粋関数: 何度呼んでも同じ結果
changeSalary :: Double -> PureSubject -> PureSubject
```

### 型で不変条件を表現する

```haskell
-- Either で成功/失敗を型で表現
accessDocument :: AccessLevel -> ProtectedDoc -> Either String Document
```

### 代数的データ型でドメインをモデリングする

```haskell
-- 不正な状態を型で排除
data Animal = Dog String Int | Cat String Int | Duck String Int
```

---

## まとめ

Haskell では設計原則の多くが言語仕様に組み込まれています。型システムが設計の正しさを保証し、純粋関数がテスタビリティを担保します。次章では、開発環境と TDD 基盤を整備します。
