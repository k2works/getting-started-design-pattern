package designpattern.factory

class FactorySuite extends munit.FunSuite:
  test("PondFactory がカエルと藻を生成する") {
    val animal = PondFactory.createAnimal("カエル太郎")
    val plant = PondFactory.createPlant("池の藻")

    assert(animal.isInstanceOf[Frog])
    assertEquals(animal.name, "カエル太郎")
    assertEquals(animal.speak, "ケロケロ")

    assert(plant.isInstanceOf[Algae])
    assertEquals(plant.name, "池の藻")
  }

  test("JungleFactory がトラとスイレンを生成する") {
    val animal = JungleFactory.createAnimal("虎之助")
    val plant = JungleFactory.createPlant("森のスイレン")

    assert(animal.isInstanceOf[Tiger])
    assertEquals(animal.name, "虎之助")
    assertEquals(animal.speak, "ガオー")

    assert(plant.isInstanceOf[WaterLily])
  }

  test("ファクトリを切り替えて環境を構築する") {
    val pond = Environment(PondFactory)
    assert(pond.describe.contains("ケロケロ"))

    val jungle = Environment(JungleFactory)
    assert(jungle.describe.contains("ガオー"))
  }

  test("Animal trait の共通プロパティ") {
    val duck = Duck("アヒル太郎")
    assertEquals(duck.legs, 2)
    assertEquals(duck.speak, "ガーガー")
  }
