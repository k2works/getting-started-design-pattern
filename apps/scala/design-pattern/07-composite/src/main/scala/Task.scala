enum Task:
  case Leaf(name: String, duration: Double)
  case Composite(name: String, children: List[Task])

object Task:
  extension (task: Task)
    def getTimeRequired: Double = task match
      case Task.Leaf(_, duration)      => duration
      case Task.Composite(_, children) => children.map(_.getTimeRequired).sum

    def totalBasicTasks: Int = task match
      case Task.Leaf(_, _)              => 1
      case Task.Composite(_, children) => children.map(_.totalBasicTasks).sum

    def addChild(child: Task): Task = task match
      case Task.Composite(name, children) => Task.Composite(name, children :+ child)
      case Task.Leaf(_, _) =>
        throw IllegalArgumentException("Leaf にはサブタスクを追加できません")
