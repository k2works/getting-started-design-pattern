trait Command:
  def execute(): Unit
  def undo(): Unit
  def description: String

class SliderDocument:
  private val buffer = new StringBuilder

  def content: String = buffer.toString
  def insertString(position: Int, text: String): Unit = buffer.insert(position, text)
  def deleteString(position: Int, length: Int): Unit = buffer.delete(position, position + length)
  def substring(start: Int, end: Int): String = buffer.substring(start, end)

class InsertCommand(document: SliderDocument, position: Int, text: String) extends Command:
  override def execute(): Unit = document.insertString(position, text)
  override def undo(): Unit = document.deleteString(position, text.length)
  override val description: String = s"Insert '$text' at position $position"

class DeleteCommand(document: SliderDocument, position: Int, length: Int) extends Command:
  private var deletedText: String = ""

  override def execute(): Unit =
    deletedText = document.substring(position, position + length)
    document.deleteString(position, length)

  override def undo(): Unit =
    document.insertString(position, deletedText)

  override val description: String = s"Delete $length chars at position $position"

class CommandHistory:
  private val history = scala.collection.mutable.ListBuffer.empty[Command]

  def executeCommand(command: Command): Unit =
    command.execute()
    history += command

  def undoLast(): Option[Command] =
    history.lastOption.map { command =>
      command.undo()
      history.remove(history.length - 1)
      command
    }

class CompositeCommand(commands: List[Command]) extends Command:
  override def execute(): Unit = commands.foreach(_.execute())
  override def undo(): Unit = commands.reverse.foreach(_.undo())
  override val description: String = commands.map(_.description).mkString("; ")
