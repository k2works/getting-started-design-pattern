trait TextObject:
  def text: String
  def sizeInBytes: Int

class BritishTextObject:
  private var _string: String = "default british text"

  def string: String = _string
  def string_=(value: String): Unit = _string = value
  def lengthInChars: Int = _string.length

class BritishTextObjectAdapter(adaptee: BritishTextObject) extends TextObject:
  override def text: String = adaptee.string
  override def sizeInBytes: Int = adaptee.lengthInChars

class Utf8BritishTextObjectAdapter(adaptee: BritishTextObject) extends TextObject:
  override def text: String = adaptee.string
  override def sizeInBytes: Int =
    adaptee.string.getBytes(java.nio.charset.StandardCharsets.UTF_8).length
