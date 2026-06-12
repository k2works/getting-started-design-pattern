module Singleton
  ( AppConfig (..)
  , DatabaseConfig (..)
  , LogLevel (..)
  , configSummary
  , defaultConfig
  , defaultDbConfig
  , enableDebug
  , logMessage
  ) where

data LogLevel = DEBUG | INFO | WARN | ERROR
  deriving (Eq, Ord, Show)

data AppConfig = AppConfig
  { appName :: String
  , appVersion :: String
  , appDebug :: Bool
  , appLogLevel :: LogLevel
  }
  deriving (Eq, Show)

data DatabaseConfig = DatabaseConfig
  { dbHost :: String
  , dbPort :: Int
  , dbName :: String
  , dbPoolSize :: Int
  }
  deriving (Eq, Show)

defaultConfig :: AppConfig
defaultConfig =
  AppConfig
    { appName = "DesignPatternApp"
    , appVersion = "1.0.0"
    , appDebug = False
    , appLogLevel = INFO
    }

defaultDbConfig :: DatabaseConfig
defaultDbConfig =
  DatabaseConfig
    { dbHost = "localhost"
    , dbPort = 5432
    , dbName = "design_pattern"
    , dbPoolSize = 10
    }

enableDebug :: AppConfig -> AppConfig
enableDebug config =
  config
    { appDebug = True
    , appLogLevel = DEBUG
    }

logMessage :: AppConfig -> LogLevel -> String -> String
logMessage config level message
  | level >= appLogLevel config =
      "[" ++ show level ++ "] " ++ appName config ++ ": " ++ message
  | otherwise = ""

configSummary :: AppConfig -> String
configSummary config =
  appName config
    ++ " v"
    ++ appVersion config
    ++ " (debug="
    ++ show (appDebug config)
    ++ ", logLevel="
    ++ show (appLogLevel config)
    ++ ")"
