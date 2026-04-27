package designpattern.interpreter

import Expression.*

class InterpreterSuite extends munit.FunSuite:
  val files = List(
    FileEntry("report.txt", 1000),
    FileEntry("photo.jpg", 5000),
    FileEntry("data.csv", 2000),
    FileEntry("readme.md", 500),
    FileEntry("backup.txt", 8000)
  )

  test("All はすべてのファイルを返す") {
    val result = Expression.evaluate(All, files)
    assertEquals(result.length, 5)
  }

  test("FileName でパターンマッチングする") {
    val result = Expression.evaluate(FileName("*.txt"), files)
    assertEquals(result.map(_.name), List("report.txt", "backup.txt"))
  }

  test("Bigger で指定サイズより大きいファイルを検索する") {
    val result = Expression.evaluate(Bigger(3000), files)
    assertEquals(result.map(_.name), List("photo.jpg", "backup.txt"))
  }

  test("Not で条件を反転する") {
    val result = Expression.evaluate(Not(FileName("*.txt")), files)
    assertEquals(result.length, 3)
    assert(!result.exists(_.name.endsWith(".txt")))
  }

  test("And で条件を組み合わせる") {
    val expr = And(FileName("*.txt"), Bigger(3000))
    val result = Expression.evaluate(expr, files)
    assertEquals(result.map(_.name), List("backup.txt"))
  }

  test("Or で条件を結合する") {
    val expr = Or(FileName("*.jpg"), FileName("*.md"))
    val result = Expression.evaluate(expr, files)
    assertEquals(result.map(_.name), List("photo.jpg", "readme.md"))
  }

  test("複雑な式を組み合わせる") {
    // (*.txt AND size > 3000) OR *.md
    val expr = Or(
      And(FileName("*.txt"), Bigger(3000)),
      FileName("*.md")
    )
    val result = Expression.evaluate(expr, files)
    assertEquals(result.map(_.name), List("readme.md", "backup.txt"))
  }
