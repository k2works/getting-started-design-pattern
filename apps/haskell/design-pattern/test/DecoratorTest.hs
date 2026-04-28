module DecoratorTest (tests) where

import Test.HUnit
import Decorator

tests :: Test
tests = TestLabel "Decorator" $ TestList
  [ testBaseWriter
  , testWithTimestamp
  , testWithLineNumber
  , testWithChecksum
  , testComposed
  , testApplyDecorators
  ]

sampleLines :: [String]
sampleLines = ["hello", "world"]

testBaseWriter :: Test
testBaseWriter = TestCase $
  assertEqual "そのまま" sampleLines (baseWriter sampleLines)

testWithTimestamp :: Test
testWithTimestamp = TestCase $ do
  let writer = withTimestamp "2024-01-01" baseWriter
      result = writer sampleLines
  assertEqual "タイムスタンプ付き" "[2024-01-01] hello" (head result)

testWithLineNumber :: Test
testWithLineNumber = TestCase $ do
  let writer = withLineNumber baseWriter
      result = writer sampleLines
  assertEqual "行番号付き" "1: hello" (head result)
  assertEqual "行番号 2" "2: world" (result !! 1)

testWithChecksum :: Test
testWithChecksum = TestCase $ do
  let writer = withChecksum baseWriter
      result = writer sampleLines
  assertEqual "元の行数 + 1" 3 (length result)
  assertBool "チェックサム" ("[checksum:" `isIn` last result)

testComposed :: Test
testComposed = TestCase $ do
  let result = decorated sampleLines
  assertBool "行番号 + タイムスタンプ" ("1: [2024-01-01]" `isIn` head result)
  assertBool "チェックサム" ("[checksum:" `isIn` last result)

testApplyDecorators :: Test
testApplyDecorators = TestCase $ do
  let decs = [withChecksum, withLineNumber]
      writer = applyDecorators decs baseWriter
      result = writer sampleLines
  assertEqual "行番号付き" "1: hello" (head result)
  assertBool "チェックサム" ("[checksum:" `isIn` last result)

isIn :: String -> String -> Bool
isIn needle haystack = any (isPrefixOf' needle) (tails' haystack)

isPrefixOf' :: String -> String -> Bool
isPrefixOf' [] _ = True
isPrefixOf' _ [] = False
isPrefixOf' (x:xs) (y:ys) = x == y && isPrefixOf' xs ys

tails' :: [a] -> [[a]]
tails' [] = [[]]
tails' xs@(_:xs') = xs : tails' xs'
