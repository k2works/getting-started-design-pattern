package designpattern.composite

import Task.*

class CompositeSuite extends munit.FunSuite:

  test("Leaf タスクの所要時間を取得する") {
    val task = Task.Leaf("コーディング", 4.0)
    assertEqualsDouble(task.getTimeRequired, 4.0, 0.01)
  }

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

  test("ネストされた Composite の所要時間") {
    val subProject = Task.Composite(
      "バックエンド",
      List(
        Task.Leaf("API 設計", 2.0),
        Task.Leaf("API 実装", 8.0)
      )
    )
    val project = Task.Composite(
      "プロジェクト全体",
      List(
        subProject,
        Task.Leaf("フロントエンド", 6.0)
      )
    )
    assertEqualsDouble(project.getTimeRequired, 16.0, 0.01)
  }

  test("基本タスクの総数を取得する") {
    val project = Task.Composite(
      "プロジェクト",
      List(
        Task.Composite(
          "設計",
          List(
            Task.Leaf("要件定義", 1.0),
            Task.Leaf("アーキテクチャ", 2.0)
          )
        ),
        Task.Leaf("実装", 5.0)
      )
    )
    assertEquals(project.totalBasicTasks, 3)
  }

  test("addChild でサブタスクを追加する") {
    val project = Task.Composite("プロジェクト", List.empty)
    val updated = project.addChild(Task.Leaf("タスク1", 1.0))
    assertEquals(updated.totalBasicTasks, 1)
  }

  test("Leaf に addChild すると例外が発生する") {
    val leaf = Task.Leaf("タスク", 1.0)
    intercept[IllegalArgumentException] {
      leaf.addChild(Task.Leaf("子", 0.5))
    }
  }
