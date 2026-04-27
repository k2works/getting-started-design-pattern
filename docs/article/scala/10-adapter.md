# 第 10 章: Adapter

## はじめに

既存のライブラリが提供するインターフェースと、自分のシステムが期待するインターフェースが異なることはよくあります。既存のコードを変更せずに、インターフェースの不一致を解消するにはどうすべきでしょうか。

**Adapter パターン**は、既存のクラスのインターフェースを、クライアントが期待するインターフェースに変換するパターンです。

---

## パターンの構造

```plantuml
@startuml
title Adapter パターン

trait TextObject {
  + text : String
  + sizeInBytes : Int
}

class BritishTextObject {
  + string : String
  + lengthInChars : Int
}

class BritishTextObjectAdapter {
  - adaptee : BritishTextObject
  + text : String
  + sizeInBytes : Int
}

TextObject <|.. BritishTextObjectAdapter
BritishTextObjectAdapter --> BritishTextObject
@enduml
```

---

## TDD で作る

### Red: テストを書く

```scala
class AdapterSuite extends munit.FunSuite:
  test("BritishTextObjectAdapter が TextObject インターフェースを提供する") {
    val british = BritishTextObject()
    val adapter = BritishTextObjectAdapter(british)
    assertEquals(adapter.text, "default british text")
    assertEquals(adapter.sizeInBytes, 20)
  }

  test("UTF-8 アダプタが日本語のバイト数を正しく返す") {
    val british = BritishTextObject()
    british.string = "こんにちは"
    val adapter = Utf8BritishTextObjectAdapter(british)
    assertEquals(adapter.sizeInBytes, 15) // UTF-8: 3 bytes/char
  }
```

### Green: 実装する

```scala
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
```

### Refactor: 振り返り

- Scala の trait は Java の interface に相当し、ターゲットインターフェースを明確に定義します。
- アダプタはコンストラクタで adaptee を受け取り、メソッド呼び出しを委譲します。
- `Utf8BritishTextObjectAdapter` は `getBytes("UTF-8").length` で正確なバイト数を返す改良版です。

---

## まとめ

| 観点 | 内容 |
|------|------|
| **意図** | 既存クラスのインターフェースを期待するインターフェースに変換する |
| **適用場面** | サードパーティライブラリのインターフェースが自システムと合わない場合 |
| **Scala のアプローチ** | trait によるターゲット定義 + コンポジションによる委譲 |
| **メリット** | 既存コードを変更せずにインターフェースの不一致を解消 |
| **関連パターン** | Decorator（機能の追加）、Proxy（アクセスの制御） |
