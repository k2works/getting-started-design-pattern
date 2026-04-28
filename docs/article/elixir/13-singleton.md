# 第 13 章 Application 環境で唯一の状態を管理する — Singleton

## パターンの目的

Singleton パターンは、あるクラスのインスタンスが 1 つだけであることを保証するパターンです。Elixir では Application 環境や GenServer でグローバルな状態を管理します。

## 構造

```plantuml
@startuml
class "Singleton" as S {
  + put(key, value)
  + get(key, default)
  + delete(key)
  + get_all()
}

class "Registry" as R {
  + register(name, value)
  + lookup(name)
  + unregister(name)
}

class "<<module>> Application" as A {
  + put_env(app, key, value)
  + get_env(app, key, default)
}

S --> A : delegates to
@enduml
```

## 実装

Application 環境を使ったシンプルな実装です。

```elixir
@app :design_pattern

def put(key, value) do
  Application.put_env(@app, key, value)
end

def get(key, default \\\\ nil) do
  Application.get_env(@app, key, default)
end
```

## テスト

```elixir
test "設定値を保存・取得できる" do
  Singleton.put(:db_host, "localhost")
  assert Singleton.get(:db_host) == "localhost"
  Singleton.delete(:db_host)
end

test "存在しないキーにはデフォルト値を返す" do
  assert Singleton.get(:nonexistent, "default") == "default"
end
```

## Elixir における代替アプローチ

- **GenServer**: プロセスとして状態を管理。名前付き登録で唯一性を保証
- **ETS**: Erlang Term Storage による高速な共有テーブル
- **Agent**: 状態管理に特化したプロセス

## まとめ

- Elixir では Application 環境が設定のシングルトンとして機能する
- GenServer や ETS でより高度な状態管理が可能
- 関数型言語ではグローバルな可変状態は最小限にすべき
