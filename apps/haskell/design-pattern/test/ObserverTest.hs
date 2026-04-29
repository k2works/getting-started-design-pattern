module ObserverTest (tests) where

import Test.HUnit
import Observer

tests :: Test
tests = TestLabel "Observer" $ TestList
  [ testIOObserver
  , testPureObserver
  , testMultipleChanges
  ]

testIOObserver :: Test
testIOObserver = TestCase $ do
  let emp = Employee "田中" 50000.0
  sys <- newObserverSystem emp
  addObserver sys (\_ -> return ())
  updateSalary sys 60000.0
  events <- getEvents sys
  assertEqual "1 つのイベント" 1 (length events)
  case head events of
    SalaryChanged name old new' -> do
      assertEqual "名前" "田中" name
      assertEqual "旧給与" 50000.0 old
      assertEqual "新給与" 60000.0 new'

testPureObserver :: Test
testPureObserver = TestCase $ do
  let subj = PureSubject "山田" 40000.0 []
      updated = changeSalary 50000.0 subj
  assertEqual "給与更新" 50000.0 (psSalary updated)
  assertEqual "ログ 1 件" 1 (length (psLog updated))
  assertBool "ログ内容" ("山田" `isIn` head (psLog updated))

testMultipleChanges :: Test
testMultipleChanges = TestCase $ do
  let subj = PureSubject "佐藤" 30000.0 []
      s1 = changeSalary 35000.0 subj
      s2 = changeSalary 40000.0 s1
  assertEqual "最終給与" 40000.0 (psSalary s2)
  assertEqual "ログ 2 件" 2 (length (psLog s2))

isIn :: String -> String -> Bool
isIn needle haystack = any (isPrefixOf' needle) (tails' haystack)

isPrefixOf' :: String -> String -> Bool
isPrefixOf' [] _ = True
isPrefixOf' _ [] = False
isPrefixOf' (x:xs) (y:ys) = x == y && isPrefixOf' xs ys

tails' :: [a] -> [[a]]
tails' [] = [[]]
tails' xs@(_:xs') = xs : tails' xs'
