defmodule DesignPattern.Iterator do
  @moduledoc """
  Iterator パターン: Enum/Stream モジュールによるコレクション走査。
  Elixir の Enumerable プロトコルが Iterator パターンそのもの。
  """

  @doc "フィルタ・変換・集約をパイプラインで行う"
  def transform(collection, filter_fn, map_fn) do
    collection
    |> Enum.filter(filter_fn)
    |> Enum.map(map_fn)
  end

  @doc "遅延評価で大きなコレクションを処理する"
  def lazy_transform(collection, filter_fn, map_fn) do
    collection
    |> Stream.filter(filter_fn)
    |> Stream.map(map_fn)
  end

  @doc "カスタムイテレータ: 範囲を指定してステップごとに値を生成する"
  def range_iterator(start, stop, step \\ 1) do
    Stream.unfold(start, fn
      current when current > stop -> nil
      current -> {current, current + step}
    end)
  end

  @doc "チャンクごとに処理する"
  def chunk_process(collection, chunk_size, process_fn) do
    collection
    |> Enum.chunk_every(chunk_size)
    |> Enum.map(process_fn)
  end

  @doc "外部イテレータのシミュレーション（状態を返す）"
  def next([]), do: {:done, []}
  def next([head | tail]), do: {:ok, head, tail}

  @doc "take_while でイテレーションを制御する"
  def take_until(collection, predicate) do
    Enum.take_while(collection, fn item -> not predicate.(item) end)
  end
end
