# 第 6 章 コールバックで変化を通知する — Observer

## はじめに

Observer パターンは、あるオブジェクトの状態変化を、依存するオブジェクトに自動的に通知するパターンです。Elixir ではコールバック関数のリストと不変マップで実現します。

## パターンの構造

```plantuml
@startuml
class "Observer" as O {
  + new_subject(name)
  + add_observer(subject, observer_fn)
  + remove_observer(subject, observer_fn)
  + update_state(subject, new_state)
  + notify(subject)
}

class "Subject" as S <<map>> {
  + name: String
  + observers: list
  + state: any
}

class "EventBus" as EB {
  + new()
  + subscribe(bus, topic, handler_fn)
  + publish(bus, topic, event)
}

O --> S : manages
EB --> S : extends
@enduml
```

## Elixir イディオム: コールバック関数のリスト

サブジェクトはマップで表現し、オブザーバーは関数のリストとして保持します。

```elixir
def update_state(subject, new_state) do
  updated = %{subject | state: new_state}
  notify(updated)
  updated
end

def notify(subject) do
  Enum.each(subject.observers, fn observer ->
    observer.(subject.name, subject.state)
  end)
end
```

## TDD で作る

### Red: 失敗するテストを書く

```elixir
test "オブザーバーに通知が届く" do
  test_pid = self()
  observer = fn name, state ->
    send(test_pid, {:notified, name, state})
  end

  Observer.new_subject("sensor")
  |> Observer.add_observer(observer)
  |> Observer.update_state(100)

  assert_received {:notified, "sensor", 100}
end
```

### Green: 最小限の実装

`update_state/2` で新しい状態を持つサブジェクトを作り、`notify/1` で登録済みコールバックを順に呼べばテストを通せます。まずは 1 つの通知経路だけを通すのが先です。

### Refactor

単純なオブザーバー配列で仕組みを確認した後、トピック単位の分配が必要になったら `EventBus` へ発展させます。

## EventBus への発展

トピックベースのイベントバスで、より柔軟な通知を実現します。

```elixir
bus = EventBus.new()
|> EventBus.subscribe(:user_created, fn e -> handle(e) end)
EventBus.publish(bus, :user_created, %{id: 1})
```

## まとめ

- Observer はコールバック関数のリストで実現する
- `send/2` と `assert_received` でテストが容易
- EventBus でトピックベースの通知に発展可能
