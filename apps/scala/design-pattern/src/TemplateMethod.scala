// Template Method パターン
// アルゴリズムの骨格を trait で定義し、具体的なステップをサブクラスに委ねる

package designpattern.templatemethod

trait Report:
  val title: String     = "月次報告"
  val text: Seq[String] = Seq("順調", "最高の調子")

  // テンプレートメソッド: レポート出力の骨格
  def outputReport(): String =
    val lines =
      outputStart() ++
        outputHead() ++
        outputBodyStart() ++
        outputBody() ++
        outputBodyEnd() ++
        outputEnd()
    lines.mkString("\n")

  def outputBody(): Seq[String] =
    text.flatMap(line => outputLine(line))

  // フックメソッド（デフォルトは何もしない）
  def outputStart(): Seq[String]     = Seq.empty
  def outputHead(): Seq[String]      = outputLine(title)
  def outputBodyStart(): Seq[String] = Seq.empty

  // 抽象メソッド
  def outputLine(line: String): Seq[String]

  def outputBodyEnd(): Seq[String] = Seq.empty
  def outputEnd(): Seq[String]     = Seq.empty

class HtmlReport extends Report:
  override def outputStart(): Seq[String] = Seq("<html>")

  override def outputHead(): Seq[String] =
    Seq(" <head>", s"  <title>$title</title>", " </head>")

  override def outputBodyStart(): Seq[String]        = Seq("<body>")
  override def outputLine(line: String): Seq[String] = Seq(s"  <p>$line</p>")
  override def outputBodyEnd(): Seq[String]          = Seq("</body>")
  override def outputEnd(): Seq[String]              = Seq("</html>")

class PlainTextReport extends Report:

  override def outputHead(): Seq[String] =
    Seq(s"**** $title ****", "")

  override def outputLine(line: String): Seq[String] = Seq(line)
