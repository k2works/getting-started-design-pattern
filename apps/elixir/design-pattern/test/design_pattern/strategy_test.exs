defmodule DesignPattern.StrategyTest do
  use ExUnit.Case
  alias DesignPattern.Strategy

  test "昇順ソート戦略でソートする" do
    assert Strategy.sort([3, 1, 2], Strategy.ascending()) == [1, 2, 3]
  end

  test "降順ソート戦略でソートする" do
    assert Strategy.sort([3, 1, 2], Strategy.descending()) == [3, 2, 1]
  end

  test "文字列長でソートする戦略" do
    assert Strategy.sort(["bb", "a", "ccc"], Strategy.by_length()) == ["a", "bb", "ccc"]
  end

  test "カスタム戦略を関数で渡せる" do
    reverse = fn list -> Enum.reverse(list) end
    assert Strategy.sort([1, 2, 3], reverse) == [3, 2, 1]
  end

  test "通常価格で合計を計算する" do
    assert Strategy.calculate_price([100, 200, 300], Strategy.normal_pricing()) == 600
  end

  test "割引価格で合計を計算する" do
    result = Strategy.calculate_price([100, 200, 300], Strategy.discount_pricing(0.1))
    assert_in_delta result, 540.0, 0.01
  end
end
