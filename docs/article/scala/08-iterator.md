# 第 8 章: Iterator

## はじめに

ポートフォリオの口座を残高順にソートしたり、条件でフィルタリングしたりしたいとします。内部のデータ構造を公開せずに、要素への順次アクセスを提供するにはどうすべきでしょうか。

**Iterator パターン**は、コレクションの内部構造を公開せずに、要素への順次アクセスを提供するパターンです。

---

## パターンの構造

```plantuml
@startuml
title Iterator パターン（Scala: Iterable + given Ordering）

class Account {
  + name : String
  + balance : Double
}

class Portfolio {
  - accounts : List[Account]
  + iterator : Iterator[Account]
  + sortedByBalance : List[Account]
  + sortedByName : List[Account]
  + totalBalance : Double
}

interface "Iterable[Account]" as Iter

note bottom of Account
  given Ordering[Account] =
    Ordering.by(_.balance)
end note

Iter <|.. Portfolio
Portfolio --> Account
@enduml
```

---

## TDD で作る

### Red: テストを書く

```scala
class IteratorSuite extends munit.FunSuite:
  val portfolio = Portfolio(List(
    Account("普通預金", 1000.0),
    Account("定期預金", 5000.0),
    Account("投資信託", 3000.0)
  ))

  test("for 式でイテレーションできる") {
    val names = for a <- portfolio yield a.name
    assertEquals(names.toList, List("普通預金", "定期預金", "投資信託"))
  }

  test("残高でソートする") {
    val sorted = portfolio.sortedByBalance
    assertEquals(sorted.map(_.name), List("普通預金", "投資信託", "定期預金"))
  }
```

### Green: 実装する

```scala
case class Account(name: String, balance: Double)

object Account:
  given Ordering[Account] = Ordering.by(_.balance)

class Portfolio(private val accounts: List[Account]) extends Iterable[Account]:
  override def iterator: Iterator[Account] = accounts.iterator

  def sortedByBalance: List[Account] =
    import Account.given
    accounts.sorted

  def sortedByName: List[Account] = accounts.sortBy(_.name)
  def totalBalance: Double = accounts.map(_.balance).sum
```

### Refactor: 振り返り

- **`Iterable[Account]`** を extends することで、`for` 式、`map`、`filter`、`sum` などの高階関数がすべて使えます。
- **`given Ordering[Account]`** は型クラスパターンの典型例で、暗黙のソート順を定義します。
- `sorted` メソッドは `using` で暗黙の `Ordering` を受け取ります。

---

## まとめ

| 観点 | 内容 |
|------|------|
| **意図** | コレクションの内部構造を公開せずに要素へ順次アクセスを提供する |
| **適用場面** | カスタムコレクションを標準的な方法で走査したい場合 |
| **Scala のアプローチ** | `Iterable` trait + `given Ordering` |
| **メリット** | 標準ライブラリの高階関数がそのまま利用可能、型クラスでソート順を柔軟に定義 |
| **関連パターン** | Composite（木構造の走査）、Strategy（ソート戦略の差し替え） |
