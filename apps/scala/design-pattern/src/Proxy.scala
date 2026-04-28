// Proxy パターン
// lazy val によるバーチャルプロキシとアクセス制御プロキシ

package designpattern.proxy

// サブジェクトインターフェース
trait BankAccount:
  def deposit(amount: Double): Unit
  def withdraw(amount: Double): Boolean
  def balance: Double

// リアルサブジェクト
class RealBankAccount(owner: String, private var _balance: Double = 0.0) extends BankAccount:
  override def balance: Double = _balance

  override def deposit(amount: Double): Unit =
    require(amount > 0, "預入額は正の数でなければなりません")
    _balance += amount

  override def withdraw(amount: Double): Boolean =
    require(amount > 0, "引出額は正の数でなければなりません")
    if _balance >= amount then
      _balance -= amount
      true
    else false

// 保護プロキシ（アクセス制御）
class ProtectionProxy(realAccount: BankAccount, password: String) extends BankAccount:
  private var authenticated: Boolean = false

  def authenticate(inputPassword: String): Boolean =
    authenticated = inputPassword == password
    authenticated

  override def deposit(amount: Double): Unit =
    requireAuth()
    realAccount.deposit(amount)

  override def withdraw(amount: Double): Boolean =
    requireAuth()
    realAccount.withdraw(amount)

  override def balance: Double =
    requireAuth()
    realAccount.balance

  private def requireAuth(): Unit =
    if !authenticated then throw SecurityException("認証が必要です")

// バーチャルプロキシ（遅延初期化）
class VirtualProxy(owner: String) extends BankAccount:
  lazy val realAccount: RealBankAccount = RealBankAccount(owner)

  override def deposit(amount: Double): Unit     = realAccount.deposit(amount)
  override def withdraw(amount: Double): Boolean = realAccount.withdraw(amount)
  override def balance: Double                   = realAccount.balance

  def isInitialized: Boolean =
    // lazy val が初期化済みかどうかを反映
    try
      realAccount
      true
    catch case _: Exception => false
