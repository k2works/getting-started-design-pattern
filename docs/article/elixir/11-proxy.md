# 第 11 章 遅延評価とアクセス制御で間接化する — Proxy

## パターンの目的

Proxy パターンは、他のオブジェクトへのアクセスを制御するための代理を提供するパターンです。Elixir では遅延評価（関数のラップ）とパターンマッチングによるアクセス制御で実現します。

## 構造

```plantuml
@startuml
class "Proxy" as P {
  + lazy(compute_fn)
  + get_value(proxy)
  + unwrap(proxy)
  + protected(resource, allowed_roles)
  + access(protected, role)
  + logging_proxy(target_fn, log_fn)
}

class "LazyProxy" as LP <<tuple>> {
  + {:lazy, compute_fn}
}

class "LoadedProxy" as LDP <<tuple>> {
  + {:loaded, value}
}

class "ProtectedProxy" as PP <<map>> {
  + resource: any
  + allowed_roles: list
}

P --> LP : creates
P --> LDP : resolves to
P --> PP : creates
@enduml
```

## 実装

### 遅延ロードプロキシ

```elixir
def lazy(compute_fn), do: {:lazy, compute_fn}

def get_value({:lazy, compute_fn}) do
  value = compute_fn.()
  {:loaded, value}
end

def get_value({:loaded, value}), do: {:loaded, value}
```

### アクセス制御プロキシ

```elixir
def access(%{allowed_roles: allowed_roles, resource: resource}, role) do
  if role in allowed_roles do
    {:ok, resource}
  else
    {:error, :access_denied}
  end
end
```

## テスト

```elixir
test "アクセス制御プロキシで拒否されたロールはアクセスできない" do
  resource = Proxy.protected("secret data", [:admin])
  assert {:error, :access_denied} = Proxy.access(resource, :guest)
end
```

## まとめ

- 遅延ロードプロキシはタグ付きタプルで状態遷移を表現
- アクセス制御プロキシはパターンマッチングで権限を検証
- ロギングプロキシは高階関数で操作をラップ
