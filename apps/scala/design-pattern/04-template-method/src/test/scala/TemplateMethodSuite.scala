import munit.FunSuite

class TemplateMethodSuite extends FunSuite:
  test("HtmlReport が HTML 形式で出力する") {
    val report = HtmlReport()
    val output = report.outputReport()

    assert(output.contains("<html>"), output)
    assert(output.contains("<title>月次報告</title>"), output)
    assert(output.contains("<p>順調</p>"), output)
    assert(output.contains("</html>"), output)
  }

  test("PlainTextReport がプレーンテキスト形式で出力する") {
    val report = PlainTextReport()
    val output = report.outputReport()

    assert(output.contains("**** 月次報告 ****"), output)
    assert(output.contains("順調"), output)
    assert(!output.contains("<html>"), output)
  }
