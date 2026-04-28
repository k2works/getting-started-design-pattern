# 第 14 章 パターンマッチングで適切なデータを生成する — Factory

## はじめに

Factory パターンは、オブジェクトの生成をサブクラスに委ねるパターンです。Elixir ではパターンマッチングを使ったファクトリ関数で実現します。

## パターンの構造

```plantuml
@startuml
class "Factory" as F {
  + create_shape(type, params)
  + area(shape)
  + describe(shape)
  + create_connection(config)
}

class "Circle" as C <<map>> {
  + type: :circle
  + radius: number
}

class "Rectangle" as R <<map>> {
  + type: :rectangle
  + width: number
  + height: number
}

class "Triangle" as T <<map>> {
  + type: :triangle
  + base: number
  + height: number
}

F --> C : creates
F --> R : creates
F --> T : creates
@enduml
```

## Elixir イディオム: パターンマッチングで生成を分岐

アトムによるパターンマッチングで生成するデータを選択します。

```elixir
def create_shape(:circle, radius) do
  %{type: :circle, radius: radius}
end

def create_shape(:rectangle, {width, height}) do
  %{type: :rectangle, width: width, height: height}
end

def area(%{type: :circle, radius: r}), do: :math.pi() * r * r
def area(%{type: :rectangle, width: w, height: h}), do: w * h
```

## TDD で作る

### Red: 失敗するテストを書く

```elixir
test "円を作成して面積を計算する" do
  circle = Factory.create_shape(:circle, 5)
  assert circle.type == :circle
  assert_in_delta Factory.area(circle), 78.54, 0.01
end
```

### Green: 最小限の実装

まずは `:circle` だけを生成できる `create_shape/2` と、その面積計算だけを通せばテストを進められます。ほかの形状は同じパターンで増やせます。

### Refactor

生成関数と操作関数の両方をパターンマッチングでそろえると、データの種類ごとの責務が見えやすくなります。

## Elixir らしさ

- アトムでオブジェクトの種類を表現
- パターンマッチングで生成と操作を分岐
- マップでデータを構造化（構造体も使用可能）

## まとめ

- Factory はパターンマッチングによるファクトリ関数で表現する
- アトムが型タグとして機能する
- 同じパターンマッチングで生成と操作の両方を実現
