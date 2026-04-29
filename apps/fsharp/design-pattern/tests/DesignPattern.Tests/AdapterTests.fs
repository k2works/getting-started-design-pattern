module DesignPattern.Tests.AdapterTests

open Xunit
open DesignPattern.Adapter.Adapter

[<Fact>]
let ``LegacyHtmlRenderer をアダプタ経由で使える`` () =
    let legacy = createLegacyHtmlRenderer ()
    let renderer = adaptHtmlRenderer legacy
    let result = renderContent renderer "テスト"
    Assert.Equal("<html><body>テスト</body></html>", result)

[<Fact>]
let ``LegacyJsonRenderer をアダプタ経由で使える`` () =
    let legacy = createLegacyJsonRenderer ()
    let renderer = adaptJsonRenderer legacy
    let result = renderContent renderer "テスト"
    Assert.Equal("""{"content": "テスト"}""", result)

[<Fact>]
let ``異なるレンダラーを統一インターフェースで扱える`` () =
    let htmlRenderer = adaptHtmlRenderer (createLegacyHtmlRenderer ())
    let jsonRenderer = adaptJsonRenderer (createLegacyJsonRenderer ())
    let renderers = [ htmlRenderer; jsonRenderer ]
    let results = renderers |> List.map (fun r -> renderContent r "データ")
    Assert.Equal(2, results.Length)
    Assert.Contains("<html>", results.[0])
    Assert.Contains("content", results.[1])
