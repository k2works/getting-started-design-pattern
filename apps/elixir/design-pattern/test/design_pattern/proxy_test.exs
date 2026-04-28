defmodule DesignPattern.ProxyTest do
  use ExUnit.Case
  alias DesignPattern.Proxy

  test "遅延プロキシは値を遅延計算する" do
    proxy = Proxy.lazy(fn -> 42 end)
    assert {:loaded, 42} = Proxy.get_value(proxy)
  end

  test "ロード済みプロキシは再計算しない" do
    loaded = {:loaded, 99}
    assert {:loaded, 99} = Proxy.get_value(loaded)
  end

  test "unwrap で値を取り出せる" do
    assert Proxy.unwrap(Proxy.lazy(fn -> "hello" end)) == "hello"
    assert Proxy.unwrap({:loaded, "world"}) == "world"
  end

  test "アクセス制御プロキシで許可されたロールはアクセスできる" do
    resource = Proxy.protected("secret data", [:admin, :manager])
    assert {:ok, "secret data"} = Proxy.access(resource, :admin)
  end

  test "アクセス制御プロキシで拒否されたロールはアクセスできない" do
    resource = Proxy.protected("secret data", [:admin])
    assert {:error, :access_denied} = Proxy.access(resource, :guest)
  end

  test "ロギングプロキシが操作を記録する" do
    test_pid = self()

    log_fn = fn phase, data ->
      send(test_pid, {:log, phase, data})
    end

    proxy = Proxy.logging_proxy(fn x -> x * 2 end, log_fn)
    result = proxy.(5)

    assert result == 10
    assert_received {:log, :before, 5}
    assert_received {:log, :after, 10}
  end
end
