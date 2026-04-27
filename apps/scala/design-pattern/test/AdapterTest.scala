package designpattern.adapter

class AdapterSuite extends munit.FunSuite:
  test("BritishTextObjectAdapter が TextObject インターフェースを提供する") {
    val british = BritishTextObject()
    val adapter = BritishTextObjectAdapter(british)

    assertEquals(adapter.text, "default british text")
    assertEquals(adapter.sizeInBytes, 20) // lengthInChars
  }

  test("アダプタ経由でテキストを変更する") {
    val british = BritishTextObject()
    val adapter = BritishTextObjectAdapter(british)
    adapter.text = "hello"

    assertEquals(adapter.text, "hello")
    assertEquals(british.string, "hello")
  }

  test("UTF-8 アダプタが日本語のバイト数を正しく返す") {
    val british = BritishTextObject()
    british.string = "こんにちは"
    val adapter = Utf8BritishTextObjectAdapter(british)

    assertEquals(adapter.text, "こんにちは")
    assertEquals(adapter.sizeInBytes, 15) // UTF-8 で日本語は 3 バイト/文字
  }

  test("TextObject trait を満たすことをコンパイル時に保証する") {
    val british = BritishTextObject()
    val obj: TextObject = BritishTextObjectAdapter(british)

    assert(obj.isInstanceOf[TextObject])
  }
