# 第 9 章: Command

## はじめに

テキストエディタで「挿入」「削除」の操作を行い、「元に戻す（Undo）」機能を実現したいとします。操作をオブジェクトとしてカプセル化すれば、履歴管理や Undo が可能になります。

**Command パターン**は、操作をオブジェクトとしてカプセル化し、操作の実行・取り消し・履歴管理を可能にするパターンです。

---

## パターンの構造

```plantuml
@startuml
title Command パターン

interface Command <<trait>> {
  + execute() : Unit
  + undo() : Unit
  + description : String
}

class InsertCommand {
  - document : SliderDocument
  - position : Int
  - text : String
}

class DeleteCommand {
  - document : SliderDocument
  - position : Int
  - text : String
}

class CompositeCommand {
  - commands : List[Command]
}

class CommandHistory {
  - history : ListBuffer[Command]
  + executeCommand(cmd: Command) : Unit
  + undoLast() : Option[Command]
}

Command <|.. InsertCommand
Command <|.. DeleteCommand
Command <|.. CompositeCommand
CommandHistory --> Command
@enduml
```

---

## TDD で作る

### Red: テストを書く

```scala
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
```

### Green: 実装する

```scala
trait Command:
  def execute(): Unit
  def undo(): Unit
  def description: String

class InsertCommand(document: SliderDocument, position: Int, text: String) extends Command:
  override def execute(): Unit = document.insertString(position, text)
  override def undo(): Unit = document.deleteString(position, text.length)
  override val description: String = s"Insert '$text' at position $position"
```

### Refactor: 振り返り

- `Command` trait は `execute` / `undo` / `description` の 3 つのメソッドを定義します。
- `CompositeCommand` は複数のコマンドを一括実行・一括 Undo します（Composite パターンの応用）。
- `CommandHistory` の `undoLast()` は `Option[Command]` を返し、履歴が空の場合を型安全に扱います。

---

## まとめ

| 観点 | 内容 |
|------|------|
| **意図** | 操作をオブジェクトとしてカプセル化し、実行・取り消し・履歴管理を可能にする |
| **適用場面** | Undo/Redo、マクロ記録、トランザクション管理 |
| **Scala のアプローチ** | trait Command + ケースクラス + Option で型安全な Undo |
| **メリット** | 操作の記録・再実行・取り消しが統一的に管理できる |
| **関連パターン** | Composite（複合コマンド）、Strategy（操作の差し替え） |
