-- | Iterator パターン
-- Haskell ではリストが標準のイテレータ。
-- Data.Map や独自の走査関数で多様な反復処理を示す。
module IteratorPattern
  ( Portfolio(..)
  , Account(..)
  , AccountType(..)
  , newPortfolio
  , addAccount
  , totalBalance
  , filterByType
  , accountNames
  , sortByBalance
  , mergePortfolios
  ) where

import Data.List (sortBy)
import Data.Ord (comparing)

-- | 口座種別
data AccountType = Savings | Checking | Investment
  deriving (Show, Eq, Ord)

-- | 口座
data Account = Account
  { acctName    :: String
  , acctType    :: AccountType
  , acctBalance :: Double
  } deriving (Show, Eq)

-- | ポートフォリオ: 口座のコレクション
newtype Portfolio = Portfolio { accounts :: [Account] }
  deriving (Show, Eq)

-- | 空のポートフォリオ
newPortfolio :: Portfolio
newPortfolio = Portfolio []

-- | 口座を追加
addAccount :: Account -> Portfolio -> Portfolio
addAccount a (Portfolio as) = Portfolio (as ++ [a])

-- | 残高合計（fold）
totalBalance :: Portfolio -> Double
totalBalance = sum . map acctBalance . accounts

-- | 種別でフィルタ（filter）
filterByType :: AccountType -> Portfolio -> [Account]
filterByType t = filter (\a -> acctType a == t) . accounts

-- | 口座名一覧（map）
accountNames :: Portfolio -> [String]
accountNames = map acctName . accounts

-- | 残高順にソート
sortByBalance :: Portfolio -> [Account]
sortByBalance = sortBy (comparing acctBalance) . accounts

-- | 2 つのポートフォリオを統合
mergePortfolios :: Portfolio -> Portfolio -> Portfolio
mergePortfolios (Portfolio a) (Portfolio b) = Portfolio (a ++ b)
