module Iterator
  ( Account (..)
  , AccountType (..)
  , Portfolio (..)
  , newPortfolio
  , sortByBalance
  , accountNames
  , filterByType
  , totalBalance
  , addAccount
  , mergePortfolios
  ) where

import Data.List (sortBy)
import Data.Ord (comparing)

data AccountType
  = Savings
  | Checking
  | Investment
  deriving (Eq, Show)

data Account = Account
  { acctName :: String
  , acctType :: AccountType
  , acctBalance :: Double
  }
  deriving (Eq, Show)

newtype Portfolio = Portfolio
  { accounts :: [Account]
  }
  deriving (Eq, Show)

newPortfolio :: Portfolio
newPortfolio = Portfolio []

sortByBalance :: Portfolio -> [Account]
sortByBalance = sortBy (comparing acctBalance) . accounts

accountNames :: Portfolio -> [String]
accountNames = map acctName . accounts

filterByType :: AccountType -> Portfolio -> [Account]
filterByType target = filter (\account -> acctType account == target) . accounts

totalBalance :: Portfolio -> Double
totalBalance = sum . map acctBalance . accounts

addAccount :: Account -> Portfolio -> Portfolio
addAccount account (Portfolio existingAccounts) =
  Portfolio (existingAccounts ++ [account])

mergePortfolios :: Portfolio -> Portfolio -> Portfolio
mergePortfolios (Portfolio leftAccounts) (Portfolio rightAccounts) =
  Portfolio (leftAccounts ++ rightAccounts)
