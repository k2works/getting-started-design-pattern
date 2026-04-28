defmodule DesignPattern.Factory do
  @moduledoc """
  Factory パターン: パターンマッチングによるファクトリ関数。
  アトムやタグでオブジェクトの種類を指定し、適切な構造体を生成する。
  """

  @doc "図形を作成するファクトリ"
  def create_shape(:circle, radius) do
    %{type: :circle, radius: radius}
  end

  def create_shape(:rectangle, {width, height}) do
    %{type: :rectangle, width: width, height: height}
  end

  def create_shape(:triangle, {base, height}) do
    %{type: :triangle, base: base, height: height}
  end

  @doc "図形の面積を計算する"
  def area(%{type: :circle, radius: r}), do: :math.pi() * r * r
  def area(%{type: :rectangle, width: w, height: h}), do: w * h
  def area(%{type: :triangle, base: b, height: h}), do: b * h / 2

  @doc "図形の説明を返す"
  def describe(%{type: :circle, radius: r}), do: "Circle with radius #{r}"
  def describe(%{type: :rectangle, width: w, height: h}), do: "Rectangle #{w}x#{h}"
  def describe(%{type: :triangle, base: b, height: h}), do: "Triangle base=#{b} height=#{h}"

  @doc "接続を作成するファクトリ（設定マップから）"
  def create_connection(%{type: :http, url: url}) do
    %{type: :http, url: url, status: :ready}
  end

  def create_connection(%{type: :websocket, url: url}) do
    %{type: :websocket, url: url, status: :ready, persistent: true}
  end

  def create_connection(%{type: :tcp, host: host, port: port}) do
    %{type: :tcp, host: host, port: port, status: :ready}
  end
end
