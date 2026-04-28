defmodule DesignPatternTest do
  use ExUnit.Case
  doctest DesignPattern

  test "greets the world" do
    assert DesignPattern.hello() == :world
  end
end
