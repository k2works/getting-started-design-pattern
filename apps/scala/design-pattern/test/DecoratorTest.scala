package designpattern.decorator

class DecoratorSuite extends munit.FunSuite:
  test("SimpleWriter はそのまま出力する") {
    val writer = SimpleWriter()
    assertEquals(writer.writeLine("Hello"), "Hello")
  }

  test("NumberingWriter で行番号を付与する") {
    val writer = NumberingWriter(SimpleWriter())
    assertEquals(writer.writeLine("Hello"), "1: Hello")
    assertEquals(writer.writeLine("World"), "2: World")
  }

  test("TimestampWriter でタイムスタンプを付与する") {
    val writer = TimestampWriter(SimpleWriter(), "2024-01-01")
    assertEquals(writer.writeLine("Hello"), "[2024-01-01] Hello")
  }

  test("デコレータを積み重ねる") {
    val writer = TimestampWriter(
      NumberingWriter(SimpleWriter()),
      "2024-01-01"
    )
    assertEquals(writer.writeLine("Hello"), "[2024-01-01] 1: Hello")
  }

  test("CheckSumWriter でチェックサムを付与する") {
    val writer = CheckSumWriter(SimpleWriter())
    val output = writer.writeLine("Hello")
    assert(output.startsWith("Hello [checksum:"))
  }

  test("writeLines で複数行を処理する") {
    val writer = NumberingWriter(SimpleWriter())
    val lines = writer.writeLines(Seq("A", "B", "C"))
    assertEquals(lines, Seq("1: A", "2: B", "3: C"))
  }
