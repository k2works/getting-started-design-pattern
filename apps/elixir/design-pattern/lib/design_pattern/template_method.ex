defmodule DesignPattern.TemplateMethod do
  @moduledoc """
  Template Method パターン: 高階関数によるアルゴリズムの骨格定義。
  サブステップを関数マップとして渡すことで、処理の流れを固定しつつ詳細を差し替える。
  """

  @doc """
  レポートを生成するテンプレートメソッド。
  `steps` マップで各ステップの関数を差し替えられる。
  """
  def generate_report(data, steps \\ %{}) do
    data
    |> header(steps)
    |> body(steps)
    |> footer(steps)
  end

  defp header(data, steps) do
    header_fn = Map.get(steps, :header, &default_header/1)
    header_fn.(data)
  end

  defp body({header_text, data}, steps) do
    body_fn = Map.get(steps, :body, &default_body/1)
    {header_text, body_fn.(data)}
  end

  defp footer({header_text, body_text}, steps) do
    footer_fn = Map.get(steps, :footer, &default_footer/0)
    header_text <> "\n" <> body_text <> "\n" <> footer_fn.()
  end

  defp default_header(data) do
    {"=== Report ===", data}
  end

  defp default_body(data) do
    Enum.join(data, ", ")
  end

  defp default_footer do
    "=== End ==="
  end

  @doc "HTML 形式のステップマップを返す"
  def html_steps do
    %{
      header: fn data -> {"<html><body><h1>Report</h1>", data} end,
      body: fn data -> "<ul>" <> Enum.map_join(data, "", &"<li>#{&1}</li>") <> "</ul>" end,
      footer: fn -> "</body></html>" end
    }
  end

  @doc "Markdown 形式のステップマップを返す"
  def markdown_steps do
    %{
      header: fn data -> {"# Report", data} end,
      body: fn data -> Enum.map_join(data, "\n", &"- #{&1}") end,
      footer: fn -> "---" end
    }
  end
end
