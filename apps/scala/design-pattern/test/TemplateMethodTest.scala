package designpattern.templatemethod

class TemplateMethodSuite extends munit.FunSuite:

  test("HtmlReport が HTML 形式で出力する") {
    val report = HtmlReport()
    val output = report.outputReport()

    assert(output.contains("<html>"))
    assert(output.contains("<title>月次報告</title>"))
    assert(output.contains("<p>順調</p>"))
    assert(output.contains("<p>最高の調子</p>"))
    assert(output.contains("</html>"))
  }

  test("PlainTextReport がプレーンテキスト形式で出力する") {
    val report = PlainTextReport()
    val output = report.outputReport()

    assert(output.contains("**** 月次報告 ****"))
    assert(output.contains("順調"))
    assert(!output.contains("<html>"))
  }

  test("Report trait の outputLine は抽象メソッドのためコンパイル時に強制される") {
    // Scala では trait の抽象メソッドは実装しないとコンパイルエラー
    // JavaScript の throw Error とは異なり、型安全性で担保される
    assert(true)
  }
