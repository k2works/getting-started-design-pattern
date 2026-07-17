import munit.FunSuite

class CommandSuite extends FunSuite:
  test("InsertCommand でテキストを挿入する") {
    val document = SliderDocument()
    val command = InsertCommand(document, 0, "Hello")

    command.execute()

    assertEquals(document.content, "Hello", document.content)
  }

  test("InsertCommand の undo で挿入を取り消す") {
    val document = SliderDocument()
    val command = InsertCommand(document, 0, "Hello")
    command.execute()

    command.undo()

    assertEquals(document.content, "", document.content)
  }

  test("DeleteCommand の undo で削除を取り消す") {
    val document = SliderDocument()
    document.insertString(0, "Hello")
    val command = DeleteCommand(document, 1, 3)

    command.execute()
    assertEquals(document.content, "Ho", document.content)

    command.undo()
    assertEquals(document.content, "Hello", document.content)
  }

  test("CommandHistory で最後のコマンドを取り消す") {
    val document = SliderDocument()
    val history = CommandHistory()

    history.executeCommand(InsertCommand(document, 0, "Hello"))
    history.executeCommand(InsertCommand(document, 5, " World"))
    val undone = history.undoLast()

    assertEquals(document.content, "Hello", document.content)
    assert(undone.isDefined, undone)
  }

  test("CompositeCommand で複数のコマンドを一括実行する") {
    val document = SliderDocument()
    val composite = CompositeCommand(
      List(
        InsertCommand(document, 0, "A"),
        InsertCommand(document, 1, "B"),
        InsertCommand(document, 2, "C")
      )
    )

    composite.execute()

    assertEquals(document.content, "ABC", document.content)
  }

  test("CompositeCommand の undo は逆順で取り消す") {
    val document = SliderDocument()
    val composite = CompositeCommand(
      List(
        InsertCommand(document, 0, "A"),
        InsertCommand(document, 1, "B")
      )
    )
    composite.execute()

    composite.undo()

    assertEquals(document.content, "", document.content)
  }
