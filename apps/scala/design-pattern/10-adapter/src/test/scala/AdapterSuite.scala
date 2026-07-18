import munit.FunSuite

class AdapterSuite extends FunSuite:
  test("BritishTextObjectAdapter が TextObject インターフェースを提供する") {
    val british = BritishTextObject()
    val adapter = BritishTextObjectAdapter(british)

    assertEquals(adapter.text, "default british text", adapter.text)
    assertEquals(adapter.sizeInBytes, 20, adapter.sizeInBytes)
  }

  test("UTF-8 アダプタが日本語のバイト数を正しく返す") {
    val british = BritishTextObject()
    british.string = "こんにちは"
    val adapter = Utf8BritishTextObjectAdapter(british)

    assertEquals(adapter.sizeInBytes, 15, adapter.sizeInBytes)
  }
