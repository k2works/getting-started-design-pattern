module Factory
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
  ) where

data AnimalType = DogType | CatType | DuckType
  deriving (Eq, Show)

newtype Name = Name String
  deriving (Eq, Show)

newtype Age = Age Int
  deriving (Eq, Show)

data Animal
  = Dog
      { animalName :: Name
      , animalAge :: Age
      }
  | Cat
      { animalName :: Name
      , animalAge :: Age
      }
  | Duck
      { animalName :: Name
      , animalAge :: Age
      }
  deriving (Eq, Show)

type AnimalFactory = Name -> Age -> Animal

createAnimal :: AnimalType -> AnimalFactory
createAnimal DogType = Dog
createAnimal CatType = Cat
createAnimal DuckType = Duck

speak :: Animal -> String
speak (Dog (Name name) _) = name ++ " says: ワンワン!"
speak (Cat (Name name) _) = name ++ " says: ニャー!"
speak (Duck (Name name) _) = name ++ " says: ガーガー!"

habitat :: Animal -> String
habitat (Dog _ _) = "家"
habitat (Cat _ _) = "家 / 外"
habitat (Duck _ _) = "池"

defaultFactory :: AnimalFactory
defaultFactory = Dog

customFactory :: AnimalType -> AnimalFactory
customFactory = createAnimal
