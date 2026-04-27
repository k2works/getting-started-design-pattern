module DesignPattern.Tests.CompositeTests

open Xunit
open DesignPattern.Composite.Composite

[<Fact>]
let ``LeafTask の名前と所要時間を取得できる`` () =
    let task = LeafTask("コーディング", 3.0)
    Assert.Equal("コーディング", getName task)
    Assert.Equal(3.0, getTotalDuration task)

[<Fact>]
let ``CompositeTask の合計所要時間を計算できる`` () =
    let project =
        CompositeTask("プロジェクト", [
            LeafTask("設計", 2.0)
            LeafTask("実装", 5.0)
            LeafTask("テスト", 3.0)
        ])
    Assert.Equal(10.0, getTotalDuration project)

[<Fact>]
let ``ネストされた CompositeTask の合計所要時間を計算できる`` () =
    let project =
        CompositeTask("プロジェクト", [
            CompositeTask("フェーズ1", [
                LeafTask("設計", 2.0)
                LeafTask("実装", 5.0)
            ])
            CompositeTask("フェーズ2", [
                LeafTask("テスト", 3.0)
                LeafTask("デプロイ", 1.0)
            ])
        ])
    Assert.Equal(11.0, getTotalDuration project)

[<Fact>]
let ``リーフタスクの数をカウントできる`` () =
    let project =
        CompositeTask("プロジェクト", [
            CompositeTask("フェーズ1", [
                LeafTask("設計", 2.0)
                LeafTask("実装", 5.0)
            ])
            LeafTask("レビュー", 1.0)
        ])
    Assert.Equal(3, getLeafCount project)

[<Fact>]
let ``子タスクを追加できる`` () =
    let task = CompositeTask("親", [ LeafTask("子1", 1.0) ])
    let updated = addChild (LeafTask("子2", 2.0)) task
    Assert.Equal(2, getLeafCount updated)

[<Fact>]
let ``タスクツリーを文字列に変換できる`` () =
    let task = CompositeTask("親", [ LeafTask("子", 1.0) ])
    let result = toStringWithIndent 0 task
    Assert.Contains("親:", result)
    Assert.Contains("子 (1.0 h)", result)
