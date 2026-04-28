defmodule DesignPattern.BuilderTest do
  use ExUnit.Case
  alias DesignPattern.Builder

  test "クエリをパイプラインで構築して SQL に変換する" do
    sql =
      Builder.new_query()
      |> Builder.select("name, age")
      |> Builder.from("users")
      |> Builder.where("age > 18")
      |> Builder.order_by("name")
      |> Builder.limit(10)
      |> Builder.to_sql()

    assert sql == "SELECT name, age FROM users WHERE age > 18 ORDER BY name LIMIT 10"
  end

  test "WHERE なしのクエリ" do
    sql =
      Builder.new_query()
      |> Builder.from("products")
      |> Builder.to_sql()

    assert sql == "SELECT * FROM products"
  end

  test "複数の WHERE 条件を AND で結合する" do
    sql =
      Builder.new_query()
      |> Builder.from("users")
      |> Builder.where("age > 18")
      |> Builder.where("active = true")
      |> Builder.to_sql()

    assert sql =~ "WHERE age > 18 AND active = true"
  end

  test "HTML 要素をパイプラインで構築する" do
    html =
      Builder.new_element("div")
      |> Builder.attr("class", "container")
      |> Builder.child(
        Builder.new_element("p")
        |> Builder.text("Hello")
      )
      |> Builder.to_html()

    assert html =~ "<div"
    assert html =~ "class=\"container\""
    assert html =~ "<p>Hello</p>"
    assert html =~ "</div>"
  end

  test "属性なしの HTML 要素" do
    html =
      Builder.new_element("span")
      |> Builder.text("world")
      |> Builder.to_html()

    assert html == "<span>world</span>"
  end
end
