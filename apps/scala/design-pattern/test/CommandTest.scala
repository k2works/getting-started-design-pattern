package designpattern.command

class CommandSuite extends munit.FunSuite:
  test("InsertCommand でテキストを挿入する") {
    val doc = SliderDocument()
    val cmd = InsertCommand(doc, 0, "Hello")
    cmd.execute()

    assertEquals(doc.content, "Hello")
  }

  test("InsertCommand の undo で挿入を取り消す") {
    val doc = SliderDocument()
    val cmd = InsertCommand(doc, 0, "Hello")
    cmd.execute()
    cmd.undo()

    assertEquals(doc.content, "")
  }

  test("DeleteCommand でテキストを削除する") {
    val doc = SliderDocument()
    InsertCommand(doc, 0, "H").execute()
    InsertCommand(doc, 1, "e").execute()
    InsertCommand(doc, 2, "l").execute()
    InsertCommand(doc, 3, "l").execute()
    InsertCommand(doc, 4, "o").execute()

    val cmd = DeleteCommand(doc, 0, "Hel")
    cmd.execute()

    assertEquals(doc.content, "lo")
  }

  test("CompositeCommand で複数のコマンドを一括実行する") {
    val doc = SliderDocument()
    val commands = List(
      InsertCommand(doc, 0, "A"),
      InsertCommand(doc, 1, "B"),
      InsertCommand(doc, 2, "C")
    )
    val composite = CompositeCommand(commands)
    composite.execute()

    assertEquals(doc.content, "ABC")
  }

  test("CommandHistory で undo を管理する") {
    val doc = SliderDocument()
    val history = CommandHistory()

    history.executeCommand(InsertCommand(doc, 0, "A"))
    history.executeCommand(InsertCommand(doc, 1, "B"))

    assertEquals(doc.content, "AB")
    assertEquals(history.size, 2)

    history.undoLast()
    assertEquals(doc.content, "A")
    assertEquals(history.size, 1)
  }
