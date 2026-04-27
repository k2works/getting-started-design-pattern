// Strategy パターン
// 第一級関数と型エイリアスを活用してアルゴリズムを差し替える

package designpattern.strategy

// 型エイリアスでフォーマッタを定義
type Formatter = (String, Seq[String]) => String

// HTML フォーマッタ
val htmlFormatter: Formatter = (title, text) =>
  val lines = Seq(
    "<html>",
    " <head>",
    s"  <title>$title</title>",
    " </head>",
    "<body>"
  ) ++ text.map(line => s"  <p>$line</p>") ++ Seq(
    "</body>",
    "</html>"
  )
  lines.mkString("\n")

// プレーンテキストフォーマッタ
val plainTextFormatter: Formatter = (title, text) =>
  val lines = Seq(s"**** $title ****", "") ++ text
  lines.mkString("\n")

// レポートクラス（フォーマッタを受け取る）
case class Report(
  title: String = "月次報告",
  text: Seq[String] = Seq("順調", "最高の調子"),
  formatter: Formatter = htmlFormatter
):
  def outputReport(): String = formatter(title, text)

  def withFormatter(f: Formatter): Report = copy(formatter = f)
