defmodule DesignPattern.CompositeTest do
  use ExUnit.Case
  alias DesignPattern.Composite

  test "リーフノードの値を取得できる" do
    leaf = Composite.leaf("item", 100)
    assert Composite.total(leaf) == 100
    assert Composite.name(leaf) == "item"
  end

  test "コンポジットノードが子の合計を計算する" do
    tree =
      Composite.composite("root")
      |> Composite.add_child(Composite.leaf("a", 10))
      |> Composite.add_child(Composite.leaf("b", 20))

    assert Composite.total(tree) == 30
  end

  test "ネストしたコンポジットの合計を再帰的に計算する" do
    subtree =
      Composite.composite("sub")
      |> Composite.add_child(Composite.leaf("x", 5))
      |> Composite.add_child(Composite.leaf("y", 15))

    tree =
      Composite.composite("root")
      |> Composite.add_child(subtree)
      |> Composite.add_child(Composite.leaf("z", 30))

    assert Composite.total(tree) == 50
  end

  test "ノード数をカウントする" do
    tree =
      Composite.composite("root")
      |> Composite.add_child(Composite.leaf("a", 1))
      |> Composite.add_child(Composite.leaf("b", 2))

    assert Composite.count(tree) == 3
  end

  test "木構造を文字列表現にする" do
    tree =
      Composite.composite("root")
      |> Composite.add_child(Composite.leaf("a", 10))

    result = Composite.to_string_tree(tree)
    assert result =~ "+ root"
    assert result =~ "a: 10"
  end
end
