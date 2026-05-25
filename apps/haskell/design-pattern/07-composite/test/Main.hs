module Main where

import Data.List (stripPrefix)
import Data.Maybe (mapMaybe)
import System.Environment (getArgs)
import System.Exit (exitFailure, exitSuccess)
import Test.HUnit
import qualified CompositeTest

main :: IO ()
main = do
  args <- getArgs
  selectedTests <-
    case parseMatch args of
      Nothing -> pure allTests
      Just selector ->
        case selectTests (splitOnDot selector) allTests of
          Just filteredTests -> pure filteredTests
          Nothing -> do
            putStrLn ("No tests matched: " ++ selector)
            exitFailure
  testCounts <- runTestTT selectedTests
  if errors testCounts + failures testCounts == 0
    then exitSuccess
    else exitFailure

allTests :: Test
allTests = TestList [CompositeTest.tests]

parseMatch :: [String] -> Maybe String
parseMatch [] = Nothing
parseMatch (arg:rest) =
  case stripPrefix "--match=" arg of
    Just selector -> Just selector
    Nothing -> parseMatch rest

splitOnDot :: String -> [String]
splitOnDot value =
  case break (== '.') value of
    (segment, []) -> [segment]
    (segment, _:rest) -> segment : splitOnDot rest

selectTests :: [String] -> Test -> Maybe Test
selectTests [] testTree = Just testTree
selectTests (selector:selectors) (TestLabel label nestedTest)
  | label == selector =
      fmap (TestLabel label) (selectTests selectors nestedTest)
  | otherwise = Nothing
selectTests selectors (TestList testTrees) =
  case mapMaybe (selectTests selectors) testTrees of
    [] -> Nothing
    filteredTests -> Just (TestList filteredTests)
selectTests _ (TestCase _) = Nothing
