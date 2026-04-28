# 第 15 章 パイプラインで段階的に構築する — Builder

## パターンの目的

Builder パターンは、複雑なオブジェクトの構築を段階的に行うパターンです。Elixir ではパイプライン演算子 `|>` と Map 操作で段階的にデータを構築します。

## 構造

```plantuml
@startuml
class "Builder" as B {
  + new_query()
  + select(query, fields)
  + from(query, table)
  + where(query, condition)
  + order_by(query, field)
  + limit(query, n)
  + to_sql(query)
  + new_element(tag)
  + attr(element, key, value)
  + text(element, content)
  + child(element, child)
  + to_html(element)
}

class "<<map>> Query" as Q {
  + select: String
  + from: String
  + where: list
  + order_by: String
  + limit: integer
}

class "<<map>> Element" as E {
  + tag: String
  + attributes: map
  + children: list
  + text: String
}

B --> Q : builds
B --> E : builds
@enduml
```

## 実装

各ビルダー関数はマップを受け取り、更新したマップを返します。

```elixir
def new_query do
  %{select: "*", from: nil, where: [], order_by: nil, limit: nil}
end

def select(query, fields), do: %{query | select: fields}
def from(query, table), do: %{query | from: table}
def where(query, condition) do
  %{query | where: query.where ++ [condition]}
end
```

パイプラインで直感的に構築できます。

```elixir
sql =
  Builder.new_query()
  |> Builder.select("name, age")
  |> Builder.from("users")
  |> Builder.where("age > 18")
  |> Builder.limit(10)
  |> Builder.to_sql()
```

## テスト

```elixir
test "クエリをパイプラインで構築して SQL に変換する" do
  sql =
    Builder.new_query()
    |> Builder.select("name, age")
    |> Builder.from("users")
    |> Builder.where("age > 18")
    |> Builder.order_by("name")
    |> Builder.limit(10)
    |> Builder.to_sql()

  assert sql == "SELECT name, age FROM users WHERE age > 18 ORDER BY name LIMIT 10"
end
```

## まとめ

- Builder はパイプライン `|>` と Map 操作で段階的に構築する
- 各ビルダー関数は不変データの変換として表現される
- `to_sql/1` や `to_html/1` で最終的なデータに変換する
