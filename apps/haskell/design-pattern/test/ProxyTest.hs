module ProxyTest (tests) where

import Test.HUnit
import Proxy

tests :: Test
tests = TestLabel "Proxy" $ TestList
  [ testAccessGranted
  , testAccessDenied
  , testVirtualProxy
  , testLoggedProxy
  ]

doc :: Document
doc = Document "機密文書" "極秘情報です"

testAccessGranted :: Test
testAccessGranted = TestCase $ do
  let pd = ProtectedDoc doc Admin
  case accessDocument Admin pd of
    Right d  -> assertEqual "アクセス許可" doc d
    Left err -> assertFailure ("アクセスできるべき: " ++ err)

testAccessDenied :: Test
testAccessDenied = TestCase $ do
  let pd = ProtectedDoc doc Admin
  case accessDocument Guest pd of
    Right _  -> assertFailure "アクセスは拒否されるべき"
    Left err -> assertBool "エラーメッセージ" ("アクセス拒否" `isIn` err)

testVirtualProxy :: Test
testVirtualProxy = TestCase $ do
  let loader title = Document title ("内容: " ++ title)
      vd = VirtualDoc "テスト文書" loader
      loaded = loadDocument vd
  assertEqual "タイトル" "テスト文書" (docTitle loaded)
  assertEqual "内容" "内容: テスト文書" (docContent loaded)

testLoggedProxy :: Test
testLoggedProxy = TestCase $ do
  let ld = LoggedDoc doc []
      (d, ld') = accessWithLog "田中" ld
  assertEqual "ドキュメント" doc d
  assertEqual "ログ 1 件" 1 (length (ldLog ld'))
  assertBool "ログ内容" ("田中" `isIn` head (ldLog ld'))

isIn :: String -> String -> Bool
isIn needle haystack = any (isPrefixOf' needle) (tails' haystack)

isPrefixOf' :: String -> String -> Bool
isPrefixOf' [] _ = True
isPrefixOf' _ [] = False
isPrefixOf' (x:xs) (y:ys) = x == y && isPrefixOf' xs ys

tails' :: [a] -> [[a]]
tails' [] = [[]]
tails' xs@(_:xs') = xs : tails' xs'
