module AdapterTest (tests) where

import Adapter
  ( ModernPrinter (..)
  , OldPrinter (..)
  , render
  , renderAll
  )
import Data.List (isInfixOf)
import Test.HUnit

tests :: Test
tests =
    TestLabel "AdapterTest" $
    TestList
      [ TestLabel "testOldPrinterRender" testOldPrinterRender
      , TestLabel "testModernPrinterTextRender" testModernPrinterTextRender
      , TestLabel "testModernPrinterHtmlRender" testModernPrinterHtmlRender
      , TestLabel "testRenderAllOldPrinters" testRenderAllOldPrinters
      ]

testOldPrinterRender :: Test
testOldPrinterRender = TestCase $ do
  let printer = OldPrinter "報告書" "本日は晴天なり"
      result = render printer
  assertBool "ヘッダを含む" ("報告書" `isInfixOf` result)
  assertBool "本文を含む" ("本日は晴天なり" `isInfixOf` result)
  assertEqual "旧式プリンタ形式で描画する" "=== 報告書 ===\n本日は晴天なり\n" result

testModernPrinterTextRender :: Test
testModernPrinterTextRender = TestCase $ do
  let printer = ModernPrinter "記事" "本文" "text"
  assertEqual "テキスト形式で描画する" "[記事] 本文" (render printer)

testModernPrinterHtmlRender :: Test
testModernPrinterHtmlRender = TestCase $ do
  let printer = ModernPrinter "記事" "本文" "html"
  assertEqual
    "HTML 形式で描画する"
    "<article><h1>記事</h1><p>本文</p></article>"
    (render printer)

testRenderAllOldPrinters :: Test
testRenderAllOldPrinters = TestCase $ do
  let printers =
        [ OldPrinter "報告書1" "内容A"
        , OldPrinter "報告書2" "内容B"
        ]
  assertEqual
    "同じ Renderable 型のリストをまとめて描画する"
    "=== 報告書1 ===\n内容A\n=== 報告書2 ===\n内容B\n"
    (renderAll printers)
