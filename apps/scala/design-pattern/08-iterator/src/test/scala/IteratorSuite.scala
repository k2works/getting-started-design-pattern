import munit.FunSuite

class IteratorSuite extends FunSuite:
  val portfolio = Portfolio(
    List(
      Account("普通預金", 1000.0),
      Account("定期預金", 5000.0),
      Account("投資信託", 3000.0)
    )
  )

  test("for 式でイテレーションできる") {
    val names = for account <- portfolio yield account.name

    assertEquals(
      names.toList,
      List("普通預金", "定期預金", "投資信託"),
      names
    )
  }

  test("残高でソートする") {
    val sorted = portfolio.sortedByBalance

    assertEquals(
      sorted.map(_.name),
      List("普通預金", "投資信託", "定期預金"),
      sorted
    )
  }

  test("名前で口座を検索する") {
    assertEquals(
      portfolio.findByName("定期預金"),
      Some(Account("定期預金", 5000.0)),
      portfolio
    )
    assertEquals(portfolio.findByName("存在しない"), None, portfolio)
  }

  test("条件で口座をフィルタリングする") {
    val accounts = portfolio.filterBy(_.balance >= 3000.0)

    assertEquals(
      accounts.map(_.name),
      List("定期預金", "投資信託"),
      accounts
    )
  }

  test("口座残高を合計する") {
    assertEqualsDouble(portfolio.totalBalance, 9000.0, 0.01)
  }

  test("名前でソートする") {
    val sorted = portfolio.sortedByName

    assertEquals(
      sorted.map(_.name),
      List("定期預金", "投資信託", "普通預金"),
      sorted
    )
  }
