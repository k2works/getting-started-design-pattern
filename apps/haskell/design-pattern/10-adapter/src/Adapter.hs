module Adapter
  ( ModernPrinter (..)
  , OldPrinter (..)
  , Renderable (..)
  , renderAll
  ) where

data OldPrinter = OldPrinter
  { opHeader :: String
  , opBody :: String
  }
  deriving (Eq, Show)

data ModernPrinter = ModernPrinter
  { mpTitle :: String
  , mpContent :: String
  , mpFormat :: String
  }
  deriving (Eq, Show)

class Renderable a where
  render :: a -> String

instance Renderable OldPrinter where
  render printer =
    "=== " ++ opHeader printer ++ " ===\n"
      ++ opBody printer ++ "\n"

instance Renderable ModernPrinter where
  render printer
    | mpFormat printer == "html" =
        "<article><h1>"
          ++ mpTitle printer
          ++ "</h1><p>"
          ++ mpContent printer
          ++ "</p></article>"
    | otherwise =
        "[" ++ mpTitle printer ++ "] " ++ mpContent printer

renderAll :: Renderable a => [a] -> String
renderAll = concatMap render
