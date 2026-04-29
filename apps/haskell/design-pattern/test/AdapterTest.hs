module AdapterTest (tests) where

import Test.HUnit
import Adapter

tests :: Test
tests = TestLabel "Adapter" $ TestList
  [ testOldPrinter
  , testModernPrinterHtml
  , testModernPrinterText
  , testRenderAll
  ]

testOldPrinter :: Test
testOldPrinter = TestCase $ do
  let p = OldPrinter "報告書" "本日は晴天なり"
      result = render p
  assertBool "ヘッダを含む" ("報告書" `isIn` result)
  assertBool "ボディを含む" ("本日は晴天なり" `isIn` result)

testModernPrinterHtml :: Test
testModernPrinterHtml = TestCase $ do
  let p = ModernPrinter "レポート" "内容です" "html"
      result = render p
  assertBool "HTML タグ" ("<div>" `isIn` result)
  assertBool "タイトル" ("レポート" `isIn` result)

testModernPrinterText :: Test
testModernPrinterText = TestCase $ do
  let p = ModernPrinter "レポート" "内容です" "text"
      result = render p
  assertBool "テキスト形式" ("[レポート]" `isIn` result)

testRenderAll :: Test
testRenderAll = TestCase $ do
  let ps = [ OldPrinter "A" "aaa"
           , OldPrinter "B" "bbb"
           ]
      result = renderAll ps
  assertBool "A を含む" ("A" `isIn` result)
  assertBool "B を含む" ("B" `isIn` result)

isIn :: String -> String -> Bool
isIn needle haystack = any (isPrefixOf' needle) (tails' haystack)

isPrefixOf' :: String -> String -> Bool
isPrefixOf' [] _ = True
isPrefixOf' _ [] = False
isPrefixOf' (x:xs) (y:ys) = x == y && isPrefixOf' xs ys

tails' :: [a] -> [[a]]
tails' [] = [[]]
tails' xs@(_:xs') = xs : tails' xs'
