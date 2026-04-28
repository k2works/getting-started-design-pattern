defmodule DesignPattern.Builder do
  @moduledoc """
  Builder パターン: パイプライン演算子 |> と Map 操作による段階的構築。
  """

  @doc "空のクエリビルダーを作成する"
  def new_query do
    %{select: "*", from: nil, where: [], order_by: nil, limit: nil}
  end

  @doc "SELECT 句を設定する"
  def select(query, fields) do
    %{query | select: fields}
  end

  @doc "FROM 句を設定する"
  def from(query, table) do
    %{query | from: table}
  end

  @doc "WHERE 条件を追加する"
  def where(query, condition) do
    %{query | where: query.where ++ [condition]}
  end

  @doc "ORDER BY を設定する"
  def order_by(query, field) do
    %{query | order_by: field}
  end

  @doc "LIMIT を設定する"
  def limit(query, n) do
    %{query | limit: n}
  end

  @doc "クエリを SQL 文字列に変換する"
  def to_sql(query) do
    parts = ["SELECT #{query.select}"]
    parts = if query.from, do: parts ++ ["FROM #{query.from}"], else: parts

    parts =
      if query.where != [] do
        parts ++ ["WHERE " <> Enum.join(query.where, " AND ")]
      else
        parts
      end

    parts = if query.order_by, do: parts ++ ["ORDER BY #{query.order_by}"], else: parts
    parts = if query.limit, do: parts ++ ["LIMIT #{query.limit}"], else: parts

    Enum.join(parts, " ")
  end

  @doc "HTML 要素ビルダーを作成する"
  def new_element(tag) do
    %{tag: tag, attributes: %{}, children: [], text: nil}
  end

  @doc "属性を追加する"
  def attr(element, key, value) do
    %{element | attributes: Map.put(element.attributes, key, value)}
  end

  @doc "テキストを設定する"
  def text(element, content) do
    %{element | text: content}
  end

  @doc "子要素を追加する"
  def child(element, child_element) do
    %{element | children: element.children ++ [child_element]}
  end

  @doc "HTML 文字列に変換する"
  def to_html(%{tag: tag, attributes: attrs, children: children, text: text_content}) do
    attr_str =
      if map_size(attrs) > 0 do
        " " <>
          Enum.map_join(attrs, " ", fn {k, v} -> "#{k}=\"#{v}\"" end)
      else
        ""
      end

    inner =
      cond do
        text_content != nil -> text_content
        children != [] -> Enum.map_join(children, "", &to_html/1)
        true -> ""
      end

    "<#{tag}#{attr_str}>#{inner}</#{tag}>"
  end
end
