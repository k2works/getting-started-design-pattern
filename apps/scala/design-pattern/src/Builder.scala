// Builder パターン
// case class の copy メソッドとフルーエント API でオブジェクトを段階的に構築する

package designpattern.builder

case class Computer(
  cpu: String = "unknown",
  memory: Int = 0,
  storage: Int = 0,
  gpu: Option[String] = None,
  display: Option[String] = None
):
  def describe: String =
    val parts = List(
      s"CPU: $cpu",
      s"メモリ: ${memory}GB",
      s"ストレージ: ${storage}GB"
    ) ++ gpu.map(g => s"GPU: $g").toList ++
      display.map(d => s"ディスプレイ: $d").toList
    parts.mkString(", ")

class ComputerBuilder:
  private var computer: Computer = Computer()

  def setCpu(cpu: String): ComputerBuilder =
    computer = computer.copy(cpu = cpu)
    this

  def setMemory(memory: Int): ComputerBuilder =
    computer = computer.copy(memory = memory)
    this

  def setStorage(storage: Int): ComputerBuilder =
    computer = computer.copy(storage = storage)
    this

  def setGpu(gpu: String): ComputerBuilder =
    computer = computer.copy(gpu = Some(gpu))
    this

  def setDisplay(display: String): ComputerBuilder =
    computer = computer.copy(display = Some(display))
    this

  def build(): Computer = computer

// ディレクタ: 定型構成を提供する
object ComputerDirector:
  def gamingComputer: Computer =
    ComputerBuilder()
      .setCpu("Intel i9")
      .setMemory(32)
      .setStorage(1000)
      .setGpu("RTX 4090")
      .setDisplay("27インチ 4K")
      .build()

  def officeComputer: Computer =
    ComputerBuilder()
      .setCpu("Intel i5")
      .setMemory(16)
      .setStorage(512)
      .build()

  def laptopComputer: Computer =
    ComputerBuilder()
      .setCpu("Apple M3")
      .setMemory(16)
      .setStorage(256)
      .setDisplay("14インチ Retina")
      .build()
