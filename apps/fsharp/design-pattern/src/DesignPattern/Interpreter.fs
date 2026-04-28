namespace DesignPattern.Interpreter

/// Interpreter パターン
/// F# では判別共用体で AST（抽象構文木）を表現し、
/// 再帰的なパターンマッチングで評価する。
module Interpreter =

    /// 式の判別共用体（AST）
    type Expression =
        | Number of float
        | Add of Expression * Expression
        | Subtract of Expression * Expression
        | Multiply of Expression * Expression
        | Divide of Expression * Expression
        | Variable of string

    /// 環境（変数名と値の対応）
    type Environment = Map<string, float>

    /// 式を評価する
    let rec evaluate (env: Environment) (expr: Expression) : Result<float, string> =
        match expr with
        | Number n -> Ok n
        | Variable name ->
            match env |> Map.tryFind name with
            | Some value -> Ok value
            | None -> Error(sprintf "未定義の変数: %s" name)
        | Add(left, right) -> evaluateBinary env left right (+)
        | Subtract(left, right) -> evaluateBinary env left right (-)
        | Multiply(left, right) -> evaluateBinary env left right (*)
        | Divide(left, right) ->
            match evaluate env right with
            | Ok 0.0 -> Error "ゼロ除算エラー"
            | rightResult -> evaluateBinaryResult (evaluate env left) rightResult (/)

    and private evaluateBinary env left right op =
        evaluateBinaryResult (evaluate env left) (evaluate env right) op

    and private evaluateBinaryResult leftResult rightResult op =
        match leftResult, rightResult with
        | Ok l, Ok r -> Ok(op l r)
        | Error e, _ -> Error e
        | _, Error e -> Error e

    /// 式を文字列に変換する
    let rec toString =
        function
        | Number n -> sprintf "%.0f" n
        | Variable name -> name
        | Add(left, right) -> sprintf "(%s + %s)" (toString left) (toString right)
        | Subtract(left, right) -> sprintf "(%s - %s)" (toString left) (toString right)
        | Multiply(left, right) -> sprintf "(%s * %s)" (toString left) (toString right)
        | Divide(left, right) -> sprintf "(%s / %s)" (toString left) (toString right)

    // --- 便利なビルダー関数 ---

    let num n = Number n
    let var name = Variable name
    let add l r = Add(l, r)
    let sub l r = Subtract(l, r)
    let mul l r = Multiply(l, r)
    let div l r = Divide(l, r)
