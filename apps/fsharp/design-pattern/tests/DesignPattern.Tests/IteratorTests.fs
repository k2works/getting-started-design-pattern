module DesignPattern.Tests.IteratorTests

open Xunit
open DesignPattern.Iterator.Iterator

[<Fact>]
let ``rangeSequence で範囲のシーケンスを生成できる`` () =
    let result = rangeSequence 1 5 |> Seq.toList
    Assert.Equal<int list>([ 1; 2; 3; 4; 5 ], result)

[<Fact>]
let ``fibonacci で最初の10個のフィボナッチ数を取得できる`` () =
    let result = fibonacci |> Seq.take 10 |> Seq.toList
    Assert.Equal<int list>([ 0; 1; 1; 2; 3; 5; 8; 13; 21; 34 ], result)

[<Fact>]
let ``ツリーの深さ優先走査ができる`` () =
    let tree = Node(1, [ Node(2, [ Leaf 4; Leaf 5 ]); Node(3, [ Leaf 6 ]) ])
    let result = depthFirst tree |> Seq.toList
    Assert.Equal<int list>([ 1; 2; 4; 5; 3; 6 ], result)

[<Fact>]
let ``ツリーの幅優先走査ができる`` () =
    let tree = Node(1, [ Node(2, [ Leaf 4; Leaf 5 ]); Node(3, [ Leaf 6 ]) ])
    let result = breadthFirst tree |> Seq.toList
    Assert.Equal<int list>([ 1; 2; 3; 4; 5; 6 ], result)

[<Fact>]
let ``filterMap でフィルタリングとマッピングを同時に行える`` () =
    let result =
        [ 1; 2; 3; 4; 5; 6 ]
        |> filterMap (fun x -> x % 2 = 0) (fun x -> x * 10)
        |> Seq.toList

    Assert.Equal<int list>([ 20; 40; 60 ], result)

[<Fact>]
let ``Leaf のみのツリーを走査できる`` () =
    let tree = Leaf 42
    let result = depthFirst tree |> Seq.toList
    Assert.Equal<int list>([ 42 ], result)
