-- | Adapter パターン
-- 型クラスで統一インターフェースを定義し、
-- 異なるデータ型をインスタンスとして適合させる。
module Adapter
  ( Renderable(..)
  , OldPrinter(..)
  , ModernPrinter(..)
  , renderAll
  ) where

-- | 統一インターフェース: 型クラス
class Renderable a where
  render :: a -> String

-- | 旧式プリンタ（既存のインターフェース）
data OldPrinter = OldPrinter
  { opHeader :: String
  , opBody   :: String
  } deriving (Show, Eq)

-- | 旧式プリンタを Renderable に適合
instance Renderable OldPrinter where
  render p = "=== " ++ opHeader p ++ " ===\n" ++ opBody p ++ "\n"

-- | モダンプリンタ（新しいインターフェース）
data ModernPrinter = ModernPrinter
  { mpTitle   :: String
  , mpContent :: String
  , mpFormat  :: String  -- ^ "html" or "text"
  } deriving (Show, Eq)

-- | モダンプリンタを Renderable に適合
instance Renderable ModernPrinter where
  render p = case mpFormat p of
    "html" -> "<div><h1>" ++ mpTitle p ++ "</h1><p>"
              ++ mpContent p ++ "</p></div>"
    _      -> "[" ++ mpTitle p ++ "] " ++ mpContent p

-- | 複数の Renderable をまとめて出力
renderAll :: Renderable a => [a] -> String
renderAll = concatMap render
