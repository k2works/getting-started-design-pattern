defmodule DesignPattern.InterpreterTest do
  use ExUnit.Case
  alias DesignPattern.Interpreter

  test "リテラルを評価する" do
    assert Interpreter.evaluate(Interpreter.literal(42)) == 42
  end

  test "加算式を評価する" do
    expr = Interpreter.add(Interpreter.literal(3), Interpreter.literal(4))
    assert Interpreter.evaluate(expr) == 7
  end

  test "ネストした式を評価する" do
    # (2 + 3) * 4 = 20
    expr =
      Interpreter.multiply(
        Interpreter.add(Interpreter.literal(2), Interpreter.literal(3)),
        Interpreter.literal(4)
      )

    assert Interpreter.evaluate(expr) == 20
  end

  test "変数を含む式を評価する" do
    expr = Interpreter.add(Interpreter.variable(:x), Interpreter.literal(10))
    assert Interpreter.evaluate(expr, %{x: 5}) == 15
  end

  test "ゼロ除算はエラーを返す" do
    expr = Interpreter.divide(Interpreter.literal(10), Interpreter.literal(0))
    assert Interpreter.evaluate(expr) == {:error, :division_by_zero}
  end

  test "式を文字列に変換する" do
    expr =
      Interpreter.add(
        Interpreter.literal(1),
        Interpreter.multiply(Interpreter.literal(2), Interpreter.literal(3))
      )

    assert Interpreter.to_string_expr(expr) == "(1 + (2 * 3))"
  end
end
