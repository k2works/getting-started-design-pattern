module SingletonTest (tests) where

import Test.HUnit
import Singleton

tests :: Test
tests = TestLabel "Singleton" $ TestList
  [ testDefaultConfig
  , testDbConfig
  , testLogMessage
  , testConfigSummary
  , testLogLevelFilter
  ]

testDefaultConfig :: Test
testDefaultConfig = TestCase $ do
  assertEqual "アプリ名" "DesignPatternApp" (appName defaultConfig)
  assertEqual "バージョン" "1.0.0" (appVersion defaultConfig)
  assertEqual "デバッグ" False (appDebug defaultConfig)

testDbConfig :: Test
testDbConfig = TestCase $ do
  assertEqual "ホスト" "localhost" (dbHost defaultDbConfig)
  assertEqual "ポート" 5432 (dbPort defaultDbConfig)
  assertEqual "プールサイズ" 10 (dbPoolSize defaultDbConfig)

testLogMessage :: Test
testLogMessage = TestCase $ do
  let msg = logMessage defaultConfig WARN "警告です"
  assertBool "WARN レベル" ("WARN" `isIn` msg)
  assertBool "メッセージ" ("警告です" `isIn` msg)

testConfigSummary :: Test
testConfigSummary = TestCase $ do
  let summary = configSummary defaultConfig
  assertBool "アプリ名を含む" ("DesignPatternApp" `isIn` summary)
  assertBool "バージョンを含む" ("1.0.0" `isIn` summary)

testLogLevelFilter :: Test
testLogLevelFilter = TestCase $ do
  let msg = logMessage defaultConfig DEBUG "デバッグ"
  assertEqual "DEBUG は INFO 以下なので空" "" msg

isIn :: String -> String -> Bool
isIn needle haystack = any (isPrefixOf' needle) (tails' haystack)

isPrefixOf' :: String -> String -> Bool
isPrefixOf' [] _ = True
isPrefixOf' _ [] = False
isPrefixOf' (x:xs) (y:ys) = x == y && isPrefixOf' xs ys

tails' :: [a] -> [[a]]
tails' [] = [[]]
tails' xs@(_:xs') = xs : tails' xs'
