module TemplateMethodTest (tests) where

import Data.List (isInfixOf)
import TemplateMethod (ReportFormat (..), generateReport, htmlFormat, plainTextFormat)
import Test.HUnit

tests :: Test
tests =
  TestLabel "TemplateMethodTest" $
    TestList
      [ TestLabel "testHtmlFormat" testHtmlFormat
      , TestLabel "testPlainTextFormat" testPlainTextFormat
      , TestLabel "testCustomFormat" testCustomFormat
      ]

testHtmlFormat :: Test
testHtmlFormat = TestCase $ do
  let result = generateReport htmlFormat "月次報告" ["順調", "問題なし"]
  assertBool "HTML 開始タグを含む" ("<html>" `isInfixOf` result)
  assertBool "タイトルを含む" ("<title>月次報告</title>" `isInfixOf` result)
  assertBool "本文行を含む" ("<p>順調</p>" `isInfixOf` result)
  assertBool "HTML 終了タグを含む" ("</html>" `isInfixOf` result)

testPlainTextFormat :: Test
testPlainTextFormat = TestCase $ do
  let result = generateReport plainTextFormat "月次報告" ["順調", "問題なし"]
  assertEqual
    "プレーンテキスト形式"
    "**** 月次報告 ****\n\n順調\n問題なし\n"
    result

testCustomFormat :: Test
testCustomFormat = TestCase $ do
  let csvFormat =
        ReportFormat
          { outputStart = \title -> title ++ "\n"
          , outputLine = \line -> line ++ ","
          , outputEnd = \_ -> "\n"
          }
  let result = generateReport csvFormat "レポート" ["A", "B", "C"]
  assertEqual "カスタムフォーマットを追加できる" "レポート\nA,B,C,\n" result
