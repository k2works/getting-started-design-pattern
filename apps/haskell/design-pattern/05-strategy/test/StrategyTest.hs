module StrategyTest (tests) where

import Data.List (isInfixOf, nub)
import Strategy
  ( Report (..)
  , formatReport
  , htmlFormatter
  , markdownFormatter
  , plainTextFormatter
  )
import Test.HUnit

tests :: Test
tests =
  TestLabel "StrategyTest" $
    TestList
      [ TestLabel "testHtmlFormatter" testHtmlFormatter
      , TestLabel "testMarkdownFormatter" testMarkdownFormatter
      , TestLabel "testSwitchStrategy" testSwitchStrategy
      ]

sampleReport :: Report
sampleReport =
  Report
    { reportTitle = "月次報告"
    , reportBody = ["順調", "問題なし"]
    }

testHtmlFormatter :: Test
testHtmlFormatter = TestCase $ do
  let result = formatReport htmlFormatter sampleReport
  assertBool "HTML 開始タグを含む" ("<html>" `isInfixOf` result)
  assertBool "HTML タイトルを含む" ("<title>月次報告</title>" `isInfixOf` result)

testMarkdownFormatter :: Test
testMarkdownFormatter = TestCase $ do
  let result = formatReport markdownFormatter sampleReport
  assertEqual
    "Markdown 形式"
    "# 月次報告\n\n- 順調\n- 問題なし\n"
    result

testSwitchStrategy :: Test
testSwitchStrategy = TestCase $ do
  let strategies = [htmlFormatter, plainTextFormatter, markdownFormatter]
      results = map (\formatter -> formatReport formatter sampleReport) strategies
  assertEqual "3 つの戦略を選べる" 3 (length results)
  assertEqual "すべて異なる結果になる" 3 (length (nub results))
