# 第 5 章：Composite — 判別共用体で木構造を表現する

## はじめに

Composite パターンは、個々のオブジェクトとオブジェクトの集合を同一視して扱うパターンです。F# では、再帰的な判別共用体（Discriminated Union）で自然に表現できます。

## パターンの構造

```plantuml
@startuml
title Composite（F# 版）

class "Composite" as C <<module>> {
  + getName(task)
  + getTotalDuration(task)
  + getLeafCount(task)
  + toStringWithIndent(indent, task)
  + addChild(child, task)
}

class "Task" as T <<discriminated union>> {
  + LeafTask(name, duration)
  + CompositeTask(name, children)
}

T --> T : children (再帰)
C --> T : operates on
@enduml
```

## TDD で作る

### Red: 失敗するテストを書く

```fsharp
[<Fact>]
let ``CompositeTask の合計所要時間を計算できる`` () =
    let project =
        CompositeTask("プロジェクト", [
            LeafTask("設計", 2.0)
            LeafTask("実装", 5.0)
            LeafTask("テスト", 3.0)
        ])
    Assert.Equal(10.0, getTotalDuration project)
```

### Green: テストを通す最小のコードを書く

```fsharp
type Task =
    | LeafTask of name: string * duration: float
    | CompositeTask of name: string * children: Task list

let rec getTotalDuration = function
    | LeafTask(_, duration) -> duration
    | CompositeTask(_, children) ->
        children |> List.sumBy getTotalDuration

let getName = function
    | LeafTask(name, _) -> name
    | CompositeTask(name, _) -> name

let rec getLeafCount = function
    | LeafTask _ -> 1
    | CompositeTask(_, children) -> children |> List.sumBy getLeafCount

let addChild child = function
    | LeafTask _ as leaf -> leaf
    | CompositeTask(name, children) ->
        CompositeTask(name, children @ [ child ])
```

判別共用体 1 つに操作関数を重ねる形なので、クラス階層や可変の子リストを持たずに Composite を記述できます。

### 動的なツリー構築: addChild

`addChild` 関数を使うと、既存のタスクツリーに子タスクを動的に追加できます。

```fsharp
let addChild (child: Task) = function
    | CompositeTask(name, children) -> CompositeTask(name, children @ [ child ])
    | leaf -> CompositeTask(getName leaf, [ leaf; child ])
```

`CompositeTask` に対しては子リストの末尾に追加します。`LeafTask` に対して呼んだ場合は、元の Leaf と新しい子を含む `CompositeTask` に昇格させます。

```fsharp
[<Fact>]
let ``子タスクを追加できる`` () =
    let task = CompositeTask("親", [ LeafTask("子1", 1.0) ])
    let updated = addChild (LeafTask("子2", 2.0)) task
    Assert.Equal(2, getLeafCount updated)
```

### Refactor

パターンマッチングにより、各ケースの処理が明確に分離されています。`function` キーワードで引数を直接マッチングする F# のイディオムを使っています。

## OOP 版（C#）との比較

### C# 版

```csharp
abstract class TaskComponent {
    public abstract string Name { get; }
    public abstract double GetTotalDuration();
}
class LeafTask : TaskComponent { ... }
class CompositeTask : TaskComponent {
    private List<TaskComponent> children = new();
    public override double GetTotalDuration() =>
        children.Sum(c => c.GetTotalDuration());
}
```

### F# 版の優位性

- 判別共用体 1 つでクラス階層全体を表現
- パターンマッチングで網羅性チェック（新しいケース追加時にコンパイラが警告）
- イミュータブルなデータ構造

## まとめ

- Composite は判別共用体の最も自然な用途の一つ
- 再帰的な判別共用体で木構造を直接表現できる
- パターンマッチングにより、すべてのケースの網羅性がコンパイル時に保証される
