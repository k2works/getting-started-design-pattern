defmodule DesignPattern.Composite do
  @moduledoc """
  Composite パターン: 再帰的データ構造とパターンマッチングによる木構造の表現。
  タグ付きタプルでリーフとコンポジットを区別する。
  """

  @doc "リーフノードを作成する"
  def leaf(name, value) do
    {:leaf, name, value}
  end

  @doc "コンポジットノードを作成する"
  def composite(name, children \\ []) do
    {:composite, name, children}
  end

  @doc "コンポジットに子を追加する"
  def add_child({:composite, name, children}, child) do
    {:composite, name, children ++ [child]}
  end

  @doc "ノードの値の合計を再帰的に計算する"
  def total({:leaf, _name, value}), do: value

  def total({:composite, _name, children}) do
    Enum.reduce(children, 0, fn child, acc -> acc + total(child) end)
  end

  @doc "ノードの数を再帰的にカウントする"
  def count({:leaf, _name, _value}), do: 1

  def count({:composite, _name, children}) do
    Enum.reduce(children, 1, fn child, acc -> acc + count(child) end)
  end

  @doc "ノードの名前を取得する"
  def name({:leaf, name, _value}), do: name
  def name({:composite, name, _children}), do: name

  @doc "木構造を文字列表現にする"
  def to_string_tree(node, indent \\ 0)

  def to_string_tree({:leaf, name, value}, indent) do
    String.duplicate("  ", indent) <> "#{name}: #{value}"
  end

  def to_string_tree({:composite, name, children}, indent) do
    prefix = String.duplicate("  ", indent)
    header = prefix <> "+ #{name}"
    child_strs = Enum.map(children, &to_string_tree(&1, indent + 1))
    Enum.join([header | child_strs], "\n")
  end
end
