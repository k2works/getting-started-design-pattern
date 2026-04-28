module CompositeTest (tests) where

import Test.HUnit
import Composite

tests :: Test
tests = TestLabel "Composite" $ TestList
  [ testLeafTask
  , testCompositeTask
  , testNestedComposite
  , testAddSubTask
  ]

testLeafTask :: Test
testLeafTask = TestCase $ do
  let task = LeafTask "コーディング" 4.0 1
  assertEqual "名前" "コーディング" (taskName task)
  assertEqual "所要時間" 4.0 (timeRequired task)
  assertEqual "サブタスクなし" [] (subTasks task)
  assertEqual "優先度" 1 (priority task)

testCompositeTask :: Test
testCompositeTask = TestCase $ do
  let t1 = LeafTask "設計" 2.0 1
      t2 = LeafTask "実装" 4.0 2
      t3 = LeafTask "テスト" 3.0 1
      project = CompositeTask "プロジェクト" [t1, t2, t3] 1
  assertEqual "合計時間" 9.0 (timeRequired project)
  assertEqual "サブタスク数" 3 (length (subTasks project))

testNestedComposite :: Test
testNestedComposite = TestCase $ do
  let t1 = LeafTask "DB設計" 2.0 1
      t2 = LeafTask "API設計" 3.0 2
      backend = CompositeTask "バックエンド" [t1, t2] 1
      t3 = LeafTask "UI設計" 2.0 1
      frontend = CompositeTask "フロントエンド" [t3] 2
      project = CompositeTask "全体" [backend, frontend] 1
  assertEqual "合計時間" 7.0 (timeRequired project)

testAddSubTask :: Test
testAddSubTask = TestCase $ do
  let project = CompositeTask "プロジェクト" [] 1
      task = LeafTask "タスク1" 2.0 1
      updated = addSubTask task project
  assertEqual "サブタスク追加" 1 (length (subTasks updated))
  assertEqual "合計時間" 2.0 (timeRequired updated)
