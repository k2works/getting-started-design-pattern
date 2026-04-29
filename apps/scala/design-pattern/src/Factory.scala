// Factory パターン
// enum と companion object のファクトリメソッドでオブジェクト生成を抽象化する

package designpattern.factory

// 動物の階層
enum HabitatType:
  case Land, Water, Amphibian

trait Animal:
  def name: String
  def legs: Int
  def habitatType: HabitatType
  def speak: String

case class Tiger(name: String) extends Animal:
  val legs: Int                = 4
  val habitatType: HabitatType = HabitatType.Land
  val speak: String            = "ガオー"

case class Frog(name: String) extends Animal:
  val legs: Int                = 4
  val habitatType: HabitatType = HabitatType.Amphibian
  val speak: String            = "ケロケロ"

case class Duck(name: String) extends Animal:
  val legs: Int                = 2
  val habitatType: HabitatType = HabitatType.Amphibian
  val speak: String            = "ガーガー"

// 植物の階層
trait Plant:
  def name: String
  def edible: Boolean

case class Algae(name: String) extends Plant:
  val edible: Boolean = false

case class WaterLily(name: String) extends Plant:
  val edible: Boolean = false

// ファクトリ
trait OrganismFactory:
  def createAnimal(name: String): Animal
  def createPlant(name: String): Plant

object PondFactory extends OrganismFactory:
  def createAnimal(name: String): Animal = Frog(name)
  def createPlant(name: String): Plant   = Algae(name)

object JungleFactory extends OrganismFactory:
  def createAnimal(name: String): Animal = Tiger(name)
  def createPlant(name: String): Plant   = WaterLily(name)

// 環境クラス
class Environment(factory: OrganismFactory):
  val animal: Animal = factory.createAnimal("生き物1")
  val plant: Plant   = factory.createPlant("植物1")

  def describe: String =
    s"${animal.name}が${animal.speak}と鳴き、${plant.name}が生えている"
