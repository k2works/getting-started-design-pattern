namespace DesignPattern.Composite

/// Composite パターン
/// F# では判別共用体（Discriminated Union）とパターンマッチングで表現する。
/// クラス階層の代わりに、再帰的な判別共用体を使う。
module Composite =

    /// タスクの判別共用体（再帰的定義）
    type Task =
        | LeafTask of name: string * duration: float
        | CompositeTask of name: string * children: Task list

    /// タスクの名前を取得する
    let getName = function
        | LeafTask(name, _) -> name
        | CompositeTask(name, _) -> name

    /// タスクの合計所要時間を再帰的に計算する
    let rec getTotalDuration = function
        | LeafTask(_, duration) -> duration
        | CompositeTask(_, children) ->
            children |> List.sumBy getTotalDuration

    /// タスクの数を再帰的にカウントする（リーフのみ）
    let rec getLeafCount = function
        | LeafTask _ -> 1
        | CompositeTask(_, children) ->
            children |> List.sumBy getLeafCount

    /// タスクツリーを文字列に変換する（インデント付き）
    let rec toStringWithIndent (indent: int) = function
        | LeafTask(name, duration) ->
            sprintf "%s%s (%.1f h)" (String.replicate indent "  ") name duration
        | CompositeTask(name, children) ->
            let header = sprintf "%s%s:" (String.replicate indent "  ") name
            let childStrings = children |> List.map (toStringWithIndent (indent + 1))
            header :: childStrings |> String.concat "\n"

    /// CompositeTask に子タスクを追加する
    let addChild (child: Task) = function
        | CompositeTask(name, children) -> CompositeTask(name, children @ [ child ])
        | leaf -> CompositeTask(getName leaf, [ leaf; child ])
