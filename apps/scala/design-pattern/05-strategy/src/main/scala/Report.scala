type Formatter = (String, Seq[String]) => String

val htmlFormatter: Formatter = (title, text) =>
  val lines =
    Seq("<html>", " <head>", s"  <title>$title</title>", " </head>", "<body>") ++
      text.map(line => s"  <p>$line</p>") ++ Seq("</body>", "</html>")
  lines.mkString("\n")

val plainTextFormatter: Formatter = (title, text) =>
  (Seq(s"**** $title ****", "") ++ text).mkString("\n")

case class Report(
    title: String = "月次報告",
    text: Seq[String] = Seq("順調", "最高の調子"),
    formatter: Formatter = htmlFormatter
):
  def outputReport(): String = formatter(title, text)
  def withFormatter(formatter: Formatter): Report = copy(formatter = formatter)
