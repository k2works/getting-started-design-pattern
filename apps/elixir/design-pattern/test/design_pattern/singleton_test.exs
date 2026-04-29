defmodule DesignPattern.SingletonTest do
  use ExUnit.Case
  alias DesignPattern.Singleton
  alias DesignPattern.Singleton.Registry

  test "設定値を保存・取得できる" do
    Singleton.put(:db_host, "localhost")
    assert Singleton.get(:db_host) == "localhost"
    Singleton.delete(:db_host)
  end

  test "存在しないキーにはデフォルト値を返す" do
    assert Singleton.get(:nonexistent, "default") == "default"
  end

  test "設定値を削除できる" do
    Singleton.put(:temp_key, "value")
    Singleton.delete(:temp_key)
    assert Singleton.get(:temp_key) == nil
  end

  test "設定値を上書きできる" do
    Singleton.put(:counter, 1)
    Singleton.put(:counter, 2)
    assert Singleton.get(:counter) == 2
    Singleton.delete(:counter)
  end

  test "Registry に値を登録・参照できる" do
    Registry.register(:logger, %{level: :info})
    assert {:ok, %{level: :info}} = Registry.lookup(:logger)
    Registry.unregister(:logger)
  end

  test "Registry で未登録のキーは error を返す" do
    assert {:error, :not_found} = Registry.lookup(:unknown)
  end
end
