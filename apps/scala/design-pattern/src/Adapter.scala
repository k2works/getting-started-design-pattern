// Adapter パターン
// trait を使ってインターフェースの不一致を解消する

package designpattern.adapter

// ターゲットインターフェース
trait TextObject:
  def text: String
  def sizeInBytes: Int

// 適合されるクラス（既存のインターフェース）
class BritishTextObject:
  private var _string: String = "default british text"

  def string: String                = _string
  def string_=(value: String): Unit = _string = value
  def lengthInChars: Int            = _string.length

// アダプタ
class BritishTextObjectAdapter(adaptee: BritishTextObject) extends TextObject:
  override def text: String     = adaptee.string
  override def sizeInBytes: Int = adaptee.lengthInChars

  def text_=(value: String): Unit = adaptee.string = value

// 修正版アダプタ（文字列をバイト列でカウント）
class Utf8BritishTextObjectAdapter(adaptee: BritishTextObject) extends TextObject:
  override def text: String     = adaptee.string
  override def sizeInBytes: Int = adaptee.string.getBytes("UTF-8").length

  def text_=(value: String): Unit = adaptee.string = value
