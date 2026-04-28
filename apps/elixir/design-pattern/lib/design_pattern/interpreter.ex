defmodule DesignPattern.Interpreter do
  @moduledoc """
  Interpreter パターン: タグ付きタプルに対する再帰的パターンマッチングで
  DSL（ドメイン固有言語）を解釈・評価する。
  """

  @doc "数値リテラル"
  def literal(value), do: {:literal, value}

  @doc "加算式"
  def add(left, right), do: {:add, left, right}

  @doc "減算式"
  def subtract(left, right), do: {:subtract, left, right}

  @doc "乗算式"
  def multiply(left, right), do: {:multiply, left, right}

  @doc "除算式"
  def divide(left, right), do: {:divide, left, right}

  @doc "変数参照"
  def variable(name), do: {:variable, name}

  @doc "式を評価する"
  def evaluate(expr, env \\ %{})

  def evaluate({:literal, value}, _env), do: value

  def evaluate({:variable, name}, env) do
    Map.fetch!(env, name)
  end

  def evaluate({:add, left, right}, env) do
    evaluate(left, env) + evaluate(right, env)
  end

  def evaluate({:subtract, left, right}, env) do
    evaluate(left, env) - evaluate(right, env)
  end

  def evaluate({:multiply, left, right}, env) do
    evaluate(left, env) * evaluate(right, env)
  end

  def evaluate({:divide, left, right}, env) do
    divisor = evaluate(right, env)

    if divisor == 0 do
      {:error, :division_by_zero}
    else
      evaluate(left, env) / divisor
    end
  end

  @doc "式を文字列に変換する"
  def to_string_expr({:literal, value}), do: "#{value}"
  def to_string_expr({:variable, name}), do: "#{name}"

  def to_string_expr({:add, left, right}) do
    "(#{to_string_expr(left)} + #{to_string_expr(right)})"
  end

  def to_string_expr({:subtract, left, right}) do
    "(#{to_string_expr(left)} - #{to_string_expr(right)})"
  end

  def to_string_expr({:multiply, left, right}) do
    "(#{to_string_expr(left)} * #{to_string_expr(right)})"
  end

  def to_string_expr({:divide, left, right}) do
    "(#{to_string_expr(left)} / #{to_string_expr(right)})"
  end
end
