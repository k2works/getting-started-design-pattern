module FactoryTest (tests) where

import Test.HUnit
import Factory

tests :: Test
tests = TestLabel "Factory" $ TestList
  [ testCreateDog
  , testCreateCat
  , testCreateDuck
  , testSpeak
  , testHabitat
  , testCustomFactory
  ]

testCreateDog :: Test
testCreateDog = TestCase $ do
  let dog = createAnimal DogType "ポチ" 3
  assertEqual "名前" "ポチ" (animalName dog)
  assertEqual "年齢" 3 (animalAge dog)

testCreateCat :: Test
testCreateCat = TestCase $ do
  let cat = createAnimal CatType "タマ" 2
  assertEqual "名前" "タマ" (animalName cat)

testCreateDuck :: Test
testCreateDuck = TestCase $ do
  let duck = createAnimal DuckType "ドナルド" 5
  assertEqual "名前" "ドナルド" (animalName duck)

testSpeak :: Test
testSpeak = TestCase $ do
  let dog  = createAnimal DogType "ポチ" 3
      cat  = createAnimal CatType "タマ" 2
      duck = createAnimal DuckType "ドナルド" 5
  assertBool "犬の鳴き声" ("ワンワン" `isIn` speak dog)
  assertBool "猫の鳴き声" ("ニャー" `isIn` speak cat)
  assertBool "鴨の鳴き声" ("ガーガー" `isIn` speak duck)

testHabitat :: Test
testHabitat = TestCase $ do
  let dog = createAnimal DogType "ポチ" 3
  assertEqual "犬の住処" "家" (habitat dog)

testCustomFactory :: Test
testCustomFactory = TestCase $ do
  let factory = customFactory CatType
      cat = factory "ミケ" 1
  assertEqual "カスタムファクトリ" "ミケ" (animalName cat)
  assertBool "猫" ("ニャー" `isIn` speak cat)

isIn :: String -> String -> Bool
isIn needle haystack = any (isPrefixOf' needle) (tails' haystack)

isPrefixOf' :: String -> String -> Bool
isPrefixOf' [] _ = True
isPrefixOf' _ [] = False
isPrefixOf' (x:xs) (y:ys) = x == y && isPrefixOf' xs ys

tails' :: [a] -> [[a]]
tails' [] = [[]]
tails' xs@(_:xs') = xs : tails' xs'
