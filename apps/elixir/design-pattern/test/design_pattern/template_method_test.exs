defmodule DesignPattern.TemplateMethodTest do
  use ExUnit.Case
  alias DesignPattern.TemplateMethod

  test "デフォルトのテンプレートでレポートを生成する" do
    result = TemplateMethod.generate_report(["Alice", "Bob"])
    assert result == "=== Report ===\nAlice, Bob\n=== End ==="
  end

  test "HTML 形式のテンプレートでレポートを生成する" do
    result = TemplateMethod.generate_report(["Alice", "Bob"], TemplateMethod.html_steps())
    assert result =~ "<html>"
    assert result =~ "<li>Alice</li>"
    assert result =~ "</html>"
  end

  test "Markdown 形式のテンプレートでレポートを生成する" do
    result = TemplateMethod.generate_report(["Alice", "Bob"], TemplateMethod.markdown_steps())
    assert result =~ "# Report"
    assert result =~ "- Alice"
    assert result =~ "---"
  end

  test "カスタムステップを部分的に差し替えられる" do
    custom = %{header: fn data -> {"*** Custom ***", data} end}
    result = TemplateMethod.generate_report(["X"], custom)
    assert result =~ "*** Custom ***"
    assert result =~ "=== End ==="
  end

  test "空のデータでもレポートを生成できる" do
    result = TemplateMethod.generate_report([])
    assert result == "=== Report ===\n\n=== End ==="
  end
end
