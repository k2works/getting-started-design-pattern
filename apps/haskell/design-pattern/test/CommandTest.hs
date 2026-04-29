module CommandTest (tests) where

import Test.HUnit
import Command

tests :: Test
tests = TestLabel "Command" $ TestList
  [ testExecute
  , testUndo
  , testHistory
  , testFileCommands
  ]

testExecute :: Test
testExecute = TestCase $ do
  let initial = FileState []
      hist = newHistory initial
      cmd = createFileCmd "test.txt" "hello"
      hist' = executeCmd cmd hist
  assertEqual "ファイル作成" [("test.txt", "hello")] (fsFiles (chState hist'))

testUndo :: Test
testUndo = TestCase $ do
  let initial = FileState []
      hist = newHistory initial
      cmd = createFileCmd "test.txt" "hello"
      hist' = executeCmd cmd hist
      hist'' = undoCmd hist'
  assertEqual "undo 後" [] (fsFiles (chState hist''))

testHistory :: Test
testHistory = TestCase $ do
  let initial = FileState []
      hist = newHistory initial
      cmd1 = createFileCmd "a.txt" "aaa"
      cmd2 = createFileCmd "b.txt" "bbb"
      hist' = executeCmd cmd2 (executeCmd cmd1 hist)
      descs = historyDescriptions hist'
  assertEqual "履歴数" 2 (length descs)
  assertEqual "最新" "ファイル作成: b.txt" (head descs)

testFileCommands :: Test
testFileCommands = TestCase $ do
  let initial = FileState [("doc.txt", "old content")]
      hist = newHistory initial
      cmd = writeFileCmd "doc.txt" "old content" "new content"
      hist' = executeCmd cmd hist
  assertEqual "書き込み後" [("doc.txt", "new content")] (fsFiles (chState hist'))
  let hist'' = undoCmd hist'
  assertEqual "undo 後" [("doc.txt", "old content")] (fsFiles (chState hist''))
