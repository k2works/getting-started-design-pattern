package designpattern.strategy

class StrategySuite extends munit.FunSuite:

  test("HTML フォーマッタでレポートを出力する") {
    val report = Report()
    val output = report.outputReport()

    assert(output.contains("<html>"))
    assert(output.contains("<title>月次報告</title>"))
    assert(output.contains("<p>順調</p>"))
  }

  test("プレーンテキストフォーマッタに切り替える") {
    val report = Report().withFormatter(plainTextFormatter)
    val output = report.outputReport()

    assert(output.contains("**** 月次報告 ****"))
    assert(output.contains("順調"))
    assert(!output.contains("<html>"))
  }

  test("ラムダ式でカスタムフォーマッタを渡す") {
    val csvFormatter: Formatter = (title, text) => (title +: text).mkString(",")

    val report = Report(formatter = csvFormatter)
    val output = report.outputReport()

    assertEquals(output, "月次報告,順調,最高の調子")
  }

  test("case class の copy でイミュータブルに変更する") {
    val original = Report()
    val modified = original.withFormatter(plainTextFormatter)

    // 元のレポートは変更されない
    assert(original.outputReport().contains("<html>"))
    assert(!modified.outputReport().contains("<html>"))
  }
