defmodule DesignPattern.Singleton do
  @moduledoc """
  Singleton パターン: Application 環境とモジュール属性による共有状態。
  Elixir では GenServer や ETS、Application.put_env/get_env で
  グローバルな状態を管理する。ここではシンプルに Application env を使う。
  """

  @app :design_pattern

  @doc "設定値を保存する"
  def put(key, value) do
    Application.put_env(@app, key, value)
  end

  @doc "設定値を取得する"
  def get(key, default \\ nil) do
    Application.get_env(@app, key, default)
  end

  @doc "設定値を削除する"
  def delete(key) do
    Application.delete_env(@app, key)
  end

  @doc "全設定を取得する"
  def get_all do
    Application.get_all_env(@app)
  end
end

defmodule DesignPattern.Singleton.Registry do
  @moduledoc """
  レジストリパターン: 名前付きのシングルトンオブジェクトを管理する。
  Process Dictionary を使ったシンプルな実装。
  """

  @doc "レジストリに値を登録する"
  def register(name, value) do
    Process.put({:singleton_registry, name}, value)
    :ok
  end

  @doc "レジストリから値を取得する"
  def lookup(name) do
    case Process.get({:singleton_registry, name}) do
      nil -> {:error, :not_found}
      value -> {:ok, value}
    end
  end

  @doc "レジストリから値を削除する"
  def unregister(name) do
    Process.delete({:singleton_registry, name})
    :ok
  end
end
