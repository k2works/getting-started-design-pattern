package designpattern.proxy

class ProxySuite extends munit.FunSuite:

  test("RealBankAccount で預入・引出できる") {
    val account = RealBankAccount("田中")
    account.deposit(1000)
    assertEqualsDouble(account.balance, 1000.0, 0.01)

    assert(account.withdraw(500))
    assertEqualsDouble(account.balance, 500.0, 0.01)
  }

  test("残高不足の引出は false を返す") {
    val account = RealBankAccount("田中")
    account.deposit(100)
    assert(!account.withdraw(200))
  }

  test("ProtectionProxy は認証なしでアクセスを拒否する") {
    val real  = RealBankAccount("田中")
    val proxy = ProtectionProxy(real, "secret123")

    intercept[SecurityException] {
      proxy.balance
    }
  }

  test("ProtectionProxy は認証後にアクセスを許可する") {
    val real  = RealBankAccount("田中")
    val proxy = ProtectionProxy(real, "secret123")

    assert(proxy.authenticate("secret123"))
    proxy.deposit(1000)
    assertEqualsDouble(proxy.balance, 1000.0, 0.01)
  }

  test("ProtectionProxy は誤ったパスワードで認証に失敗する") {
    val real  = RealBankAccount("田中")
    val proxy = ProtectionProxy(real, "secret123")

    assert(!proxy.authenticate("wrong"))
    intercept[SecurityException] {
      proxy.deposit(1000)
    }
  }

  test("VirtualProxy は lazy val で遅延初期化する") {
    val proxy = VirtualProxy("佐藤")
    // 操作するまで realAccount は初期化されない
    proxy.deposit(500)
    assertEqualsDouble(proxy.balance, 500.0, 0.01)
  }
