-- | Composite パターン
-- 代数的データ型（ADT）で木構造を表現する。
-- 再帰的なデータ型は Haskell の得意分野。
module Composite
  ( Task(..)
  , taskName
  , timeRequired
  , subTasks
  , addSubTask
  , priority
  ) where

-- | タスクの ADT: リーフまたはコンポジット
data Task
  = LeafTask
      { ltName     :: String
      , ltTime     :: Double
      , ltPriority :: Int
      }
  | CompositeTask
      { ctName     :: String
      , ctChildren :: [Task]
      , ctPriority :: Int
      }
  deriving (Show, Eq)

-- | タスク名を取得
taskName :: Task -> String
taskName (LeafTask n _ _)     = n
taskName (CompositeTask n _ _) = n

-- | 所要時間を再帰的に計算
timeRequired :: Task -> Double
timeRequired (LeafTask _ t _)       = t
timeRequired (CompositeTask _ cs _) = sum (map timeRequired cs)

-- | サブタスクを取得（リーフの場合は空）
subTasks :: Task -> [Task]
subTasks (LeafTask _ _ _)       = []
subTasks (CompositeTask _ cs _) = cs

-- | コンポジットにサブタスクを追加
addSubTask :: Task -> Task -> Task
addSubTask child (CompositeTask n cs p) = CompositeTask n (cs ++ [child]) p
addSubTask _     leaf                   = leaf  -- リーフには追加できない

-- | 優先度を取得
priority :: Task -> Int
priority (LeafTask _ _ p)       = p
priority (CompositeTask _ _ p)  = p
