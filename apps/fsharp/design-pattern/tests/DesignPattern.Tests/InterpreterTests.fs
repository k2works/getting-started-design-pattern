module DesignPattern.Tests.InterpreterTests

open Xunit
open DesignPattern.Interpreter.Interpreter

[<Fact>]
let ``数値を評価できる`` () =
    let result = evaluate Map.empty (num 42.0)
    Assert.Equal(Ok 42.0, result)

[<Fact>]
let ``加算を評価できる`` () =
    let expr = add (num 3.0) (num 4.0)
    let result = evaluate Map.empty expr
    Assert.Equal(Ok 7.0, result)

[<Fact>]
let ``減算を評価できる`` () =
    let expr = sub (num 10.0) (num 3.0)
    let result = evaluate Map.empty expr
    Assert.Equal(Ok 7.0, result)

[<Fact>]
let ``乗算を評価できる`` () =
    let expr = mul (num 3.0) (num 4.0)
    let result = evaluate Map.empty expr
    Assert.Equal(Ok 12.0, result)

[<Fact>]
let ``除算を評価できる`` () =
    let expr = div (num 10.0) (num 2.0)
    let result = evaluate Map.empty expr
    Assert.Equal(Ok 5.0, result)

[<Fact>]
let ``ゼロ除算はエラーを返す`` () =
    let expr = div (num 10.0) (num 0.0)
    let result = evaluate Map.empty expr

    match result with
    | Error msg -> Assert.Contains("ゼロ除算", msg)
    | Ok _ -> Assert.Fail("エラーが期待される")

[<Fact>]
let ``変数を評価できる`` () =
    let env = Map.ofList [ ("x", 5.0); ("y", 3.0) ]
    let expr = add (var "x") (var "y")
    let result = evaluate env expr
    Assert.Equal(Ok 8.0, result)

[<Fact>]
let ``未定義の変数はエラーを返す`` () =
    let result = evaluate Map.empty (var "z")

    match result with
    | Error msg -> Assert.Contains("未定義の変数", msg)
    | Ok _ -> Assert.Fail("エラーが期待される")

[<Fact>]
let ``複雑な式を評価できる`` () =
    // (3 + 4) * (10 - 5) = 35
    let expr = mul (add (num 3.0) (num 4.0)) (sub (num 10.0) (num 5.0))
    let result = evaluate Map.empty expr
    Assert.Equal(Ok 35.0, result)

[<Fact>]
let ``式を文字列に変換できる`` () =
    let expr = add (num 3.0) (mul (num 4.0) (num 5.0))
    let result = toString expr
    Assert.Equal("(3 + (4 * 5))", result)
