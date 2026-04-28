defmodule DesignPattern.Observer do
  @moduledoc """
  Observer パターン: コールバック関数のリストを状態として保持し、
  イベント発生時に全オブザーバーに通知する。
  GenServer を使わないシンプルな関数型アプローチ。
  """

  @doc "空のオブザーバーリストを持つサブジェクトを作成する"
  def new_subject(name) do
    %{name: name, observers: [], state: nil}
  end

  @doc "オブザーバー（関数）を登録する"
  def add_observer(subject, observer) when is_function(observer, 2) do
    %{subject | observers: subject.observers ++ [observer]}
  end

  @doc "オブザーバーを削除する"
  def remove_observer(subject, observer) do
    %{subject | observers: List.delete(subject.observers, observer)}
  end

  @doc "状態を更新し、全オブザーバーに通知する"
  def update_state(subject, new_state) do
    updated = %{subject | state: new_state}
    notify(updated)
    updated
  end

  @doc "全オブザーバーに通知する"
  def notify(subject) do
    Enum.each(subject.observers, fn observer ->
      observer.(subject.name, subject.state)
    end)
  end

  @doc "現在の状態を取得する"
  def get_state(subject), do: subject.state
end

defmodule DesignPattern.Observer.EventBus do
  @moduledoc """
  Observer パターンの応用: イベントバス。
  トピックごとにオブザーバーを管理する。
  """

  @doc "空のイベントバスを作成する"
  def new do
    %{}
  end

  @doc "トピックにオブザーバーを登録する"
  def subscribe(bus, topic, handler) when is_function(handler, 1) do
    handlers = Map.get(bus, topic, [])
    Map.put(bus, topic, handlers ++ [handler])
  end

  @doc "トピックにイベントを発行する"
  def publish(bus, topic, event) do
    handlers = Map.get(bus, topic, [])
    Enum.each(handlers, fn handler -> handler.(event) end)
    bus
  end
end
