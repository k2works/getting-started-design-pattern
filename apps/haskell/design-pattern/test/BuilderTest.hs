module BuilderTest (tests) where

import Test.HUnit
import Builder

tests :: Test
tests = TestLabel "Builder" $ TestList
  [ testDefaultComputer
  , testGamingPC
  , testOfficePC
  , testServer
  , testChainedBuilding
  , testSummary
  ]

testDefaultComputer :: Test
testDefaultComputer = TestCase $ do
  assertEqual "CPU" "Intel i5" (cpuType defaultComputer)
  assertEqual "メモリ" 8 (memory defaultComputer)
  assertEqual "OS" "Linux" (os defaultComputer)

testGamingPC :: Test
testGamingPC = TestCase $ do
  assertEqual "CPU" "Intel i9" (cpuType buildGaming)
  assertEqual "メモリ" 64 (memory buildGaming)
  assertEqual "GPU" "NVIDIA RTX 4090" (gpu buildGaming)

testOfficePC :: Test
testOfficePC = TestCase $ do
  assertEqual "CPU" "Intel i3" (cpuType buildOffice)
  assertEqual "メモリ" 16 (memory buildOffice)
  assertEqual "OS" "Windows" (os buildOffice)

testServer :: Test
testServer = TestCase $ do
  assertEqual "CPU" "AMD EPYC" (cpuType buildServer)
  assertEqual "メモリ" 256 (memory buildServer)
  assertEqual "ディスプレイ" "None" (display buildServer)

testChainedBuilding :: Test
testChainedBuilding = TestCase $ do
  let custom = setOS "macOS"
             . setMemory 32
             . setDisplay "14 inch Retina"
             $ defaultComputer
  assertEqual "OS" "macOS" (os custom)
  assertEqual "メモリ" 32 (memory custom)
  assertEqual "ディスプレイ" "14 inch Retina" (display custom)

testSummary :: Test
testSummary = TestCase $ do
  let summary = computerSummary buildGaming
  assertBool "CPU を含む" ("Intel i9" `isIn` summary)
  assertBool "GPU を含む" ("RTX 4090" `isIn` summary)

isIn :: String -> String -> Bool
isIn needle haystack = any (isPrefixOf' needle) (tails' haystack)

isPrefixOf' :: String -> String -> Bool
isPrefixOf' [] _ = True
isPrefixOf' _ [] = False
isPrefixOf' (x:xs) (y:ys) = x == y && isPrefixOf' xs ys

tails' :: [a] -> [[a]]
tails' [] = [[]]
tails' xs@(_:xs') = xs : tails' xs'
