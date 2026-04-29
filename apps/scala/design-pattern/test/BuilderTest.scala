package designpattern.builder

class BuilderSuite extends munit.FunSuite:

  test("Builder でコンピュータを構築する") {
    val computer = ComputerBuilder()
      .setCpu("Intel i7")
      .setMemory(16)
      .setStorage(512)
      .build()

    assertEquals(computer.cpu, "Intel i7")
    assertEquals(computer.memory, 16)
    assertEquals(computer.storage, 512)
    assertEquals(computer.gpu, None)
  }

  test("全オプションを指定して構築する") {
    val computer = ComputerBuilder()
      .setCpu("AMD Ryzen 9")
      .setMemory(64)
      .setStorage(2000)
      .setGpu("RTX 4080")
      .setDisplay("32インチ")
      .build()

    assertEquals(computer.gpu, Some("RTX 4080"))
    assertEquals(computer.display, Some("32インチ"))
  }

  test("ゲーミング PC の定型構成") {
    val gaming = ComputerDirector.gamingComputer

    assertEquals(gaming.cpu, "Intel i9")
    assertEquals(gaming.memory, 32)
    assertEquals(gaming.gpu, Some("RTX 4090"))
  }

  test("オフィス PC の定型構成") {
    val office = ComputerDirector.officeComputer

    assertEquals(office.cpu, "Intel i5")
    assertEquals(office.gpu, None)
  }

  test("describe でスペックを表示する") {
    val laptop = ComputerDirector.laptopComputer
    val desc   = laptop.describe

    assert(desc.contains("CPU: Apple M3"))
    assert(desc.contains("ディスプレイ: 14インチ Retina"))
  }

  test("case class の copy でイミュータブルに変更する") {
    val base     = ComputerDirector.officeComputer
    val upgraded = base.copy(memory = 32, gpu = Some("RTX 3060"))

    assertEquals(base.memory, 16)
    assertEquals(upgraded.memory, 32)
  }
