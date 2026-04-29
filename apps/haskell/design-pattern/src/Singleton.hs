-- | Singleton パターン
-- Haskell ではモジュールレベルの定義がシングルトン。
-- トップレベルの値は一度だけ評価される（CAF: Constant Applicative Form）。
module Singleton
  ( AppConfig(..)
  , defaultConfig
  , DatabaseConfig(..)
  , defaultDbConfig
  , LogLevel(..)
  , logMessage
  , configSummary
  ) where

-- | ログレベル
data LogLevel = DEBUG | INFO | WARN | ERROR
  deriving (Show, Eq, Ord)

-- | アプリケーション設定（シングルトン）
data AppConfig = AppConfig
  { appName    :: String
  , appVersion :: String
  , appDebug   :: Bool
  , appLogLevel :: LogLevel
  } deriving (Show, Eq)

-- | デフォルト設定（モジュールレベルの値 = シングルトン）
defaultConfig :: AppConfig
defaultConfig = AppConfig
  { appName    = "DesignPatternApp"
  , appVersion = "1.0.0"
  , appDebug   = False
  , appLogLevel = INFO
  }

-- | データベース設定
data DatabaseConfig = DatabaseConfig
  { dbHost     :: String
  , dbPort     :: Int
  , dbName     :: String
  , dbPoolSize :: Int
  } deriving (Show, Eq)

-- | デフォルト DB 設定
defaultDbConfig :: DatabaseConfig
defaultDbConfig = DatabaseConfig
  { dbHost     = "localhost"
  , dbPort     = 5432
  , dbName     = "design_pattern"
  , dbPoolSize = 10
  }

-- | ログメッセージをフォーマット
logMessage :: AppConfig -> LogLevel -> String -> String
logMessage cfg level msg
  | level >= appLogLevel cfg = "[" ++ show level ++ "] " ++ appName cfg ++ ": " ++ msg
  | otherwise = ""

-- | 設定のサマリ
configSummary :: AppConfig -> String
configSummary cfg =
  appName cfg ++ " v" ++ appVersion cfg
  ++ " (debug=" ++ show (appDebug cfg)
  ++ ", logLevel=" ++ show (appLogLevel cfg) ++ ")"
