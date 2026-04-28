module Main where

import Test.HUnit
import System.Exit (exitFailure, exitSuccess)

import qualified TemplateMethodTest
import qualified StrategyTest
import qualified ObserverTest
import qualified CompositeTest
import qualified IteratorPatternTest
import qualified CommandTest
import qualified AdapterTest
import qualified ProxyTest
import qualified DecoratorTest
import qualified SingletonTest
import qualified FactoryTest
import qualified BuilderTest
import qualified InterpreterTest

allTests :: Test
allTests = TestList
  [ TemplateMethodTest.tests
  , StrategyTest.tests
  , ObserverTest.tests
  , CompositeTest.tests
  , IteratorPatternTest.tests
  , CommandTest.tests
  , AdapterTest.tests
  , ProxyTest.tests
  , DecoratorTest.tests
  , SingletonTest.tests
  , FactoryTest.tests
  , BuilderTest.tests
  , InterpreterTest.tests
  ]

main :: IO ()
main = do
  counts <- runTestTT allTests
  if errors counts + failures counts == 0
    then exitSuccess
    else exitFailure
