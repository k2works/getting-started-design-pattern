// Composite パターン
// Scala 3 の enum（ADT）と拡張メソッドで木構造を表現する

package designpattern.composite

enum Task:
  case Leaf(name: String, duration: Double)
  case Composite(name: String, children: List[Task])

object Task:
  // 拡張メソッド
  extension (task: Task)
    def getTimeRequired: Double = task match
      case Task.Leaf(_, duration)      => duration
      case Task.Composite(_, children) => children.map(_.getTimeRequired).sum

    def getName: String = task match
      case Task.Leaf(name, _)      => name
      case Task.Composite(name, _) => name

    def totalBasicTasks: Int = task match
      case Task.Leaf(_, _)             => 1
      case Task.Composite(_, children) => children.map(_.totalBasicTasks).sum

    def addChild(child: Task): Task = task match
      case Task.Composite(name, children) => Task.Composite(name, children :+ child)
      case leaf: Task.Leaf => throw IllegalArgumentException("Leaf にはサブタスクを追加できません")
