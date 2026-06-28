module Builder
  ( Computer (..)
  , buildGaming
  , buildOffice
  , buildServer
  , computerSummary
  , defaultComputer
  , setDisplay
  , setMemory
  , setOS
  , setStorage
  ) where

data Computer = Computer
  { cpuType :: String
  , display :: String
  , memory :: Int
  , storage :: Int
  , os :: String
  , gpu :: String
  }
  deriving (Eq, Show)

defaultComputer :: Computer
defaultComputer =
  Computer
    { cpuType = "Intel i5"
    , display = "15.6 inch"
    , memory = 8
    , storage = 256
    , os = "Linux"
    , gpu = "Integrated"
    }

setDisplay :: String -> Computer -> Computer
setDisplay value computer = computer {display = value}

setMemory :: Int -> Computer -> Computer
setMemory value computer = computer {memory = value}

setStorage :: Int -> Computer -> Computer
setStorage value computer = computer {storage = value}

setOS :: String -> Computer -> Computer
setOS value computer = computer {os = value}

buildGaming :: Computer
buildGaming =
  defaultComputer
    { cpuType = "Intel i9"
    , display = "27 inch 4K"
    , memory = 64
    , storage = 2000
    , os = "Windows"
    , gpu = "NVIDIA RTX 4090"
    }

buildOffice :: Computer
buildOffice =
  defaultComputer
    { cpuType = "Intel i3"
    , display = "24 inch"
    , memory = 16
    , storage = 512
    , os = "Windows"
    , gpu = "Integrated"
    }

buildServer :: Computer
buildServer =
  defaultComputer
    { cpuType = "AMD EPYC"
    , display = "None"
    , memory = 256
    , storage = 8000
    , os = "Linux"
    , gpu = "None"
    }

computerSummary :: Computer -> String
computerSummary computer =
  cpuType computer
    ++ " / "
    ++ display computer
    ++ " / "
    ++ show (memory computer)
    ++ "GB RAM / "
    ++ show (storage computer)
    ++ "GB SSD / "
    ++ os computer
    ++ " / GPU: "
    ++ gpu computer
