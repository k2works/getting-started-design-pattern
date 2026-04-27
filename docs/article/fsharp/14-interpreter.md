# 第 14 章：Interpreter — 判別共用体で AST を表現する

## はじめに

Interpreter パターンは、言語の文法を定義し、その文法に基づいて文を解釈します。F# では、判別共用体で AST（抽象構文木）を定義し、再帰的なパターンマッチングで評価します。これは関数型プログラミングの最も自然な応用の一つです。

## パターンの構造

```plantuml
@startuml
title Interpreter（F# 版）

class "Expression" as E <<discriminated union>> {
  + Number(float)
  + Add(Expression, Expression)
  + Subtract(Expression, Expression)
  + Multiply(Expression, Expression)
  + Divide(Expression, Expression)
  + Variable(string)
}

class "Environment" as Env <<type alias>> {
  Map~string, float~
}

class <<module>> "Interpreter" as I {
  + evaluate(env, expr): Result
  + toString(expr): string
  + num(n): Expression
  + var(name): Expression
  + add(l, r): Expression
}

I --> E : evaluates
I --> Env : uses
E --> E : recursive
@enduml
```

## TDD で作る

### Red: 失敗するテストを書く

```fsharp
[<Fact>]
let ``複雑な式を評価できる`` () =
    // (3 + 4) * (10 - 5) = 35
    let expr = mul (add (num 3.0) (num 4.0)) (sub (num 10.0) (num 5.0))
    let result = evaluate Map.empty expr
    Assert.Equal(Ok 35.0, result)
```

### Green: テストを通す最小のコードを書く

```fsharp
type Expression =
    | Number of float
    | Add of Expression * Expression
    | Multiply of Expression * Expression
    // ...

let rec evaluate (env: Environment) = function
    | Number n -> Ok n
    | Add(left, right) ->
        evaluateBinary env left right (+)
    | Multiply(left, right) ->
        evaluateBinary env left right (*)
```

### Refactor

`evaluateBinary` ヘルパー関数で二項演算の共通ロジックを抽出しました。`Result` 型でゼロ除算や未定義変数のエラーを安全に伝播します。

## OOP 版（C#）との比較

### C# 版

```csharp
abstract class Expression { public abstract double Evaluate(Dictionary<string, double> env); }
class NumberExpression : Expression {
    private double value;
    public override double Evaluate(...) => value;
}
class AddExpression : Expression {
    private Expression left, right;
    public override double Evaluate(var env) =>
        left.Evaluate(env) + right.Evaluate(env);
}
```

### F# 版の優位性

- 判別共用体で全ノード型が 1 箇所に定義される
- パターンマッチングで網羅性が保証される
- `Result` 型でエラーが型安全に表現される
- ビルダー関数（`num`, `add` など）で AST の構築が簡潔

## まとめ

- Interpreter は判別共用体の最も強力な応用例
- 再帰的なパターンマッチングで AST を自然に評価できる
- `Result` 型によりエラーが値として安全に伝播される
- コンパイラ、DSL、数式評価器など幅広い応用がある
