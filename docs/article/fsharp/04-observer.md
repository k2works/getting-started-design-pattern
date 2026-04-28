# 第 4 章：Observer — コールバック関数とイベント

## はじめに

Observer パターンは、オブジェクトの状態変化を他のオブジェクトに通知するパターンです。F# ではコールバック関数のリストや、組み込みの Event 型で実現できます。

## パターンの構造

```plantuml
@startuml
title Observer（F# 版）

class "Subject~T~" as S {
  - observers: Observer~T~ list
  + AddObserver(observer)
  + RemoveObserver(observer)
  + NotifyObservers(value)
}

class "Observer~T~" as O <<module>> {
  (T -> unit)
}

class "EmployeeSubject" as ES {
  + UpdateSalary(employee, newSalary)
}

class "Employee" as E {
  + Name: string
  + Salary: float
}

S --> O : notifies
ES --> S : uses
ES --> E : monitors
@enduml
```

## TDD で作る

### Red: 失敗するテストを書く

```fsharp
[<Fact>]
let ``オブザーバーに通知が届く`` () =
    let subject = Subject<string>()
    let mutable received = ""
    subject.AddObserver(fun msg -> received <- msg)
    subject.NotifyObservers("テスト通知")
    Assert.Equal("テスト通知", received)
```

### Green: テストを通す最小のコードを書く

```fsharp
type Observer<'T> = 'T -> unit

type Subject<'T>() =
    let mutable observers : Observer<'T> list = []
    member _.AddObserver(observer) = observers <- observer :: observers
    member _.NotifyObservers(value) =
        observers |> List.iter (fun observer -> observer value)
```

### Refactor

通知の仕組みをジェネリックにし、従業員の給与変更監視に特化した `EmployeeSubject` を追加しました。

## OOP 版（C#）との比較

### C# 版

```csharp
interface IObserver { void Update(string message); }
class Subject {
    private List<IObserver> observers = new();
    public void Attach(IObserver o) => observers.Add(o);
    public void Notify(string msg) => observers.ForEach(o => o.Update(msg));
}
```

### F# 版の優位性

- オブザーバーはただの関数（`'T -> unit`）
- インターフェースの定義が不要
- ラムダ式でインラインにオブザーバーを登録できる

## まとめ

- Observer はコールバック関数のリストで実装できる
- F# のジェネリクスにより、型安全な通知が実現される
- 関数型の Observer は OOP 版よりシンプルだが、ミュータブルな状態を持つ点は同じ
