defmodule DesignPattern.Decorator do
  @moduledoc """
  Decorator パターン: 関数合成とパイプライン演算子 |> による機能の追加。
  Elixir では関数を包む関数でデコレーションする。
  """

  @doc "ベースとなるコーヒーを作成する"
  def coffee do
    %{description: "Coffee", cost: 300}
  end

  @doc "ミルクデコレータ"
  def with_milk(beverage) do
    %{
      description: beverage.description <> ", Milk",
      cost: beverage.cost + 50
    }
  end

  @doc "砂糖デコレータ"
  def with_sugar(beverage) do
    %{
      description: beverage.description <> ", Sugar",
      cost: beverage.cost + 30
    }
  end

  @doc "ホイップクリームデコレータ"
  def with_whip(beverage) do
    %{
      description: beverage.description <> ", Whip",
      cost: beverage.cost + 100
    }
  end

  @doc "汎用デコレータ: 任意の関数でデコレーションする"
  def decorate(value, decorator_fn) do
    decorator_fn.(value)
  end

  @doc "複数のデコレータを順に適用する"
  def decorate_all(value, decorators) do
    Enum.reduce(decorators, value, fn decorator, acc -> decorator.(acc) end)
  end

  @doc "文字列に対するデコレータ: 大文字変換"
  def upcase(text), do: String.upcase(text)

  @doc "文字列に対するデコレータ: トリミング"
  def trim(text), do: String.trim(text)

  @doc "文字列に対するデコレータ: 括弧で囲む"
  def wrap_brackets(text), do: "[#{text}]"
end
