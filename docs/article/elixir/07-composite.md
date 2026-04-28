# 第 7 章 再帰で木構造を統一的に扱う — Composite

## パターンの目的

Composite パターンは、個々のオブジェクトとオブジェクトの集合を同一視して扱うパターンです。Elixir ではタグ付きタプルと再帰的パターンマッチングで木構造を表現します。

## 構造

```plantuml
@startuml
class "Composite" as C {
  + leaf(name, value)
  + composite(name, children)
  + add_child(node, child)
  + total(node)
  + count(node)
  + name(node)
  + to_string_tree(node, indent)
}

class "<<tuple>> Leaf" as L {
  + {:leaf, name, value}
}

class "<<tuple>> CompositeNode" as CN {
  + {:composite, name, children}
}

C --> L : creates
C --> CN : creates
CN o-- L : contains
CN o-- CN : contains
@enduml
```

## 実装

タグ付きタプルの先頭要素でリーフとコンポジットを区別します。

```elixir
def total({:leaf, _name, value}), do: value
def total({:composite, _name, children}) do
  Enum.reduce(children, 0, fn child, acc -> acc + total(child) end)
end
```

## テスト

```elixir
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
```

## Elixir らしさ

- タグ付きタプルが代数的データ型の役割を果たす
- パターンマッチングでリーフとコンポジットを自然に分岐
- `Enum.reduce/3` で子ノードを再帰的に集約

## まとめ

- Composite はタグ付きタプルと再帰で表現する
- パターンマッチングがリーフ/コンポジットの区別を担う
- 再帰関数で木構造全体を走査・集約する
