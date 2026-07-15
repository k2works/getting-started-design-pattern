import munit.FunSuite

class CompositeSuite extends FunSuite:
  test("Composite タスクの所要時間は子タスクの合計") {
    val composite = Task.Composite(
      "プロジェクト",
      List(
        Task.Leaf("設計", 2.0),
        Task.Leaf("実装", 5.0),
        Task.Leaf("テスト", 3.0)
      )
    )

    assertEqualsDouble(composite.getTimeRequired, 10.0, 0.01)
  }
  test("Composite タスクの基本タスク数は子孫を含めた合計") {
    val project = Task.Composite(
      "プロジェクト",
      List(
        Task.Leaf("設計", 2.0),
        Task.Composite(
          "開発",
          List(
            Task.Leaf("実装", 5.0),
            Task.Leaf("テスト", 3.0)
          )
        )
      )
    )

    assertEquals(project.totalBasicTasks, 3)
  }

  test("addChild でサブタスクを追加する") {
    val project = Task.Composite("プロジェクト", List.empty)
    val updated = project.addChild(Task.Leaf("タスク1", 1.0))

    assertEquals(updated.totalBasicTasks, 1)
    assertEquals(project.totalBasicTasks, 0)
  }

  test("Leaf に addChild すると例外が発生する") {
    val leaf = Task.Leaf("タスク", 1.0)

    intercept[IllegalArgumentException] {
      leaf.addChild(Task.Leaf("子", 0.5))
    }
  }
