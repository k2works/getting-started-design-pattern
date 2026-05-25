module CompositeTest (tests) where

import Composite
  ( Task (..)
  , addSubTask
  , priority
  , subTasks
  , taskName
  , timeRequired
  , totalTasks
  )
import Test.HUnit

tests :: Test
tests =
  TestLabel "CompositeTest" $
    TestList
      [ TestLabel "testNestedComposite" testNestedComposite
      , TestLabel "testTaskAccessors" testTaskAccessors
      , TestLabel "testAddSubTask" testAddSubTask
      ]

testNestedComposite :: Test
testNestedComposite = TestCase $ do
  let backend =
        CompositeTask
          "バックエンド"
          [ LeafTask "DB設計" 2.0 1
          , LeafTask "API設計" 3.0 2
          ]
          1
      frontend =
        CompositeTask
          "フロントエンド"
          [LeafTask "UI設計" 2.0 1]
          2
      project = CompositeTask "全体" [backend, frontend] 1
  assertEqual "合計時間" 7.0 (timeRequired project)
  assertEqual "合計タスク数" 3 (totalTasks project)

testTaskAccessors :: Test
testTaskAccessors = TestCase $ do
  let task = LeafTask "テスト" 1.0 3
  assertEqual "名前を取得できる" "テスト" (taskName task)
  assertEqual "優先度を取得できる" 3 (priority task)
  assertEqual "リーフのサブタスクは空" [] (subTasks task)

testAddSubTask :: Test
testAddSubTask = TestCase $ do
  let group = CompositeTask "開発" [] 1
      task1 = LeafTask "設計" 2.0 1
      task2 = LeafTask "実装" 4.0 2
      updated = addSubTask task2 (addSubTask task1 group)
  assertEqual "子タスクを追加できる" [task1, task2] (subTasks updated)
