defmodule DesignPattern.ObserverTest do
  use ExUnit.Case
  alias DesignPattern.Observer
  alias DesignPattern.Observer.EventBus

  test "サブジェクトを作成し状態を更新できる" do
    subject = Observer.new_subject("sensor")
    updated = Observer.update_state(subject, 42)
    assert Observer.get_state(updated) == 42
  end

  test "オブザーバーに通知が届く" do
    test_pid = self()

    observer = fn name, state ->
      send(test_pid, {:notified, name, state})
    end

    subject =
      Observer.new_subject("sensor")
      |> Observer.add_observer(observer)
      |> Observer.update_state(100)

    assert_received {:notified, "sensor", 100}
    assert Observer.get_state(subject) == 100
  end

  test "オブザーバーを削除できる" do
    test_pid = self()
    observer = fn _name, state -> send(test_pid, {:notified, state}) end

    subject =
      Observer.new_subject("s")
      |> Observer.add_observer(observer)
      |> Observer.remove_observer(observer)
      |> Observer.update_state(99)

    refute_received {:notified, _}
    assert Observer.get_state(subject) == 99
  end

  test "複数のオブザーバーが通知を受ける" do
    test_pid = self()
    obs1 = fn _n, s -> send(test_pid, {:obs1, s}) end
    obs2 = fn _n, s -> send(test_pid, {:obs2, s}) end

    Observer.new_subject("multi")
    |> Observer.add_observer(obs1)
    |> Observer.add_observer(obs2)
    |> Observer.update_state("hello")

    assert_received {:obs1, "hello"}
    assert_received {:obs2, "hello"}
  end

  test "EventBus でトピック別にイベントを発行できる" do
    test_pid = self()

    bus =
      EventBus.new()
      |> EventBus.subscribe(:user_created, fn e -> send(test_pid, {:created, e}) end)
      |> EventBus.subscribe(:user_deleted, fn e -> send(test_pid, {:deleted, e}) end)

    EventBus.publish(bus, :user_created, %{id: 1})
    assert_received {:created, %{id: 1}}
    refute_received {:deleted, _}
  end
end
