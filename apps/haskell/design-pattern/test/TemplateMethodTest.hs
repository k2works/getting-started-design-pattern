module TemplateMethodTest (tests) where

import Test.HUnit
import TemplateMethod

tests :: Test
tests = TestLabel "TemplateMethod" $ TestList
  [ testHtmlFormat
  , testPlainTextFormat
  , testCustomFormat
  ]

testHtmlFormat :: Test
testHtmlFormat = TestCase $ do
  let result = generateReport htmlFormat "月次報告" ["順調", "問題なし"]
  assertBool "HTML タグを含む" ("<html>" `isInfixOf'` result)
  assertBool "タイトルを含む" ("月次報告" `isInfixOf'` result)
  assertBool "本文を含む" ("<p>順調</p>" `isInfixOf'` result)
  assertBool "閉じタグを含む" ("</html>" `isInfixOf'` result)

testPlainTextFormat :: Test
testPlainTextFormat = TestCase $ do
  let result = generateReport plainTextFormat "月次報告" ["順調", "問題なし"]
  assertBool "タイトルを含む" ("***** 月次報告 *****" `isInfixOf'` result)
  assertBool "本文を含む" ("順調" `isInfixOf'` result)

testCustomFormat :: Test
testCustomFormat = TestCase $ do
  let csvFormat = ReportFormat
        { outputStart = \t -> t ++ "\n"
        , outputLine  = \l -> l ++ ","
        , outputEnd   = \_ -> "\n"
        }
  let result = generateReport csvFormat "レポート" ["A", "B", "C"]
  assertEqual "CSV 形式" "レポート\nA,B,C,\n" result

-- | 文字列の部分一致チェック
isInfixOf' :: String -> String -> Bool
isInfixOf' needle haystack = any (isPrefixOf' needle) (tails' haystack)

isPrefixOf' :: String -> String -> Bool
isPrefixOf' [] _ = True
isPrefixOf' _ [] = False
isPrefixOf' (x:xs) (y:ys) = x == y && isPrefixOf' xs ys

tails' :: [a] -> [[a]]
tails' [] = [[]]
tails' xs@(_:xs') = xs : tails' xs'
