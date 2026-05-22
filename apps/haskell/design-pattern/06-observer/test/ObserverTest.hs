module ObserverTest (tests) where

import Observer (PureSubject (..), changeSalary)
import Test.HUnit

tests :: Test
tests =
  TestLabel "ObserverTest" $
    TestList
      [ TestLabel "testPureObserver" testPureObserver
      , TestLabel "testSalaryChangeMessage" testSalaryChangeMessage
      ]

testPureObserver :: Test
testPureObserver = TestCase $ do
  let subject = PureSubject "山田" 40000.0 []
      updated = changeSalary 50000.0 subject
  assertEqual "給与更新" 50000.0 (psSalary updated)
  assertEqual "ログ 1 件" 1 (length (psLog updated))

testSalaryChangeMessage :: Test
testSalaryChangeMessage = TestCase $ do
  let subject = PureSubject "山田" 40000.0 []
      updated = changeSalary 50000.0 subject
  assertEqual
    "変更内容をログに残す"
    ["山田 の給与が 40000.0 から 50000.0 に変更されました"]
    (psLog updated)
