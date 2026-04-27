package designpattern.iterator

class IteratorSuite extends munit.FunSuite:
  val accounts = List(
    Account("普通預金", 1000.0),
    Account("定期預金", 5000.0),
    Account("投資信託", 3000.0)
  )
  val portfolio = Portfolio(accounts)

  test("for 式でイテレーションできる") {
    val names = for a <- portfolio yield a.name
    assertEquals(names.toList, List("普通預金", "定期預金", "投資信託"))
  }

  test("残高でソートする") {
    val sorted = portfolio.sortedByBalance
    assertEquals(sorted.map(_.name), List("普通預金", "投資信託", "定期預金"))
  }

  test("名前でソートする") {
    val sorted = portfolio.sortedByName
    assertEquals(sorted.head.name, "定期預金")
  }

  test("合計残高を計算する") {
    assertEqualsDouble(portfolio.totalBalance, 9000.0, 0.01)
  }

  test("名前で検索する") {
    val found = portfolio.findByName("定期預金")
    assert(found.isDefined)
    assertEqualsDouble(found.get.balance, 5000.0, 0.01)
  }

  test("フィルタリングする") {
    val rich = portfolio.filterBy(_.balance > 2000)
    assertEquals(rich.length, 2)
  }

  test("map/filter などの高階関数が使える") {
    val total = portfolio.map(_.balance).sum
    assertEqualsDouble(total, 9000.0, 0.01)
  }
