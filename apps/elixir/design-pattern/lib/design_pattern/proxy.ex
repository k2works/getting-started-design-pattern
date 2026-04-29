defmodule DesignPattern.Proxy do
  @moduledoc """
  Proxy パターン: 遅延評価とアクセス制御をパターンマッチングで実現する。
  """

  @doc "遅延ロードプロキシを作成する（値はアクセス時に初めて計算される）"
  def lazy(compute_fn) when is_function(compute_fn, 0) do
    {:lazy, compute_fn}
  end

  @doc "遅延プロキシから値を取得する（必要時に計算）"
  def get_value({:lazy, compute_fn}) do
    value = compute_fn.()
    {:loaded, value}
  end

  def get_value({:loaded, value}) do
    {:loaded, value}
  end

  @doc "値だけを取り出す"
  def unwrap({:lazy, compute_fn}), do: compute_fn.()
  def unwrap({:loaded, value}), do: value

  @doc "アクセス制御プロキシを作成する"
  def protected(resource, allowed_roles) do
    %{resource: resource, allowed_roles: allowed_roles}
  end

  @doc "ロールを検証してリソースにアクセスする"
  def access(%{resource: resource, allowed_roles: allowed_roles}, role) do
    if role in allowed_roles do
      {:ok, resource}
    else
      {:error, :access_denied}
    end
  end

  @doc "ログ記録プロキシ: 操作をログに記録しながら実行する"
  def logging_proxy(target_fn, log_fn) do
    fn args ->
      log_fn.(:before, args)
      result = target_fn.(args)
      log_fn.(:after, result)
      result
    end
  end
end
