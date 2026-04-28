defmodule DesignPattern.DecoratorTest do
  use ExUnit.Case
  alias DesignPattern.Decorator

  test "ベースのコーヒーを作成する" do
    coffee = Decorator.coffee()
    assert coffee.description == "Coffee"
    assert coffee.cost == 300
  end

  test "パイプラインでデコレーションする" do
    beverage =
      Decorator.coffee()
      |> Decorator.with_milk()
      |> Decorator.with_sugar()

    assert beverage.description == "Coffee, Milk, Sugar"
    assert beverage.cost == 380
  end

  test "全部盛りのコーヒー" do
    beverage =
      Decorator.coffee()
      |> Decorator.with_milk()
      |> Decorator.with_sugar()
      |> Decorator.with_whip()

    assert beverage.cost == 480
  end

  test "decorate_all で複数デコレータを適用する" do
    decorators = [&Decorator.with_milk/1, &Decorator.with_whip/1]
    beverage = Decorator.decorate_all(Decorator.coffee(), decorators)
    assert beverage.cost == 450
  end

  test "文字列デコレータをパイプラインで適用する" do
    result =
      "  hello  "
      |> Decorator.trim()
      |> Decorator.upcase()
      |> Decorator.wrap_brackets()

    assert result == "[HELLO]"
  end
end
