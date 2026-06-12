module SingletonTest (tests) where

import Singleton
  ( AppConfig (..)
  , DatabaseConfig (..)
  , LogLevel (..)
  , configSummary
  , defaultConfig
  , defaultDbConfig
  , enableDebug
  , logMessage
  )
import Test.HUnit

tests :: Test
tests =
    TestLabel "SingletonTest" $
    TestList
      [ TestLabel "testDefaultConfig" testDefaultConfig
      , TestLabel "testEnableDebug" testEnableDebug
      , TestLabel "testLogMessage" testLogMessage
      , TestLabel "testConfigSummary" testConfigSummary
      , TestLabel "testDefaultDbConfig" testDefaultDbConfig
      ]

testDefaultConfig :: Test
testDefaultConfig = TestCase $ do
  assertEqual "アプリ名" "DesignPatternApp" (appName defaultConfig)
  assertEqual "バージョン" "1.0.0" (appVersion defaultConfig)
  assertEqual "debug は無効" False (appDebug defaultConfig)
  assertEqual "デフォルトログレベル" INFO (appLogLevel defaultConfig)

testEnableDebug :: Test
testEnableDebug = TestCase $ do
  let debugConfig = enableDebug defaultConfig
  assertEqual "debug を有効化する" True (appDebug debugConfig)
  assertEqual "ログレベルを DEBUG にする" DEBUG (appLogLevel debugConfig)
  assertEqual "元の設定は変化しない" False (appDebug defaultConfig)

testLogMessage :: Test
testLogMessage = TestCase $ do
  assertEqual
    "INFO は出力される"
    "[INFO] DesignPatternApp: 起動しました"
    (logMessage defaultConfig INFO "起動しました")
  assertEqual
    "DEBUG はフィルタされる"
    ""
    (logMessage defaultConfig DEBUG "デバッグ情報")
  assertEqual
    "ERROR は出力される"
    "[ERROR] DesignPatternApp: エラー発生"
    (logMessage defaultConfig ERROR "エラー発生")

testConfigSummary :: Test
testConfigSummary = TestCase $
  assertEqual
    "設定概要を 1 行で表示する"
    "DesignPatternApp v1.0.0 (debug=False, logLevel=INFO)"
    (configSummary defaultConfig)

testDefaultDbConfig :: Test
testDefaultDbConfig = TestCase $ do
  assertEqual "DB ホスト" "localhost" (dbHost defaultDbConfig)
  assertEqual "DB ポート" 5432 (dbPort defaultDbConfig)
  assertEqual "DB 名" "design_pattern" (dbName defaultDbConfig)
  assertEqual "DB プールサイズ" 10 (dbPoolSize defaultDbConfig)
