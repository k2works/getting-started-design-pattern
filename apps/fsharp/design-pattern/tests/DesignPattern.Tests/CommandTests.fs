module DesignPattern.Tests.CommandTests

open Xunit
open DesignPattern.Command.Command

[<Fact>]
let ``コマンドを実行してテキストを追加できる`` () =
    let history = create ""
    let history = execute (appendText "Hello") history
    Assert.Equal("Hello", history.State)

[<Fact>]
let ``複数のコマンドを順番に実行できる`` () =
    let history =
        create "" |> execute (appendText "Hello") |> execute (appendText " World")

    Assert.Equal("Hello World", history.State)

[<Fact>]
let ``コマンドを取り消せる`` () =
    let history =
        create ""
        |> execute (appendText "Hello")
        |> execute (appendText " World")
        |> undo

    Assert.Equal("Hello", history.State)

[<Fact>]
let ``取り消したコマンドをやり直せる`` () =
    let history =
        create ""
        |> execute (appendText "Hello")
        |> execute (appendText " World")
        |> undo
        |> redo

    Assert.Equal("Hello World", history.State)

[<Fact>]
let ``大文字変換コマンドを実行して取り消せる`` () =
    let history = create "" |> execute (appendText "hello")
    let history = execute (toUpperCase history.State) history
    Assert.Equal("HELLO", history.State)
    let history = undo history
    Assert.Equal("hello", history.State)

[<Fact>]
let ``空の履歴で undo しても安全`` () =
    let history = create "test"
    let history = undo history
    Assert.Equal("test", history.State)

[<Fact>]
let ``空の redo スタックで redo しても安全`` () =
    let history = create "test"
    let history = redo history
    Assert.Equal("test", history.State)
