module Composite
  ( Task (..)
  , taskName
  , timeRequired
  , totalTasks
  , addSubTask
  , subTasks
  , priority
  ) where

data Task
  = LeafTask
      { ltName :: String
      , ltTime :: Double
      , ltPriority :: Int
      }
  | CompositeTask
      { ctName :: String
      , ctChildren :: [Task]
      , ctPriority :: Int
      }
  deriving (Eq, Show)

taskName :: Task -> String
taskName (LeafTask name _ _) = name
taskName (CompositeTask name _ _) = name

timeRequired :: Task -> Double
timeRequired (LeafTask _ time _) = time
timeRequired (CompositeTask _ children _) =
  sum (map timeRequired children)

totalTasks :: Task -> Int
totalTasks (LeafTask _ _ _) = 1
totalTasks (CompositeTask _ children _) =
  sum (map totalTasks children)

addSubTask :: Task -> Task -> Task
addSubTask child (CompositeTask name children taskPriority) =
  CompositeTask name (children ++ [child]) taskPriority
addSubTask _ leafTask = leafTask

subTasks :: Task -> [Task]
subTasks (LeafTask _ _ _) = []
subTasks (CompositeTask _ children _) = children

priority :: Task -> Int
priority (LeafTask _ _ taskPriority) = taskPriority
priority (CompositeTask _ _ taskPriority) = taskPriority
