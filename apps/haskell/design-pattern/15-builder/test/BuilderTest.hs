module BuilderTest (tests) where

import Builder
  ( Computer (..)
  , buildGaming
  , buildOffice
  , buildServer
  , computerSummary
  , defaultComputer
  , setDisplay
  , setMemory
  , setOS
  , setStorage
  )
import Test.HUnit

tests :: Test
tests =
    TestLabel "BuilderTest" $
    TestList
      [ TestLabel "testDefaultComputer" testDefaultComputer
      , TestLabel "testChainedBuilding" testChainedBuilding
      , TestLabel "testSetStorage" testSetStorage
      , TestLabel "testPresetBuilders" testPresetBuilders
      , TestLabel "testComputerSummary" testComputerSummary
      ]

testDefaultComputer :: Test
testDefaultComputer = TestCase $ do
  assertEqual "CPU" "Intel i5" (cpuType defaultComputer)
  assertEqual "display" "15.6 inch" (display defaultComputer)
  assertEqual "memory" 8 (memory defaultComputer)
  assertEqual "storage" 256 (storage defaultComputer)
  assertEqual "OS" "Linux" (os defaultComputer)
  assertEqual "GPU" "Integrated" (gpu defaultComputer)

testChainedBuilding :: Test
testChainedBuilding = TestCase $ do
  let custom =
        setOS "macOS"
          . setMemory 32
          . setDisplay "14 inch Retina"
          $ defaultComputer
  assertEqual "OS" "macOS" (os custom)
  assertEqual "メモリ" 32 (memory custom)
  assertEqual "ディスプレイ" "14 inch Retina" (display custom)
  assertEqual "元の構成は変化しない" 8 (memory defaultComputer)

testSetStorage :: Test
testSetStorage = TestCase $ do
  let custom = setStorage 1000 . setMemory 32 $ defaultComputer
  assertEqual "ストレージ" 1000 (storage custom)
  assertEqual "メモリ" 32 (memory custom)

testPresetBuilders :: Test
testPresetBuilders = TestCase $ do
  assertEqual "ゲーミング CPU" "Intel i9" (cpuType buildGaming)
  assertEqual "ゲーミング GPU" "NVIDIA RTX 4090" (gpu buildGaming)
  assertEqual "オフィス メモリ" 16 (memory buildOffice)
  assertEqual "サーバ ディスプレイ" "None" (display buildServer)
  assertEqual "サーバ ストレージ" 8000 (storage buildServer)

testComputerSummary :: Test
testComputerSummary = TestCase $
  assertEqual
    "構成サマリ"
    "Intel i9 / 27 inch 4K / 64GB RAM / 2000GB SSD / Windows / GPU: NVIDIA RTX 4090"
    (computerSummary buildGaming)
