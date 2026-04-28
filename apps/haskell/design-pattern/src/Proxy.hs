-- | Proxy パターン
-- newtype ラッパーでアクセス制御を実現する。
-- Haskell の遅延評価は本質的に仮想プロキシ。
module Proxy
  ( Document(..)
  , AccessLevel(..)
  , ProtectedDoc(..)
  , accessDocument
  , VirtualDoc(..)
  , loadDocument
  , LoggedDoc(..)
  , accessWithLog
  ) where

-- | ドキュメント
data Document = Document
  { docTitle   :: String
  , docContent :: String
  } deriving (Show, Eq)

-- | アクセスレベル
data AccessLevel = Guest | Member | Admin
  deriving (Show, Eq, Ord)

-- | 保護プロキシ: アクセス制御付きドキュメント
data ProtectedDoc = ProtectedDoc
  { pdDoc          :: Document
  , pdRequiredLevel :: AccessLevel
  } deriving (Show, Eq)

-- | アクセス制御付きでドキュメントを取得
accessDocument :: AccessLevel -> ProtectedDoc -> Either String Document
accessDocument userLevel pd
  | userLevel >= pdRequiredLevel pd = Right (pdDoc pd)
  | otherwise = Left $ "アクセス拒否: " ++ show userLevel
                        ++ " は " ++ show (pdRequiredLevel pd) ++ " 以上が必要"

-- | 仮想プロキシ: 遅延ロード
data VirtualDoc = VirtualDoc
  { vdTitle   :: String
  , vdLoader  :: String -> Document  -- ^ タイトルからドキュメントをロード
  }

-- | 遅延ロードを実行
loadDocument :: VirtualDoc -> Document
loadDocument vd = vdLoader vd (vdTitle vd)

-- | ログ付きプロキシ
data LoggedDoc = LoggedDoc
  { ldDoc :: Document
  , ldLog :: [String]
  } deriving (Show, Eq)

-- | ログを記録してアクセス
accessWithLog :: String -> LoggedDoc -> (Document, LoggedDoc)
accessWithLog user ld =
  let msg = user ++ " が " ++ docTitle (ldDoc ld) ++ " にアクセスしました"
  in (ldDoc ld, ld { ldLog = ldLog ld ++ [msg] })
