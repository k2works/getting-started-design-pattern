module DesignPattern.Tests.StrategyTests

open Xunit
open DesignPattern.Strategy.Strategy

[<Fact>]
let ``HTML 戦略でレポートをフォーマットできる`` () =
    let report = { Title = "テスト"; Items = [ "項目1"; "項目2" ] }
    let result = formatReport htmlStrategy report
    Assert.Contains("<p>テスト</p>", result)
    Assert.Contains("<p>項目1</p>", result)

[<Fact>]
let ``プレーンテキスト戦略でレポートをフォーマットできる`` () =
    let report = { Title = "テスト"; Items = [ "項目1" ] }
    let result = formatReport plainTextStrategy report
    Assert.Contains("** テスト **", result)

[<Fact>]
let ``Markdown 戦略でレポートをフォーマットできる`` () =
    let report = { Title = "テスト"; Items = [ "項目1"; "項目2" ] }
    let result = formatReport markdownStrategy report
    Assert.Contains("- テスト", result)
    Assert.Contains("- 項目1", result)

[<Fact>]
let ``ラムダ式で独自の戦略を定義できる`` () =
    let customStrategy : FormatStrategy = fun text -> sprintf ">>> %s <<<" text
    let report = { Title = "カスタム"; Items = [ "A" ] }
    let result = formatReport customStrategy report
    Assert.Contains(">>> カスタム <<<", result)
