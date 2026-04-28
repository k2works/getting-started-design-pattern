# 第 8 章 Enum と Stream で走査する — Iterator

## パターンの目的

Iterator パターンは、コレクションの内部構造を公開せずに要素へ順次アクセスする方法を提供するパターンです。Elixir では `Enum` と `Stream` モジュールが Iterator パターンそのものです。

## 構造

```plantuml
@startuml
class "Iterator" as I {
  + transform(collection, filter_fn, map_fn)
  + lazy_transform(collection, filter_fn, map_fn)
  + range_iterator(start, stop, step)
  + chunk_process(collection, chunk_size, process_fn)
  + next(list)
  + take_until(collection, predicate)
}

class "Enum" as E <<module>> {
  + filter(enum, fn)
  + map(enum, fn)
  + reduce(enum, acc, fn)
}

class "Stream" as S <<module>> {
  + filter(enum, fn)
  + map(enum, fn)
  + unfold(acc, fn)
}

I --> E : uses
I --> S : uses
@enduml
```

## 実装

即時評価と遅延評価の 2 つのアプローチを使い分けます。

```elixir
# 即時評価
def transform(collection, filter_fn, map_fn) do
  collection
  |> Enum.filter(filter_fn)
  |> Enum.map(map_fn)
end

# 遅延評価
def lazy_transform(collection, filter_fn, map_fn) do
  collection
  |> Stream.filter(filter_fn)
  |> Stream.map(map_fn)
end
```

`Stream.unfold/2` でカスタムイテレータを作成できます。

```elixir
def range_iterator(start, stop, step \\\\ 1) do
  Stream.unfold(start, fn
    current when current > stop -> nil
    current -> {current, current + step}
  end)
end
```

## テスト

```elixir
test "遅延評価で変換する" do
  result =
    Iterator.lazy_transform(1..100, &(rem(&1, 3) == 0), &(&1 * 2))
    |> Enum.take(3)
  assert result == [6, 12, 18]
end
```

## まとめ

- Elixir の `Enum`/`Stream` が Iterator パターンの完全な実装
- `Stream` で遅延評価を実現し、大きなコレクションを効率的に処理
- `Stream.unfold/2` でカスタムイテレータを作成可能
