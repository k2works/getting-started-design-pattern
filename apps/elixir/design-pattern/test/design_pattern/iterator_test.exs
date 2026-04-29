defmodule DesignPattern.IteratorTest do
  use ExUnit.Case
  alias DesignPattern.Iterator

  test "フィルタと変換を適用する" do
    result = Iterator.transform([1, 2, 3, 4, 5], &(rem(&1, 2) == 0), &(&1 * 10))
    assert result == [20, 40]
  end

  test "遅延評価で変換する" do
    result =
      Iterator.lazy_transform(1..100, &(rem(&1, 3) == 0), &(&1 * 2))
      |> Enum.take(3)

    assert result == [6, 12, 18]
  end

  test "カスタムレンジイテレータ" do
    result = Iterator.range_iterator(0, 10, 3) |> Enum.to_list()
    assert result == [0, 3, 6, 9]
  end

  test "チャンクごとに処理する" do
    result = Iterator.chunk_process([1, 2, 3, 4, 5, 6], 2, &Enum.sum/1)
    assert result == [3, 7, 11]
  end

  test "外部イテレータの next" do
    {:ok, head, tail} = Iterator.next([1, 2, 3])
    assert head == 1
    assert tail == [2, 3]

    {:done, []} = Iterator.next([])
  end

  test "take_until で条件まで取得する" do
    result = Iterator.take_until([1, 2, 3, 4, 5], &(&1 > 3))
    assert result == [1, 2, 3]
  end
end
