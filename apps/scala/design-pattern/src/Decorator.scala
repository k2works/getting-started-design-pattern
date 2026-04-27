// Decorator パターン
// Scala のスタッカブル trait パターンで動的に機能を追加する

package designpattern.decorator

// コンポーネントインターフェース
trait Writer:
  def writeLine(line: String): String
  def writeLines(lines: Seq[String]): Seq[String] =
    lines.map(writeLine)

// 具体コンポーネント
class SimpleWriter extends Writer:
  override def writeLine(line: String): String = line

// デコレータ基底
trait WriterDecorator extends Writer:
  protected val wrapped: Writer
  override def writeLine(line: String): String = wrapped.writeLine(line)

// 行番号付与デコレータ
class NumberingWriter(protected val wrapped: Writer) extends WriterDecorator:
  private var lineNumber: Int = 0

  override def writeLine(line: String): String =
    lineNumber += 1
    s"$lineNumber: ${wrapped.writeLine(line)}"

// タイムスタンプ付与デコレータ
class TimestampWriter(protected val wrapped: Writer, timestamp: String = "2024-01-01") extends WriterDecorator:
  override def writeLine(line: String): String =
    s"[$timestamp] ${wrapped.writeLine(line)}"

// チェックサム付与デコレータ
class CheckSumWriter(protected val wrapped: Writer) extends WriterDecorator:
  override def writeLine(line: String): String =
    val base = wrapped.writeLine(line)
    val checksum = base.hashCode.toHexString
    s"$base [checksum: $checksum]"
