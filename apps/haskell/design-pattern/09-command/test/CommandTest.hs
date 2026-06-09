module CommandTest (tests) where

import Command
  ( CommandHistory (..)
  , FileState (..)
  , createFileCmd
  , deleteFileCmd
  , executeCmd
  , historyDescriptions
  , newHistory
  , undoCmd
  )
import Test.HUnit

tests :: Test
tests =
    TestLabel "CommandTest" $
    TestList
      [ TestLabel "testCreateFileAndUndo" testCreateFileAndUndo
      , TestLabel "testDeleteFileCommand" testDeleteFileCommand
      , TestLabel "testHistoryDescriptions" testHistoryDescriptions
      ]

testCreateFileAndUndo :: Test
testCreateFileAndUndo = TestCase $ do
  let initial = FileState []
      hist = newHistory initial
      cmd = createFileCmd "test.txt" "hello"
      hist' = executeCmd cmd hist
      hist'' = undoCmd hist'
  assertEqual
    "execute 後にファイルが追加される"
    [("test.txt", "hello")]
    (fsFiles (chState hist'))
  assertEqual "undo 後にファイルが消える" [] (fsFiles (chState hist''))

testHistoryDescriptions :: Test
testHistoryDescriptions = TestCase $ do
  let hist =
        executeCmd (createFileCmd "b.txt" "world") $
          executeCmd (createFileCmd "a.txt" "hello") $
            newHistory (FileState [])
  assertEqual
    "新しい順に説明を取得できる"
    ["ファイル作成: b.txt", "ファイル作成: a.txt"]
    (historyDescriptions hist)

testDeleteFileCommand :: Test
testDeleteFileCommand = TestCase $ do
  let initial = FileState [("a.txt", "hello"), ("b.txt", "world")]
      hist = newHistory initial
      hist' = executeCmd (deleteFileCmd "a.txt") hist
      hist'' = undoCmd hist'
  assertEqual
    "execute 後に対象ファイルが削除される"
    [("b.txt", "world")]
    (fsFiles (chState hist'))
  assertEqual
    "簡易版では undo しても削除結果は維持される"
    [("b.txt", "world")]
    (fsFiles (chState hist''))
