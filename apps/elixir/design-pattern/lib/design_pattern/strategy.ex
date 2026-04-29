defmodule DesignPattern.Strategy do
  @moduledoc """
  Strategy パターン: 関数を引数として渡すことでアルゴリズムを切り替える。
  Elixir では第一級関数がそのまま Strategy となる。
  """

  @doc "与えられたソート戦略で data をソートする"
  def sort(data, strategy) when is_function(strategy, 1) do
    strategy.(data)
  end

  @doc "昇順ソート戦略"
  def ascending, do: &Enum.sort(&1)

  @doc "降順ソート戦略"
  def descending, do: &Enum.sort(&1, :desc)

  @doc "文字列長でソートする戦略"
  def by_length do
    fn list -> Enum.sort_by(list, &String.length/1) end
  end

  @doc "与えられた価格計算戦略で合計を計算する"
  def calculate_price(items, pricing_strategy) when is_function(pricing_strategy, 1) do
    pricing_strategy.(items)
  end

  @doc "通常価格戦略"
  def normal_pricing do
    fn items -> Enum.sum(items) end
  end

  @doc "割引価格戦略（rate: 0.0〜1.0）"
  def discount_pricing(rate) do
    fn items -> Enum.sum(items) * (1 - rate) end
  end
end
