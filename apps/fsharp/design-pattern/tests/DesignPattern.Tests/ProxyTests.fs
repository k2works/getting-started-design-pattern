module DesignPattern.Tests.ProxyTests

open Xunit
open DesignPattern.Proxy.Proxy

[<Fact>]
let ``仮想プロキシは初回アクセスまで値を生成しない`` () =
    let mutable created = false

    let proxy =
        createVirtualProxy "テスト" (fun () ->
            created <- true
            42)

    Assert.False(isValueCreated proxy)
    Assert.False(created)

[<Fact>]
let ``仮想プロキシは初回アクセス時に値を生成する`` () =
    let mutable callCount = 0

    let proxy =
        createVirtualProxy "テスト" (fun () ->
            callCount <- callCount + 1
            42)

    let value = getValue proxy
    Assert.Equal(42, value)
    Assert.True(isValueCreated proxy)
    Assert.Equal(1, callCount)

[<Fact>]
let ``仮想プロキシは二回目以降のアクセスで再生成しない`` () =
    let mutable callCount = 0

    let proxy =
        createVirtualProxy "テスト" (fun () ->
            callCount <- callCount + 1
            "result")

    let _ = getValue proxy
    let _ = getValue proxy
    Assert.Equal(1, callCount)

[<Fact>]
let ``保護プロキシは権限があればアクセスを許可する`` () =
    let action input = Ok(sprintf "処理完了: %s" input)
    let protectedAction = protectionProxy User action
    let result = protectedAction Admin "データ"
    Assert.Equal(Ok "処理完了: データ", result)

[<Fact>]
let ``保護プロキシは権限がなければアクセスを拒否する`` () =
    let action input = Ok(sprintf "処理完了: %s" input)
    let protectedAction = protectionProxy Admin action
    let result = protectedAction Guest "データ"

    match result with
    | Error msg -> Assert.Contains("アクセス拒否", msg)
    | Ok _ -> Assert.Fail("アクセスが許可されるべきではない")

[<Fact>]
let ``ログプロキシは関数呼び出しを記録する`` () =
    let log = ref []
    let proxiedFn = loggingProxy log "double" (fun x -> x * 2)
    let result = proxiedFn 5
    Assert.Equal(10, result)
    Assert.Equal(2, log.Value.Length)
    Assert.Contains("double が呼び出されました", log.Value.[0])
    Assert.Contains("double が完了しました", log.Value.[1])
