module IteratorPatternTest (tests) where

import Test.HUnit
import IteratorPattern

tests :: Test
tests = TestLabel "IteratorPattern" $ TestList
  [ testTotalBalance
  , testFilterByType
  , testAccountNames
  , testSortByBalance
  , testMerge
  ]

portfolio :: Portfolio
portfolio = addAccount (Account "普通預金" Savings 100000.0)
          . addAccount (Account "当座預金" Checking 50000.0)
          . addAccount (Account "投資口座" Investment 200000.0)
          $ newPortfolio

testTotalBalance :: Test
testTotalBalance = TestCase $
  assertEqual "合計残高" 350000.0 (totalBalance portfolio)

testFilterByType :: Test
testFilterByType = TestCase $ do
  let savings = filterByType Savings portfolio
  assertEqual "普通預金数" 1 (length savings)
  assertEqual "名前" "普通預金" (acctName (head savings))

testAccountNames :: Test
testAccountNames = TestCase $ do
  let names = accountNames portfolio
  assertEqual "口座名リスト" ["投資口座", "当座預金", "普通預金"] names

testSortByBalance :: Test
testSortByBalance = TestCase $ do
  let sorted = sortByBalance portfolio
  assertEqual "最小残高" 50000.0 (acctBalance (head sorted))
  assertEqual "最大残高" 200000.0 (acctBalance (last sorted))

testMerge :: Test
testMerge = TestCase $ do
  let p2 = addAccount (Account "外貨預金" Savings 300000.0) newPortfolio
      merged = mergePortfolios portfolio p2
  assertEqual "統合後口座数" 4 (length (accounts merged))
  assertEqual "統合後合計" 650000.0 (totalBalance merged)
