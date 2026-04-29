defmodule DesignPattern.Adapter do
  @moduledoc """
  Adapter パターン: Protocol と defimpl によるインターフェース適合。
  異なるデータ構造に共通のインターフェースを提供する。
  """
end

defprotocol DesignPattern.Adapter.Printable do
  @moduledoc "印刷可能なインターフェースを定義するプロトコル"
  @doc "文字列として整形する"
  def format(data)
end

defmodule DesignPattern.Adapter.CsvData do
  @moduledoc "CSV 形式のデータ"
  defstruct rows: []
end

defmodule DesignPattern.Adapter.JsonData do
  @moduledoc "JSON 形式のデータ"
  defstruct entries: %{}
end

defmodule DesignPattern.Adapter.XmlData do
  @moduledoc "XML 形式のデータ"
  defstruct elements: []
end

defimpl DesignPattern.Adapter.Printable, for: DesignPattern.Adapter.CsvData do
  def format(%{rows: rows}) do
    Enum.map_join(rows, "\n", fn row -> Enum.join(row, ",") end)
  end
end

defimpl DesignPattern.Adapter.Printable, for: DesignPattern.Adapter.JsonData do
  def format(%{entries: entries}) do
    entries
    |> Enum.map_join(", ", fn {k, v} -> "#{k}: #{v}" end)
    |> then(&"{#{&1}}")
  end
end

defimpl DesignPattern.Adapter.Printable, for: DesignPattern.Adapter.XmlData do
  def format(%{elements: elements}) do
    elements
    |> Enum.map_join("\n", fn {tag, value} -> "<#{tag}>#{value}</#{tag}>" end)
    |> then(&"<root>\n#{&1}\n</root>")
  end
end
