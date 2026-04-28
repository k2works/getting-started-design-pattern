-- | Builder パターン
-- レコード構文のデフォルト値 + 更新関数で段階的に構築する。
-- Haskell のレコード更新構文がビルダーの役割を果たす。
module Builder
  ( Computer(..)
  , defaultComputer
  , setDisplay
  , setMemory
  , setStorage
  , setOS
  , buildGaming
  , buildOffice
  , buildServer
  , computerSummary
  ) where

-- | コンピュータ
data Computer = Computer
  { cpuType    :: String
  , display    :: String
  , memory     :: Int     -- ^ GB
  , storage    :: Int     -- ^ GB
  , os         :: String
  , gpu        :: String
  } deriving (Show, Eq)

-- | デフォルトのコンピュータ
defaultComputer :: Computer
defaultComputer = Computer
  { cpuType = "Intel i5"
  , display = "15.6 inch"
  , memory  = 8
  , storage = 256
  , os      = "Linux"
  , gpu     = "Integrated"
  }

-- | ディスプレイを設定
setDisplay :: String -> Computer -> Computer
setDisplay d c = c { display = d }

-- | メモリを設定
setMemory :: Int -> Computer -> Computer
setMemory m c = c { memory = m }

-- | ストレージを設定
setStorage :: Int -> Computer -> Computer
setStorage s c = c { storage = s }

-- | OS を設定
setOS :: String -> Computer -> Computer
setOS o c = c { os = o }

-- | ゲーミング PC を構築
buildGaming :: Computer
buildGaming = defaultComputer
  { cpuType = "Intel i9"
  , display = "27 inch 4K"
  , memory  = 64
  , storage = 2000
  , os      = "Windows"
  , gpu     = "NVIDIA RTX 4090"
  }

-- | オフィス PC を構築
buildOffice :: Computer
buildOffice = defaultComputer
  { cpuType = "Intel i3"
  , display = "24 inch"
  , memory  = 16
  , storage = 512
  , os      = "Windows"
  , gpu     = "Integrated"
  }

-- | サーバを構築
buildServer :: Computer
buildServer = defaultComputer
  { cpuType = "AMD EPYC"
  , display = "None"
  , memory  = 256
  , storage = 8000
  , os      = "Linux"
  , gpu     = "None"
  }

-- | コンピュータのサマリ
computerSummary :: Computer -> String
computerSummary c =
  cpuType c ++ " / " ++ display c
  ++ " / " ++ show (memory c) ++ "GB RAM"
  ++ " / " ++ show (storage c) ++ "GB SSD"
  ++ " / " ++ os c
  ++ " / GPU: " ++ gpu c
