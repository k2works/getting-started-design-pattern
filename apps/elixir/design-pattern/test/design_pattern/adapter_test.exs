defmodule DesignPattern.AdapterTest do
  use ExUnit.Case
  alias DesignPattern.Adapter.{Printable, CsvData, JsonData, XmlData}

  test "CSV データをフォーマットする" do
    csv = %CsvData{rows: [["name", "age"], ["Alice", "30"]]}
    result = Printable.format(csv)
    assert result == "name,age\nAlice,30"
  end

  test "JSON データをフォーマットする" do
    json = %JsonData{entries: %{name: "Alice", age: 30}}
    result = Printable.format(json)
    assert result =~ "name: Alice"
    assert result =~ "age: 30"
    assert String.starts_with?(result, "{")
    assert String.ends_with?(result, "}")
  end

  test "XML データをフォーマットする" do
    xml = %XmlData{elements: [{:name, "Alice"}, {:age, 30}]}
    result = Printable.format(xml)
    assert result =~ "<root>"
    assert result =~ "<name>Alice</name>"
    assert result =~ "<age>30</age>"
    assert result =~ "</root>"
  end

  test "空の CSV データでもフォーマットできる" do
    csv = %CsvData{rows: []}
    assert Printable.format(csv) == ""
  end

  test "異なる型で同じプロトコルが使える" do
    data_list = [
      %CsvData{rows: [["a"]]},
      %JsonData{entries: %{a: 1}},
      %XmlData{elements: [{:a, 1}]}
    ]

    results = Enum.map(data_list, &Printable.format/1)
    assert length(results) == 3
    assert Enum.all?(results, &is_binary/1)
  end
end
