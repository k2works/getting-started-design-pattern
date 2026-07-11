import munit.FunSuite

class StrategySuite extends FunSuite:
  test("HTML フォーマッタでレポートを出力する") {
    val report = Report()
    val output = report.outputReport()

    assert(output.contains("<html>"), output)
  }

  test("プレーンテキストフォーマッタに切り替える") {
    val report = Report().withFormatter(plainTextFormatter)
    val output = report.outputReport()

    assert(output.contains("**** 月次報告 ****"), output)
    assert(!output.contains("<html>"), output)
  }

  test("ラムダ式でカスタムフォーマッタを渡す") {
    val csvFormatter: Formatter = (title, text) =>
      (title +: text).mkString(",")
    val report = Report(formatter = csvFormatter)

    assertEquals(report.outputReport(), "月次報告,順調,最高の調子")
  }
