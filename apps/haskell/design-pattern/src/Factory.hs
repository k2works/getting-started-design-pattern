-- | Factory パターン
-- ADT + スマートコンストラクタで型安全なファクトリを実現する。
-- パターンマッチで生成ロジックを分岐させる。
module Factory
  ( Animal(..)
  , AnimalType(..)
  , createAnimal
  , speak
  , habitat
  , AnimalFactory
  , defaultFactory
  , customFactory
  ) where

-- | 動物の種類
data AnimalType = DogType | CatType | DuckType
  deriving (Show, Eq)

-- | 動物の ADT
data Animal
  = Dog   { animalName :: String, animalAge :: Int }
  | Cat   { animalName :: String, animalAge :: Int }
  | Duck  { animalName :: String, animalAge :: Int }
  deriving (Show, Eq)

-- | ファクトリ関数で動物を生成
createAnimal :: AnimalType -> String -> Int -> Animal
createAnimal DogType  = Dog
createAnimal CatType  = Cat
createAnimal DuckType = Duck

-- | 鳴き声（パターンマッチ）
speak :: Animal -> String
speak (Dog name _)  = name ++ " says: ワンワン!"
speak (Cat name _)  = name ++ " says: ニャー!"
speak (Duck name _) = name ++ " says: ガーガー!"

-- | 生息地（パターンマッチ）
habitat :: Animal -> String
habitat (Dog _ _)  = "家"
habitat (Cat _ _)  = "家 / 外"
habitat (Duck _ _) = "池"

-- | ファクトリ型: カスタムファクトリも作れる
type AnimalFactory = String -> Int -> Animal

-- | デフォルトファクトリ（犬を作る）
defaultFactory :: AnimalFactory
defaultFactory = Dog

-- | カスタムファクトリ
customFactory :: AnimalType -> AnimalFactory
customFactory = createAnimal
