// Command パターン
// trait とケースクラスで操作のオブジェクト化・Undo を実現する

package designpattern.command

import scala.collection.mutable.ListBuffer

trait Command:
  def execute(): Unit
  def undo(): Unit
  def description: String

class SliderDocument:
  private val _content: ListBuffer[String] = ListBuffer.empty

  def content: String = _content.mkString

  def insertString(position: Int, text: String): Unit =
    _content.insert(position, text)

  def deleteString(position: Int, length: Int): Unit =
    for _ <- 0 until length do
      if position < _content.length then _content.remove(position)

class InsertCommand(document: SliderDocument, position: Int, text: String) extends Command:
  override def execute(): Unit =
    document.insertString(position, text)

  override def undo(): Unit =
    document.deleteString(position, text.length)

  override val description: String = s"Insert '$text' at position $position"

class DeleteCommand(document: SliderDocument, position: Int, text: String) extends Command:
  override def execute(): Unit =
    document.deleteString(position, text.length)

  override def undo(): Unit =
    document.insertString(position, text)

  override val description: String = s"Delete '$text' at position $position"

class CompositeCommand(commands: List[Command]) extends Command:
  override def execute(): Unit = commands.foreach(_.execute())
  override def undo(): Unit = commands.reverse.foreach(_.undo())
  override val description: String = commands.map(_.description).mkString("; ")

class CommandHistory:
  private val history: ListBuffer[Command] = ListBuffer.empty

  def executeCommand(command: Command): Unit =
    command.execute()
    history += command

  def undoLast(): Option[Command] =
    if history.nonEmpty then
      val last = history.remove(history.length - 1)
      last.undo()
      Some(last)
    else
      None

  def size: Int = history.size
