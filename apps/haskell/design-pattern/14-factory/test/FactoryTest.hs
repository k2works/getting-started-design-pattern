module FactoryTest (tests) where

import Data.List (isInfixOf)
import Factory
  ( Animal (..)
  , AnimalFactory
  , AnimalType (..)
  , Age (..)
  , Name (..)
  , createAnimal
  , customFactory
  , defaultFactory
  , habitat
  , speak
  )
import Test.HUnit

tests :: Test
tests =
    TestLabel "FactoryTest" $
    TestList
      [ TestLabel "testCreateAnimal" testCreateAnimal
      , TestLabel "testSpeak" testSpeak
      , TestLabel "testHabitat" testHabitat
      , TestLabel "testDefaultFactory" testDefaultFactory
      , TestLabel "testCustomFactory" testCustomFactory
      ]

testCreateAnimal :: Test
testCreateAnimal = TestCase $ do
  assertEqual "犬を生成する" (Dog (Name "ポチ") (Age 3)) (createAnimal DogType (Name "ポチ") (Age 3))
  assertEqual "猫を生成する" (Cat (Name "ミケ") (Age 2)) (createAnimal CatType (Name "ミケ") (Age 2))
  assertEqual "鴨を生成する" (Duck (Name "ドナルド") (Age 5)) (createAnimal DuckType (Name "ドナルド") (Age 5))

testSpeak :: Test
testSpeak = TestCase $ do
  let dog = createAnimal DogType (Name "ポチ") (Age 3)
      cat = createAnimal CatType (Name "ミケ") (Age 2)
      duck = createAnimal DuckType (Name "ドナルド") (Age 5)
  assertBool "犬の鳴き声" ("ワンワン" `isInfixOf` speak dog)
  assertEqual "猫の鳴き声" "ミケ says: ニャー!" (speak cat)
  assertEqual "鴨の鳴き声" "ドナルド says: ガーガー!" (speak duck)

testHabitat :: Test
testHabitat = TestCase $ do
  assertEqual "犬の生息地" "家" (habitat (createAnimal DogType (Name "ポチ") (Age 3)))
  assertEqual "猫の生息地" "家 / 外" (habitat (createAnimal CatType (Name "ミケ") (Age 2)))
  assertEqual "鴨の生息地" "池" (habitat (createAnimal DuckType (Name "ドナルド") (Age 5)))

testDefaultFactory :: Test
testDefaultFactory = TestCase $ do
  let factory :: AnimalFactory
      factory = defaultFactory
  assertEqual "デフォルトファクトリは犬を生成する" (Dog (Name "タロウ") (Age 2)) (factory (Name "タロウ") (Age 2))

testCustomFactory :: Test
testCustomFactory = TestCase $ do
  let catFactory = customFactory CatType
      cat = catFactory (Name "ミケ") (Age 3)
  assertEqual "カスタムファクトリは指定種別を生成する" (Cat (Name "ミケ") (Age 3)) cat
  assertEqual "生成した猫は猫の鳴き声を持つ" "ミケ says: ニャー!" (speak cat)
