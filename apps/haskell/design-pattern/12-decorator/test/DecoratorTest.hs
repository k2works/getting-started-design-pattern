module DecoratorTest (tests) where

import Data.List (isInfixOf)
import Decorator
  ( Writer
  , applyDecorators
  , baseWriter
  , decorated
  , withChecksum
  , withLineNumber
  , withTimestamp
  )
import Test.HUnit

tests :: Test
tests =
    TestLabel "DecoratorTest" $
    TestList
      [ TestLabel "testBaseWriter" testBaseWriter
      , TestLabel "testComposedDecorators" testComposedDecorators
      , TestLabel "testApplyDecorators" testApplyDecorators
      , TestLabel "testDecoratorOrderMatters" testDecoratorOrderMatters
      ]

sampleLines :: [String]
sampleLines = ["hello", "world"]

testBaseWriter :: Test
testBaseWriter = TestCase $
  assertEqual "baseWriter は入力をそのまま返す" sampleLines (baseWriter sampleLines)

testComposedDecorators :: Test
testComposedDecorators = TestCase $ do
  let result = decorated sampleLines
  assertBool "行番号とタイムスタンプを含む" ("1: [2024-01-01] hello" `elem` result)
  assertBool "2 行目にも行番号とタイムスタンプを含む" ("2: [2024-01-01] world" `elem` result)
  assertBool "チェックサム行を追加する" ("[checksum:" `isInfixOf` last result)

testApplyDecorators :: Test
testApplyDecorators = TestCase $ do
  let writer = applyDecorators [withChecksum, withLineNumber] baseWriter
  assertEqual
    "デコレータリストを右から順に適用する"
    ["1: hello", "2: world", "[checksum:16]"]
    (writer sampleLines)

testDecoratorOrderMatters :: Test
testDecoratorOrderMatters = TestCase $ do
  let timestampThenNumber = (withLineNumber . withTimestamp "2024-01-01" $ baseWriter) sampleLines
      numberThenTimestamp = (withTimestamp "2024-01-01" . withLineNumber $ baseWriter) sampleLines
  assertEqual
    "タイムスタンプ後に行番号を付与する"
    ["1: [2024-01-01] hello", "2: [2024-01-01] world"]
    timestampThenNumber
  assertEqual
    "行番号後にタイムスタンプを付与する"
    ["[2024-01-01] 1: hello", "[2024-01-01] 2: world"]
    numberThenTimestamp

_typeCheckWriter :: Writer -> Writer
_typeCheckWriter = id
