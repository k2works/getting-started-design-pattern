# 第 7 章：Command — 関数でコマンドを表現する

## はじめに

Command パターンは、操作をオブジェクトとしてカプセル化し、実行・取り消し・やり直しを可能にします。F# では、`Execute` と `Undo` の関数フィールドを持つレコード型で表現します。

## パターンの構造

```plantuml
@startuml
title Command（F# 版）

class "Command~TState~" as C {
  + Description: string
  + Execute: TState -> TState
  + Undo: TState -> TState
}

class "CommandHistory~TState~" as CH {
  + State: TState
  + UndoStack: Command list
  + RedoStack: Command list
}

class <<module>> "CommandModule" as CM {
  + create(initialState)
  + execute(command, history)
  + undo(history)
  + redo(history)
}

CM --> C : creates
CM --> CH : manages
CH --> C : contains
@enduml
```

## TDD で作る

### Red: 失敗するテストを書く

```fsharp
[<Fact>]
let ``コマンドを取り消せる`` () =
    let history =
        create ""
        |> execute (appendText "Hello")
        |> execute (appendText " World")
        |> undo
    Assert.Equal("Hello", history.State)
```

### Green: テストを通す最小のコードを書く

```fsharp
let undo (history: CommandHistory<'TState>) =
    match history.UndoStack with
    | [] -> history
    | lastCommand :: rest ->
        { State = lastCommand.Undo history.State
          UndoStack = rest
          RedoStack = lastCommand :: history.RedoStack }
```

### Refactor

パイプライン演算子（`|>`）により、コマンドの連鎖が読みやすくなっています。イミュータブルな `CommandHistory` により、各状態のスナップショットが自然に保持されます。

## OOP 版（C#）との比較

### C# 版

```csharp
interface ICommand {
    void Execute();
    void Undo();
}
class AppendTextCommand : ICommand {
    private string text;
    private StringBuilder buffer;
    public void Execute() => buffer.Append(text);
    public void Undo() => buffer.Remove(buffer.Length - text.Length, text.Length);
}
```

### F# 版の優位性

- コマンドはレコード型（インターフェース不要）
- 状態がイミュータブル（Execute は新しい状態を返す）
- パイプラインでコマンドを連鎖できる

## まとめ

- Command は関数フィールドを持つレコード型で表現する
- イミュータブルな状態管理により、取り消し・やり直しが安全に実装できる
- パイプライン演算子でコマンドの実行が直感的に記述できる
