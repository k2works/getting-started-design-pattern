module DesignPattern.Tests.DecoratorTests

open Xunit
open DesignPattern.Decorator.Decorator

[<Fact>]
let ``baseWriter はテキストをそのまま返す`` () =
    let result = baseWriter "Hello"
    Assert.Equal("Hello", result)

[<Fact>]
let ``行番号デコレーターを適用できる`` () =
    let writer = withLineNumbers baseWriter
    let result = writer "line1\nline2\nline3"
    Assert.Contains("1: line1", result)
    Assert.Contains("2: line2", result)
    Assert.Contains("3: line3", result)

[<Fact>]
let ``タイムスタンプデコレーターを適用できる`` () =
    let writer = withTimestamp "2024-01-01" baseWriter
    let result = writer "Hello"
    Assert.Equal("[2024-01-01] Hello", result)

[<Fact>]
let ``チェックサムデコレーターを適用できる`` () =
    let writer = withChecksum baseWriter
    let result = writer "Hello"
    Assert.Contains("[checksum:", result)

[<Fact>]
let ``大文字デコレーターを適用できる`` () =
    let writer = withUpperCase baseWriter
    let result = writer "hello"
    Assert.Equal("HELLO", result)

[<Fact>]
let ``括弧デコレーターを適用できる`` () =
    let writer = withBrackets baseWriter
    let result = writer "Hello"
    Assert.Equal("[ Hello ]", result)

[<Fact>]
let ``複数のデコレーターを合成できる`` () =
    let writer = compose [ withUpperCase; withBrackets ] baseWriter
    let result = writer "hello"
    Assert.Equal("[ HELLO ]", result)

[<Fact>]
let ``デコレーターの適用順序が結果に影響する`` () =
    let writer1 = compose [ withTimestamp "2024"; withUpperCase ] baseWriter
    let writer2 = compose [ withUpperCase; withTimestamp "2024" ] baseWriter
    let result1 = writer1 "hello"
    let result2 = writer2 "hello"
    // writer1: upperCase(timestamp(hello)) = "[2024] HELLO"  -> 大文字にならないタイムスタンプ部分
    // writer2: timestamp(upperCase(hello)) = "[2024] HELLO"  -> タイムスタンプ後に大文字
    // 実際に異なる: writer1 = "[2024] HELLO", writer2 = "[2024] HELLO" -- 同じになる
    // withChecksum を使う: 文字数が変わるので順序が影響する
    let writer3 = compose [ withChecksum; withBrackets ] baseWriter
    let writer4 = compose [ withBrackets; withChecksum ] baseWriter
    let result3 = writer3 "hello"
    let result4 = writer4 "hello"
    Assert.NotEqual<string>(result3, result4)
