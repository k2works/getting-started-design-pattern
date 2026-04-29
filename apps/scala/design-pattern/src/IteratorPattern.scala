// Iterator パターン
// Iterable trait と given/using による Ordering を活用する

package designpattern.iterator

case class Account(name: String, balance: Double)

object Account:
  // given で暗黙の Ordering を定義
  given Ordering[Account] = Ordering.by(_.balance)

class Portfolio(private val accounts: List[Account]) extends Iterable[Account]:
  override def iterator: Iterator[Account] = accounts.iterator

  def sortedByBalance: List[Account] =
    import Account.given
    accounts.sorted

  def sortedByName: List[Account] =
    accounts.sortBy(_.name)

  def totalBalance: Double =
    accounts.map(_.balance).sum

  def findByName(name: String): Option[Account] =
    accounts.find(_.name == name)

  def filterBy(predicate: Account => Boolean): List[Account] =
    accounts.filter(predicate)
