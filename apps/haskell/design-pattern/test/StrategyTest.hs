module StrategyTest (tests) where

import Test.HUnit
import Strategy

tests :: Test
tests = TestLabel "Strategy" $ TestList
  [ testHtmlFormatter
  , testPlainTextFormatter
  , testMarkdownFormatter
  , testSwitchStrategy
  ]

report :: Report
report = Report "月次報告" ["順調", "問題なし"]

testHtmlFormatter :: Test
testHtmlFormatter = TestCase $ do
  let result = formatReport htmlFormatter report
  assertBool "HTML タグを含む" ("<html>" `isIn` result)
  assertBool "タイトルを含む" ("月次報告" `isIn` result)

testPlainTextFormatter :: Test
testPlainTextFormatter = TestCase $ do
  let result = formatReport plainTextFormatter report
  assertBool "テキスト形式" ("***** 月次報告 *****" `isIn` result)

testMarkdownFormatter :: Test
testMarkdownFormatter = TestCase $ do
  let result = formatReport markdownFormatter report
  assertBool "Markdown 見出し" ("# 月次報告" `isIn` result)
  assertBool "Markdown リスト" ("- 順調" `isIn` result)

testSwitchStrategy :: Test
testSwitchStrategy = TestCase $ do
  let strategies = [htmlFormatter, plainTextFormatter, markdownFormatter]
      results = map (\s -> formatReport s report) strategies
  assertEqual "3 つの戦略" 3 (length results)
  assertBool "それぞれ異なる" (allDifferent results)

allDifferent :: Eq a => [a] -> Bool
allDifferent []     = True
allDifferent (x:xs) = x `notElem` xs && allDifferent xs

isIn :: String -> String -> Bool
isIn needle haystack = any (isPrefixOf' needle) (tails' haystack)

isPrefixOf' :: String -> String -> Bool
isPrefixOf' [] _ = True
isPrefixOf' _ [] = False
isPrefixOf' (x:xs) (y:ys) = x == y && isPrefixOf' xs ys

tails' :: [a] -> [[a]]
tails' [] = [[]]
tails' xs@(_:xs') = xs : tails' xs'
