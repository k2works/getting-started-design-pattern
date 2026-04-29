# 第 13 章 Application 環境で唯一の状態を管理する — Singleton

## はじめに

Singleton パターンは、あるクラスのインスタンスが 1 つだけであることを保証するパターンです。Elixir では Application 環境や GenServer でグローバルな状態を管理します。

## パターンの構造

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

class "Application" as A <<module>> {
  + put_env(app, key, value)
  + get_env(app, key, default)
}

S --> A : delegates to
@enduml
```

## Elixir イディオム: Application 環境への委譲

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

## TDD で作る

### Red: 失敗するテストを書く

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

### Green: 最小限の実装

最初は `put/2` と `get/2` だけを `Application.put_env/3` と `Application.get_env/3` に委譲すれば十分です。削除や一覧取得は後続の拡張に回せます。

### Refactor

設定用途なら Application 環境、可変状態や並行アクセスが絡むなら GenServer や ETS に分けて考えるのが実践的です。

## 全設定の取得

`get_all/0` は Application 環境に登録されたすべての設定値をキーワードリストとして返します。

```elixir
Singleton.put(:db_host, "localhost")
Singleton.put(:db_port, 5432)

Singleton.get_all()
# => [db_host: "localhost", db_port: 5432, ...]
```

## Registry: Process Dictionary によるシングルトン

`DesignPattern.Singleton.Registry` は Process Dictionary を使った名前付きシングルトンの管理を提供します。

```elixir
alias DesignPattern.Singleton.Registry

# 値を登録
Registry.register(:config, %{env: :production})
# => :ok

# 値を取得
Registry.lookup(:config)
# => {:ok, %{env: :production}}

# 存在しない名前を取得
Registry.lookup(:unknown)
# => {:error, :not_found}

# 値を削除
Registry.unregister(:config)
# => :ok
```

### Process Dictionary の制限

Process Dictionary はプロセスローカルな記憶領域であるため、以下の制限があります。

- **プロセスごとに独立**: 別プロセスからは参照できません。テストや GenServer 内など、同一プロセスでの利用が前提です
- **デバッグが困難**: 暗黙の状態を持つため、明示的なデータの受け渡しに比べて追跡が難しくなります
- **テスト間の干渉**: テスト間で Process Dictionary がリセットされない場合、意図しない状態の共有が起きる可能性があります

本番環境でのシングルトンには GenServer や ETS の利用を推奨します。

## Elixir における代替アプローチ

- **GenServer**: プロセスとして状態を管理。名前付き登録で唯一性を保証
- **ETS**: Erlang Term Storage による高速な共有テーブル
- **Agent**: 状態管理に特化したプロセス

## まとめ

- Elixir では Application 環境が設定のシングルトンとして機能する
- `get_all/0` で全設定を一括取得できる
- `Registry` モジュールで Process Dictionary ベースの名前付きシングルトンを管理可能
- Process Dictionary はプロセスローカルであるため、並行環境での利用には注意が必要
- GenServer や ETS でより高度な状態管理が可能
- 関数型言語ではグローバルな可変状態は最小限にすべき
