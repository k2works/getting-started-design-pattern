defmodule DesignPattern.FactoryTest do
  use ExUnit.Case
  alias DesignPattern.Factory

  test "円を作成して面積を計算する" do
    circle = Factory.create_shape(:circle, 5)
    assert circle.type == :circle
    assert_in_delta Factory.area(circle), 78.54, 0.01
  end

  test "長方形を作成して面積を計算する" do
    rect = Factory.create_shape(:rectangle, {4, 6})
    assert Factory.area(rect) == 24
  end

  test "三角形を作成して面積を計算する" do
    tri = Factory.create_shape(:triangle, {10, 5})
    assert Factory.area(tri) == 25.0
  end

  test "図形の説明を返す" do
    assert Factory.describe(Factory.create_shape(:circle, 3)) == "Circle with radius 3"
    assert Factory.describe(Factory.create_shape(:rectangle, {4, 5})) == "Rectangle 4x5"
  end

  test "HTTP 接続を作成する" do
    conn = Factory.create_connection(%{type: :http, url: "https://example.com"})
    assert conn.type == :http
    assert conn.status == :ready
  end

  test "WebSocket 接続は persistent フラグを持つ" do
    conn = Factory.create_connection(%{type: :websocket, url: "wss://example.com"})
    assert conn.persistent == true
  end
end
