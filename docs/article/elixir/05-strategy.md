# 第 5 章 関数を渡してアルゴリズムを切り替える — Strategy

## パターンの目的

Strategy パターンは、アルゴリズムをカプセル化し、実行時に切り替え可能にするパターンです。Elixir では関数が第一級オブジェクトであるため、関数を引数として渡すだけで実現できます。

## 構造

```plantuml
@startuml
class "Strategy" as S {
  + sort(data, strategy_fn)
  + calculate_price(items, pricing_fn)
  + ascending()
  + descending()
  + by_length()
  + normal_pricing()
  + discount_pricing(rate)
}

class "SortStrategy" as SS <<function>> {
  + (list) -> sorted_list
}

class "PricingStrategy" as PS <<function>> {
  + (items) -> total
}

S --> SS : strategy_fn
S --> PS : pricing_fn
@enduml
```

## 実装

Strategy はシンプルに関数を引数として受け取ります。

```elixir
def sort(data, strategy) when is_function(strategy, 1) do
  strategy.(data)
end

def ascending, do: &Enum.sort(&1)
def descending, do: &Enum.sort(&1, :desc)
```

## テスト

```elixir
test "昇順ソート戦略でソートする" do
  assert Strategy.sort([3, 1, 2], Strategy.ascending()) == [1, 2, 3]
end

test "カスタム戦略を関数で渡せる" do
  reverse = fn list -> Enum.reverse(list) end
  assert Strategy.sort([1, 2, 3], reverse) == [3, 2, 1]
end
```

## Elixir らしさ

- 関数が第一級オブジェクトなので、Strategy パターンは言語に組み込まれている
- 無名関数やキャプチャ構文 `&` で戦略を簡潔に定義
- クロージャで状態を持つ戦略も作れる（例: 割引率）

## まとめ

- Elixir では関数がそのまま Strategy となる
- インターフェースの定義は不要で、関数の引数の数だけが契約
- クロージャでパラメタライズされた戦略を作成できる
