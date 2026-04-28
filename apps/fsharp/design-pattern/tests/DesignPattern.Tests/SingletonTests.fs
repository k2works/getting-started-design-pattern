module DesignPattern.Tests.SingletonTests

open Xunit
open DesignPattern.Singleton.Singleton

[<Fact>]
let ``デフォルト設定が存在する`` () =
    Assert.Equal("localhost:5432", defaultConfig.DatabaseUrl)
    Assert.Equal(10, defaultConfig.MaxConnections)
    Assert.Equal("INFO", defaultConfig.LogLevel)

[<Fact>]
let ``設定を変更すると新しいインスタンスが返る`` () =
    let newConfig = defaultConfig |> withDatabaseUrl "remote:5432"
    Assert.Equal("remote:5432", newConfig.DatabaseUrl)
    Assert.Equal("localhost:5432", defaultConfig.DatabaseUrl)

[<Fact>]
let ``パイプラインで複数の設定を変更できる`` () =
    let config =
        defaultConfig
        |> withDatabaseUrl "db.example.com:5432"
        |> withMaxConnections 50
        |> withLogLevel "DEBUG"

    Assert.Equal("db.example.com:5432", config.DatabaseUrl)
    Assert.Equal(50, config.MaxConnections)
    Assert.Equal("DEBUG", config.LogLevel)

[<Fact>]
let ``Counter は同一インスタンスを返す`` () =
    Counter.Instance.Reset()
    let c1 = Counter.Instance
    let c2 = Counter.Instance
    c1.Increment() |> ignore
    Assert.Equal(1, c2.Value)

[<Fact>]
let ``Counter のインクリメントが正しく動作する`` () =
    Counter.Instance.Reset()
    let result1 = Counter.Instance.Increment()
    let result2 = Counter.Instance.Increment()
    Assert.Equal(1, result1)
    Assert.Equal(2, result2)
    Assert.Equal(2, Counter.Instance.Value)
