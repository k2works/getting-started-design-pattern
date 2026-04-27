namespace DesignPattern.Iterator

/// Iterator パターン
/// F# では Seq モジュールとシーケンス式（seq { }）で自然に表現できる。
/// 明示的な Iterator クラスは不要。
module Iterator =

    /// 外部イテレーター：シーケンス式で要素を生成する
    let rangeSequence start stop =
        seq {
            for i in start..stop do
                yield i
        }

    /// フィボナッチ数列を遅延生成する
    let fibonacci =
        let rec fib a b =
            seq {
                yield a
                yield! fib b (a + b)
            }
        fib 0 1

    /// ツリー構造の深さ優先走査
    type Tree<'T> =
        | Leaf of 'T
        | Node of 'T * Tree<'T> list

    let rec depthFirst = function
        | Leaf value -> seq { yield value }
        | Node(value, children) ->
            seq {
                yield value
                for child in children do
                    yield! depthFirst child
            }

    /// 幅優先走査
    let breadthFirst (tree: Tree<'T>) =
        let rec bfs (queue: Tree<'T> list) =
            seq {
                match queue with
                | [] -> ()
                | current :: rest ->
                    match current with
                    | Leaf value ->
                        yield value
                        yield! bfs rest
                    | Node(value, children) ->
                        yield value
                        yield! bfs (rest @ children)
            }
        bfs [ tree ]

    /// フィルタリング付きイテレーション
    let filterMap (predicate: 'T -> bool) (mapper: 'T -> 'U) (source: 'T seq) =
        source
        |> Seq.filter predicate
        |> Seq.map mapper
