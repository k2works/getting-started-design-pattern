# 第 8 章: Iterator

## はじめに

ポートフォリオ内の口座を様々な方法で走査したいとします。残高順、種別ごと、名前一覧など。

**Iterator パターン**は、コレクションの内部構造を隠しつつ、要素を順に処理する方法を提供するパターンです。

---

## パターンの構造

```plantuml
@startuml
title Iterator パターン（Haskell 版）

class Portfolio {
  + accounts : [Account]
}

class Account {
  + acctName : String
  + acctType : AccountType
  + acctBalance : Double
}

class "totalBalance" <<function>> {
  + Portfolio -> Double
}
class "filterByType" <<function>> {
  + AccountType -> Portfolio -> [Account]
}
class "sortByBalance" <<function>> {
  + Portfolio -> [Account]
}
class "accountNames" <<function>> {
  + Portfolio -> [String]
}

Portfolio o-- Account
"totalBalance" --> Portfolio
"filterByType" --> Portfolio
"sortByBalance" --> Portfolio
"accountNames" --> Portfolio
@enduml
```

---

## Haskell イディオム: リスト関数

Haskell ではリストが標準のイテレータです。`map`、`filter`、`fold`、`sort` などの高階関数が Iterator パターンの役割を果たします。

```haskell
-- map: 各要素を変換
accountNames :: Portfolio -> [String]
accountNames = map acctName . accounts

-- filter: 条件で絞り込み
filterByType :: AccountType -> Portfolio -> [Account]
filterByType t = filter (\a -> acctType a == t) . accounts

-- fold: 畳み込み
totalBalance :: Portfolio -> Double
totalBalance = sum . map acctBalance . accounts
```

---

## TDD で作る

### Red

```haskell
testSortByBalance :: Test
testSortByBalance = TestCase $ do
  let sorted = sortByBalance portfolio
  assertEqual "最小残高" 50000.0 (acctBalance (head sorted))
  assertEqual "最大残高" 200000.0 (acctBalance (last sorted))
```

### Green

```haskell
sortByBalance :: Portfolio -> [Account]
sortByBalance = sortBy (comparing acctBalance) . accounts

accountNames :: Portfolio -> [String]
accountNames = map acctName . accounts

filterByType :: AccountType -> Portfolio -> [Account]
filterByType target = filter (\acct -> acctType acct == target) . accounts
```

並び替えだけでなく、`map` と `filter` もそろえておくと Haskell における Iterator の実体が見えやすくなります。

---

## ポートフォリオの構築と統合

### addAccount: 口座の追加

`addAccount` は既存のポートフォリオに口座を追加した新しいポートフォリオを返します。イミュータブルなので元のポートフォリオは変更されません。

```haskell
addAccount :: Account -> Portfolio -> Portfolio
addAccount a (Portfolio as) = Portfolio (as ++ [a])
```

```haskell
-- 使用例
let p = addAccount (Account "普通預金" Savings 100000.0)
      . addAccount (Account "当座預金" Checking 50000.0)
      $ newPortfolio
-- accountNames p == ["当座預金", "普通預金"]
```

### mergePortfolios: 2 つのポートフォリオの統合

`mergePortfolios` は 2 つのポートフォリオの口座リストを連結して 1 つにまとめます。

```haskell
mergePortfolios :: Portfolio -> Portfolio -> Portfolio
mergePortfolios (Portfolio a) (Portfolio b) = Portfolio (a ++ b)
```

```haskell
-- 使用例
let p1 = addAccount (Account "預金A" Savings 100000.0) newPortfolio
    p2 = addAccount (Account "投資B" Investment 200000.0) newPortfolio
    merged = mergePortfolios p1 p2
-- totalBalance merged == 300000.0
```

---

## まとめ

Haskell では Iterator パターンは言語に組み込まれています。リストと高階関数（`map`、`filter`、`fold`、`sort`）がそのまま Iterator の抽象化です。OOP で必要な Iterator インターフェースと具象クラスは不要です。
