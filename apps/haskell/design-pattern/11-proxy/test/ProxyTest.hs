module ProxyTest (tests) where

import Data.List (isInfixOf)
import Proxy
  ( AccessLevel (..)
  , Document (..)
  , LoggedDoc (..)
  , ProtectedDoc (..)
  , VirtualDoc (..)
  , accessDocument
  , accessWithLog
  , loadVirtualDoc
  )
import Test.HUnit

tests :: Test
tests =
    TestLabel "ProxyTest" $
    TestList
      [ TestLabel "testAccessDenied" testAccessDenied
      , TestLabel "testAccessAllowed" testAccessAllowed
      , TestLabel "testAccessWithLog" testAccessWithLog
      , TestLabel "testVirtualDocLoadsOnDemand" testVirtualDocLoadsOnDemand
      ]

secretDoc :: Document
secretDoc = Document "機密文書" "社外秘の内容"

testAccessDenied :: Test
testAccessDenied = TestCase $ do
  let protectedDoc = ProtectedDoc secretDoc Admin
  case accessDocument Guest protectedDoc of
    Right _ -> assertFailure "アクセスは拒否されるべき"
    Left err -> assertBool "エラーメッセージ" ("アクセス拒否" `isInfixOf` err)

testAccessAllowed :: Test
testAccessAllowed = TestCase $ do
  let protectedDoc = ProtectedDoc secretDoc Member
  assertEqual "十分な権限なら文書を返す" (Right secretDoc) (accessDocument Admin protectedDoc)

testAccessWithLog :: Test
testAccessWithLog = TestCase $ do
  let loggedDoc = LoggedDoc secretDoc []
      (document, updatedDoc) = accessWithLog "alice" loggedDoc
  assertEqual "文書を返す" secretDoc document
  assertEqual
    "アクセスログを末尾に追加する"
    ["alice が 機密文書 にアクセスしました"]
    (ldLog updatedDoc)

testVirtualDocLoadsOnDemand :: Test
testVirtualDocLoadsOnDemand = TestCase $ do
  let virtualDoc = VirtualDoc "遅延文書" (\title -> Document title "ロード済み本文")
  assertEqual
    "タイトルを使って文書をロードする"
    (Document "遅延文書" "ロード済み本文")
    (loadVirtualDoc virtualDoc)
