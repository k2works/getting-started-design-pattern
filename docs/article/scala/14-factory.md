# 第 14 章: Factory

## はじめに

「池の生態系」と「ジャングルの生態系」を構築したいとします。それぞれの環境で生成される動物と植物は異なります。生成するオブジェクトの種類を実行時に切り替えるにはどうすべきでしょうか。

**Factory パターン**は、オブジェクトの生成を専門のファクトリに委譲し、生成するオブジェクトの種類を実行時に決定するパターンです。

---

## パターンの構造

```plantuml
@startuml
title Factory パターン

interface OrganismFactory <<trait>> {
  + createAnimal(name: String) : Animal
  + createPlant(name: String) : Plant
}

object PondFactory
object JungleFactory

interface Animal <<trait>> {
  + name : String
  + speak : String
}

interface Plant <<trait>> {
  + name : String
  + edible : Boolean
}

class Frog
class Tiger
class Algae
class WaterLily

OrganismFactory <|.. PondFactory
OrganismFactory <|.. JungleFactory
Animal <|.. Frog
Animal <|.. Tiger
Plant <|.. Algae
Plant <|.. WaterLily
PondFactory --> Frog : creates
PondFactory --> Algae : creates
JungleFactory --> Tiger : creates
JungleFactory --> WaterLily : creates
@enduml
```

---

## TDD で作る

### Red: テストを書く

```scala
class FactorySuite extends munit.FunSuite:
  test("PondFactory がカエルと藻を生成する") {
    val animal = PondFactory.createAnimal("カエル太郎")
    assert(animal.isInstanceOf[Frog])
    assertEquals(animal.speak, "ケロケロ")
  }

  test("ファクトリを切り替えて環境を構築する") {
    val pond = Environment(PondFactory)
    assert(pond.describe.contains("ケロケロ"))
    val jungle = Environment(JungleFactory)
    assert(jungle.describe.contains("ガオー"))
  }
```

### Green: 実装する

```scala
trait OrganismFactory:
  def createAnimal(name: String): Animal
  def createPlant(name: String): Plant

object PondFactory extends OrganismFactory:
  def createAnimal(name: String): Animal = Frog(name)
  def createPlant(name: String): Plant = Algae(name)

object JungleFactory extends OrganismFactory:
  def createAnimal(name: String): Animal = Tiger(name)
  def createPlant(name: String): Plant = WaterLily(name)

case class Environment(factory: OrganismFactory):
  val animal: Animal = factory.createAnimal("代表動物")
  val plant: Plant = factory.createPlant("代表植物")

  def describe: String =
    s"${animal.name} は ${animal.speak} と鳴き、${plant.name} は edible = ${plant.edible}"
```

Factory を差し替えて環境全体の構成結果まで見えるようにしておくと、抽象化の効果が伝わります。

### Refactor: 振り返り

- **`object` でファクトリを定義**: Scala のシングルトンオブジェクトがファクトリの自然な表現です。
- **ケースクラス**: `Tiger(name)` のような簡潔な生成構文は、ケースクラスの `apply` メソッドによるものです。
- **trait による抽象化**: `OrganismFactory` trait により、ファクトリの差し替えが型安全に行えます。

---

## まとめ

| 観点 | 内容 |
|------|------|
| **意図** | オブジェクトの生成をファクトリに委譲し、生成する種類を実行時に決定する |
| **適用場面** | 関連するオブジェクト群を一貫して生成したい場合 |
| **Scala のアプローチ** | trait + object + ケースクラス |
| **メリット** | 生成ロジックの一元管理、ファクトリの差し替えが容易 |
| **関連パターン** | Builder（段階的構築）、Singleton（ファクトリ自体が唯一） |
