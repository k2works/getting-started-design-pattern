# 第 6 章: Observer

## はじめに

従業員の給料が変更されたとき、経理部門や人事部門に自動的に通知したいとします。Observer パターンは、あるオブジェクトの状態変化を、依存するオブジェクトに自動的に通知するパターンです。

Go ではコールバック関数のスライスを使って、シンプルかつ効果的に実現できます。

---

## パターンの構造

```plantuml
@startuml
title Observer パターン（Go 版）

class <<type>> "Observer" as Obs {
  func(e *Employee)
}

class <<struct>> Employee {
  + Name : string
  + Title : string
  + Salary : float64
  - observers : []Observer
  + AddObserver(o Observer)
  + RemoveObserver()
  + SetSalary(newSalary float64)
  - notifyObservers()
}

Employee *-- Obs : observers
@enduml
```

---

## TDD で作る

### Red: テストを書く

```go
func TestSetSalaryNotifiesObserver(t *testing.T) {
    emp := NewEmployee("田中", "エンジニア", 500000)
    var notified bool
    emp.AddObserver(func(e *Employee) { notified = true })
    emp.SetSalary(600000)

    if !notified {
        t.Error("Observer が通知されなかった")
    }
}
```

### Green: 実装する

```go
type Observer func(e *Employee)

type Employee struct {
    Name      string
    Salary    float64
    observers []Observer
}

func (e *Employee) AddObserver(o Observer)    { e.observers = append(e.observers, o) }
func (e *Employee) SetSalary(newSalary float64) {
    e.Salary = newSalary
    for _, o := range e.observers { o(e) }
}
```

### Refactor: 振り返り

- コールバック関数をスライスに格納するだけで Observer パターンが実現できます
- Go のチャネルを使った実装も可能ですが、同期的な通知にはコールバックが適しています

---

## Ruby / Java / Python / JavaScript との比較

| 観点 | Ruby | Java | Python | JavaScript | Go |
|------|------|------|--------|------------|-----|
| Observer の型 | モジュール | interface | ABC | EventEmitter | 関数型 |
| 登録 | `add_observer` | `addObserver` | `attach` | `on` | `AddObserver` |
| 通知 | `notify_observers` | `notifyObservers` | `notify` | `emit` | `notifyObservers` |
| 非同期通知 | Thread | CompletableFuture | asyncio | Promise | goroutine |

---

## まとめ

| 観点 | 内容 |
|------|------|
| **意図** | オブジェクトの状態変化を依存オブジェクトに自動通知する |
| **Go での実現** | コールバック関数のスライス |
| **メリット** | interface 定義不要、関数がそのまま Observer になる |
| **注意点** | 循環通知に注意、goroutine で非同期化も可能 |
| **関連パターン** | Strategy（関数の差し替え）、Mediator（調停者） |
