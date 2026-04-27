module DesignPattern.Tests.TemplateMethodTests

open Xunit
open DesignPattern.TemplateMethod.TemplateMethod

[<Fact>]
let ``HTML フォーマットでレポートを生成できる`` () =
    let result = generateReport htmlFormat "テストレポート" [ "項目1"; "項目2" ]
    Assert.Equal("<html>", result.[0])
    Assert.Contains("テストレポート", result.[1])
    Assert.Equal("</html>", result |> List.last)

[<Fact>]
let ``プレーンテキストフォーマットでレポートを生成できる`` () =
    let result = generateReport plainTextFormat "テストレポート" [ "項目1"; "項目2" ]
    Assert.Equal("***** Start *****", result.[0])
    Assert.Equal("テストレポート", result.[1])
    Assert.Equal("***** End *****", result |> List.last)

[<Fact>]
let ``カスタムフォーマットを定義できる`` () =
    let customFormat =
        { OutputStart = fun _ -> "=== BEGIN ==="
          OutputHead = fun title -> sprintf "[%s]" title
          OutputBody = fun items -> items |> List.map (fun item -> sprintf "  * %s" item)
          OutputEnd = fun _ -> "=== END ===" }
    let result = generateReport customFormat "カスタム" [ "A"; "B" ]
    Assert.Equal("=== BEGIN ===", result.[0])
    Assert.Equal("[カスタム]", result.[1])
    Assert.Equal("  * A", result.[2])
    Assert.Equal("  * B", result.[3])
    Assert.Equal("=== END ===", result.[4])

[<Fact>]
let ``空の項目リストでもレポートを生成できる`` () =
    let result = generateReport htmlFormat "空レポート" []
    Assert.Equal(3, result.Length)
