module Command
  ( Command (..)
  , CommandHistory (..)
  , FileState (..)
  , newHistory
  , createFileCmd
  , deleteFileCmd
  , executeCmd
  , historyDescriptions
  , undoCmd
  ) where

data Command a = Command
  { execute :: a -> a
  , undo :: a -> a
  , description :: String
  }

data CommandHistory a = CommandHistory
  { chState :: a
  , chHistory :: [Command a]
  }

newtype FileState = FileState
  { fsFiles :: [(String, String)]
  }
  deriving (Eq, Show)

newHistory :: a -> CommandHistory a
newHistory state = CommandHistory state []

createFileCmd :: String -> String -> Command FileState
createFileCmd name content =
  Command
    { execute = \fileState ->
        fileState {fsFiles = fsFiles fileState ++ [(name, content)]}
    , undo = \fileState ->
        fileState {fsFiles = filter (\(fileName, _) -> fileName /= name) (fsFiles fileState)}
    , description = "ファイル作成: " ++ name
    }

deleteFileCmd :: String -> Command FileState
deleteFileCmd name =
  Command
    { execute = \fileState ->
        fileState {fsFiles = filter (\(fileName, _) -> fileName /= name) (fsFiles fileState)}
    , undo = id
    , description = "ファイル削除: " ++ name
    }

executeCmd :: Command a -> CommandHistory a -> CommandHistory a
executeCmd command history =
  history
    { chState = execute command (chState history)
    , chHistory = command : chHistory history
    }

historyDescriptions :: CommandHistory a -> [String]
historyDescriptions = map description . chHistory

undoCmd :: CommandHistory a -> CommandHistory a
undoCmd history =
  case chHistory history of
    [] -> history
    command : commands ->
      history
        { chState = undo command (chState history)
        , chHistory = commands
        }
