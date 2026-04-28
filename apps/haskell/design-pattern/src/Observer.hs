-- | Observer パターン
-- IORef を使ったコールバックリストで、状態変化を通知する。
-- 純粋版も提供: 状態遷移関数のリストに通知を組み込む。
module Observer
  ( Employee(..)
  , Event(..)
  , ObserverSystem
  , newObserverSystem
  , addObserver
  , updateSalary
  , getEvents
  -- * 純粋版
  , PureSubject(..)
  , notify
  , changeSalary
  ) where

import Data.IORef

-- | イベント型
data Event = SalaryChanged String Double Double  -- ^ name, old, new
  deriving (Show, Eq)

-- | 従業員データ
data Employee = Employee
  { empName   :: String
  , empSalary :: Double
  } deriving (Show, Eq)

-- | Observer システム（IORef ベース）
data ObserverSystem = ObserverSystem
  { osEmployee  :: IORef Employee
  , osObservers :: IORef [Event -> IO ()]
  , osEvents    :: IORef [Event]
  }

-- | 新しい Observer システムを作成
newObserverSystem :: Employee -> IO ObserverSystem
newObserverSystem emp = do
  empRef <- newIORef emp
  obsRef <- newIORef []
  evtRef <- newIORef []
  return ObserverSystem
    { osEmployee  = empRef
    , osObservers = obsRef
    , osEvents    = evtRef
    }

-- | オブザーバーを追加
addObserver :: ObserverSystem -> (Event -> IO ()) -> IO ()
addObserver sys obs = modifyIORef (osObservers sys) (obs :)

-- | 給与を更新し、オブザーバーに通知
updateSalary :: ObserverSystem -> Double -> IO ()
updateSalary sys newSal = do
  emp <- readIORef (osEmployee sys)
  let oldSal = empSalary emp
      event  = SalaryChanged (empName emp) oldSal newSal
  writeIORef (osEmployee sys) emp { empSalary = newSal }
  observers <- readIORef (osObservers sys)
  mapM_ (\obs -> obs event) observers
  modifyIORef (osEvents sys) (++ [event])

-- | 記録されたイベントを取得
getEvents :: ObserverSystem -> IO [Event]
getEvents sys = readIORef (osEvents sys)

-- ======== 純粋版 ========

-- | 純粋な Subject
data PureSubject = PureSubject
  { psName      :: String
  , psSalary    :: Double
  , psLog       :: [String]
  } deriving (Show, Eq)

-- | 純粋な通知: ログにメッセージを追加
notify :: PureSubject -> String -> PureSubject
notify subj msg = subj { psLog = psLog subj ++ [msg] }

-- | 純粋な給与変更 + 通知
changeSalary :: Double -> PureSubject -> PureSubject
changeSalary newSal subj =
  let msg = psName subj ++ " の給与が "
            ++ show (psSalary subj) ++ " から "
            ++ show newSal ++ " に変更されました"
  in notify (subj { psSalary = newSal }) msg
