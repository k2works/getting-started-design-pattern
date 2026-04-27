# 第 11 章: Proxy

## はじめに

銀行口座に対して「認証なしではアクセスできない」「実際のオブジェクト生成を必要になるまで遅延したい」といった要件があります。本体のクラスを変更せずにこれらの制御を追加するにはどうすべきでしょうか。

**Proxy パターン**は、別のオブジェクトへのアクセスを制御する代理オブジェクトを提供するパターンです。

---

## パターンの構造

```plantuml
@startuml
title Proxy パターン

trait BankAccount {
  + deposit(amount: Double) : Unit
  + withdraw(amount: Double) : Boolean
  + balance : Double
}

class RealBankAccount {
  - owner : String
  - _balance : Double
}

class ProtectionProxy {
  - realAccount : BankAccount
  - password : String
  - authenticated : Boolean
  + authenticate(pw: String) : Boolean
}

class VirtualProxy {
  - owner : String
  + realAccount : RealBankAccount
}

BankAccount <|.. RealBankAccount
BankAccount <|.. ProtectionProxy
BankAccount <|.. VirtualProxy
ProtectionProxy --> BankAccount
VirtualProxy --> RealBankAccount : lazy val
@enduml
```

---

## TDD で作る

### Red: テストを書く

```scala
class ProxySuite extends munit.FunSuite:
  test("ProtectionProxy は認証なしでアクセスを拒否する") {
    val real = RealBankAccount("田中")
    val proxy = ProtectionProxy(real, "secret123")
    intercept[SecurityException] { proxy.balance }
  }

  test("VirtualProxy は lazy val で遅延初期化する") {
    val proxy = VirtualProxy("佐藤")
    proxy.deposit(500)
    assertEqualsDouble(proxy.balance, 500.0, 0.01)
  }
```

### Green: 実装する

```scala
class ProtectionProxy(realAccount: BankAccount, password: String) extends BankAccount:
  private var authenticated: Boolean = false

  def authenticate(inputPassword: String): Boolean =
    authenticated = inputPassword == password
    authenticated

  override def deposit(amount: Double): Unit =
    requireAuth()
    realAccount.deposit(amount)

  // ...

class VirtualProxy(owner: String) extends BankAccount:
  lazy val realAccount: RealBankAccount = RealBankAccount(owner)
  override def deposit(amount: Double): Unit = realAccount.deposit(amount)
  // ...
```

### Refactor: 振り返り

- **ProtectionProxy**: 認証状態を内部で管理し、未認証時は `SecurityException` をスローします。
- **VirtualProxy**: Scala の `lazy val` により、初回アクセス時にのみ `RealBankAccount` を生成します。
- どちらのプロキシも `BankAccount` trait を実装するため、クライアントコードからは透過的に利用できます。

---

## まとめ

| 観点 | 内容 |
|------|------|
| **意図** | オブジェクトへのアクセスを制御する代理を提供する |
| **適用場面** | アクセス制御、遅延初期化、リモートプロキシ |
| **Scala のアプローチ** | trait + lazy val + 例外による認証制御 |
| **メリット** | 本体を変更せずにアクセス制御・遅延初期化を追加 |
| **関連パターン** | Adapter（インターフェース変換）、Decorator（機能追加） |
