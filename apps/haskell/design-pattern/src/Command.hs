-- | Command パターン
-- コマンドを実行と取り消しの関数ペアとして表現する。
-- 履歴スタックで undo/redo を実現。
module Command
  ( Command(..)
  , CommandHistory(..)
  , newHistory
  , executeCmd
  , undoCmd
  , historyDescriptions
  -- * ファイル操作コマンド
  , FileState(..)
  , createFileCmd
  , deleteFileCmd
  , writeFileCmd
  ) where

-- | コマンド: 実行と取り消しの関数ペア
data Command a = Command
  { execute     :: a -> a
  , undo        :: a -> a
  , description :: String
  }

-- | コマンド履歴
data CommandHistory a = CommandHistory
  { chState   :: a
  , chHistory :: [Command a]
  }

-- | 新しい履歴を作成
newHistory :: a -> CommandHistory a
newHistory s = CommandHistory s []

-- | コマンドを実行
executeCmd :: Command a -> CommandHistory a -> CommandHistory a
executeCmd cmd hist = CommandHistory
  { chState   = execute cmd (chState hist)
  , chHistory = cmd : chHistory hist
  }

-- | 最後のコマンドを取り消し
undoCmd :: CommandHistory a -> CommandHistory a
undoCmd hist = case chHistory hist of
  []       -> hist
  (c : cs) -> CommandHistory
    { chState   = undo c (chState hist)
    , chHistory = cs
    }

-- | 履歴内のコマンド説明を取得（新しい順）
historyDescriptions :: CommandHistory a -> [String]
historyDescriptions = map description . chHistory

-- ======== ファイル操作の例 ========

-- | ファイルの状態
data FileState = FileState
  { fsFiles :: [(String, String)]  -- ^ (ファイル名, 内容)
  } deriving (Show, Eq)

-- | ファイル作成コマンド
createFileCmd :: String -> String -> Command FileState
createFileCmd name content = Command
  { execute     = \fs -> fs { fsFiles = fsFiles fs ++ [(name, content)] }
  , undo        = \fs -> fs { fsFiles = filter (\(n, _) -> n /= name) (fsFiles fs) }
  , description = "ファイル作成: " ++ name
  }

-- | ファイル削除コマンド
deleteFileCmd :: String -> Command FileState
deleteFileCmd name = Command
  { execute     = \fs -> fs { fsFiles = filter (\(n, _) -> n /= name) (fsFiles fs) }
  , undo        = \fs -> fs  -- 簡易実装: 削除の undo は復元しない
  , description = "ファイル削除: " ++ name
  }

-- | ファイル書き込みコマンド
writeFileCmd :: String -> String -> String -> Command FileState
writeFileCmd name oldContent newContent = Command
  { execute     = \fs -> fs { fsFiles = map (\(n, c) -> if n == name then (n, newContent) else (n, c)) (fsFiles fs) }
  , undo        = \fs -> fs { fsFiles = map (\(n, c) -> if n == name then (n, oldContent) else (n, c)) (fsFiles fs) }
  , description = "ファイル書き込み: " ++ name
  }
