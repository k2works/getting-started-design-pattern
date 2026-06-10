module Proxy
  ( AccessLevel (..)
  , Document (..)
  , LoggedDoc (..)
  , ProtectedDoc (..)
  , VirtualDoc (..)
  , accessDocument
  , accessWithLog
  , loadVirtualDoc
  ) where

data AccessLevel = Guest | Member | Admin
  deriving (Eq, Ord, Show)

data Document = Document
  { docTitle :: String
  , docContent :: String
  }
  deriving (Eq, Show)

data ProtectedDoc = ProtectedDoc
  { pdDoc :: Document
  , pdRequiredLevel :: AccessLevel
  }
  deriving (Eq, Show)

data LoggedDoc = LoggedDoc
  { ldDoc :: Document
  , ldLog :: [String]
  }
  deriving (Eq, Show)

data VirtualDoc = VirtualDoc
  { vdTitle :: String
  , vdLoader :: String -> Document
  }

accessDocument :: AccessLevel -> ProtectedDoc -> Either String Document
accessDocument userLevel protectedDoc
  | userLevel >= pdRequiredLevel protectedDoc = Right (pdDoc protectedDoc)
  | otherwise = Left "アクセス拒否"

accessWithLog :: String -> LoggedDoc -> (Document, LoggedDoc)
accessWithLog user loggedDoc =
  let document = ldDoc loggedDoc
      message = user ++ " が " ++ docTitle document ++ " にアクセスしました"
   in (document, loggedDoc {ldLog = ldLog loggedDoc ++ [message]})

loadVirtualDoc :: VirtualDoc -> Document
loadVirtualDoc virtualDoc = vdLoader virtualDoc (vdTitle virtualDoc)
