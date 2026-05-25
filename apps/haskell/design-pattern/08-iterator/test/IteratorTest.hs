module IteratorTest (tests) where

import Iterator
  ( Account (..)
  , AccountType (..)
  , Portfolio (..)
  , accountNames
  , addAccount
  , filterByType
  , mergePortfolios
  , newPortfolio
  , sortByBalance
  , totalBalance
  )
import Test.HUnit

tests :: Test
tests =
  TestLabel "IteratorTest" $
    TestList
      [ TestLabel "testSortByBalance" testSortByBalance
      , TestLabel "testAccountNamesAndFilter" testAccountNamesAndFilter
      , TestLabel "testPortfolioOperations" testPortfolioOperations
      ]

portfolio :: Portfolio
portfolio =
  Portfolio
    [ Account "普通預金" Savings 100000.0
    , Account "当座預金" Checking 50000.0
    , Account "投資口座" Investment 200000.0
    ]

testSortByBalance :: Test
testSortByBalance = TestCase $ do
  let sorted = sortByBalance portfolio
  case (sorted, reverse sorted) of
    (lowest : _, highest : _) -> do
      assertEqual "最小残高" 50000.0 (acctBalance lowest)
      assertEqual "最大残高" 200000.0 (acctBalance highest)
    _ -> assertFailure "口座が並び替えられていません"

testAccountNamesAndFilter :: Test
testAccountNamesAndFilter = TestCase $ do
  assertEqual
    "口座名を列挙できる"
    ["普通預金", "当座預金", "投資口座"]
    (accountNames portfolio)
  assertEqual
    "種別で絞り込める"
    [Account "普通預金" Savings 100000.0]
    (filterByType Savings portfolio)
  assertEqual "合計残高" 350000.0 (totalBalance portfolio)

testPortfolioOperations :: Test
testPortfolioOperations = TestCase $ do
  let portfolioA =
        addAccount (Account "預金A" Savings 100000.0) newPortfolio
      portfolioB =
        addAccount (Account "投資B" Investment 200000.0) newPortfolio
      merged = mergePortfolios portfolioA portfolioB
  assertEqual "追加順で名前を取得できる" ["預金A"] (accountNames portfolioA)
  assertEqual "統合後の合計残高" 300000.0 (totalBalance merged)
