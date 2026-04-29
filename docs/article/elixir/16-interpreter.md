# 第 16 章 タグ付きタプルで言語を解釈する — Interpreter

## はじめに

Interpreter パターンは、言語の文法を定義し、その文法に基づいて式を解釈するパターンです。Elixir ではタグ付きタプルで AST（抽象構文木）を表現し、再帰的パターンマッチングで評価します。

## パターンの構造

```plantuml
@startuml
class "Interpreter" as I {
  + literal(value)
  + add(left, right)
  + subtract(left, right)
  + multiply(left, right)
  + divide(left, right)
  + variable(name)
  + evaluate(expr, env)
  + to_string_expr(expr)
}

class "Literal" as L <<tuple>> {
  + {:literal, value}
}

class "BinaryOp" as B <<tuple>> {
  + {:add, left, right}
  + {:subtract, left, right}
  + {:multiply, left, right}
  + {:divide, left, right}
}

class "Variable" as V <<tuple>> {
  + {:variable, name}
}

I --> L : creates
I --> B : creates
I --> V : creates
B o-- L : contains
B o-- B : contains
B o-- V : contains
@enduml
```

## Elixir イディオム: タグ付きタプルを再帰的に評価する

タグ付きタプルで式を構築し、パターンマッチングで再帰的に評価します。

```elixir
def evaluate({:literal, value}, _env), do: value

def evaluate({:add, left, right}, env) do
  evaluate(left, env) + evaluate(right, env)
end

def evaluate({:variable, name}, env) do
  Map.fetch!(env, name)
end
```

変数を含む式は環境マップで値を解決します。

```elixir
expr = Interpreter.add(Interpreter.variable(:x), Interpreter.literal(10))
Interpreter.evaluate(expr, %{x: 5})  # => 15
```

## TDD で作る

### Red: 失敗するテストを書く

```elixir
test "ネストした式を評価する" do
  # (2 + 3) * 4 = 20
  expr =
    Interpreter.multiply(
      Interpreter.add(Interpreter.literal(2), Interpreter.literal(3)),
      Interpreter.literal(4)
    )
  assert Interpreter.evaluate(expr) == 20
end

test "ゼロ除算はエラーを返す" do
  expr = Interpreter.divide(Interpreter.literal(10), Interpreter.literal(0))
  assert Interpreter.evaluate(expr) == {:error, :division_by_zero}
end
```

### Green: 最小限の実装

まずは `{:literal, value}` と `{:add, left, right}` を評価できるようにし、再帰評価の骨格を固めます。変数やエラー処理はそのあとに拡張します。

### Refactor

AST の構築関数と評価関数を分けておくと、`to_string_expr/1` のような別の解釈器を後付けしやすくなります。

## to_string_expr/1 による式の文字列表現

`to_string_expr/1` は式の AST を人間が読める数学的な表記に変換します。`evaluate/2` と同じ再帰構造ですが、計算する代わりに文字列を組み立てます。

```elixir
expr =
  Interpreter.multiply(
    Interpreter.add(Interpreter.literal(2), Interpreter.variable(:x)),
    Interpreter.literal(4)
  )

Interpreter.to_string_expr(expr)
# => "((2 + x) * 4)"
```

各演算子の変換規則は以下のとおりです。

| 構築関数 | タグ | to_string_expr の出力 |
|----------|------|----------------------|
| `literal(5)` | `{:literal, 5}` | `"5"` |
| `variable(:x)` | `{:variable, :x}` | `"x"` |
| `add(a, b)` | `{:add, a, b}` | `"(a + b)"` |
| `subtract(a, b)` | `{:subtract, a, b}` | `"(a - b)"` |
| `multiply(a, b)` | `{:multiply, a, b}` | `"(a * b)"` |
| `divide(a, b)` | `{:divide, a, b}` | `"(a / b)"` |

二項演算は常に括弧で囲まれるため、演算子の優先順位を明示的に表現します。

## 全演算子の使用例

```elixir
# 基本演算
Interpreter.evaluate(Interpreter.add(Interpreter.literal(3), Interpreter.literal(7)))
# => 10

Interpreter.evaluate(Interpreter.subtract(Interpreter.literal(10), Interpreter.literal(4)))
# => 6

Interpreter.evaluate(Interpreter.multiply(Interpreter.literal(3), Interpreter.literal(5)))
# => 15

Interpreter.evaluate(Interpreter.divide(Interpreter.literal(10), Interpreter.literal(3)))
# => 3.3333...

# ゼロ除算はエラーを返す
Interpreter.evaluate(Interpreter.divide(Interpreter.literal(10), Interpreter.literal(0)))
# => {:error, :division_by_zero}

# 変数を含む式
expr = Interpreter.add(Interpreter.variable(:x), Interpreter.variable(:y))
Interpreter.evaluate(expr, %{x: 10, y: 20})
# => 30

# 式の文字列表現
Interpreter.to_string_expr(expr)
# => "(x + y)"
```

## Elixir らしさ

- タグ付きタプルが AST ノードの自然な表現
- パターンマッチングで各ノード型の評価ロジックを分離
- 環境マップで変数の束縛を管理
- Elixir 自体がマクロで AST を操作する言語であり、Interpreter パターンは言語の本質に近い

## まとめ

- Interpreter はタグ付きタプルと再帰的パターンマッチングで表現する
- 6 種類の演算子（literal, add, subtract, multiply, divide, variable）で式を構築する
- 環境マップで変数のスコープを管理
- `to_string_expr/1` で式を数学的な文字列表現に変換できる
- Elixir のマクロシステムとの親和性が高い
