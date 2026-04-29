namespace DesignPattern.Command

/// Command パターン
/// F# では関数をコマンドとして扱う。
/// execute と undo の関数フィールドを持つレコード型で表現する。
module Command =

    /// コマンドのレコード型
    type Command<'TState> =
        { Description: string
          Execute: 'TState -> 'TState
          Undo: 'TState -> 'TState }

    /// コマンド履歴を管理する
    type CommandHistory<'TState> =
        { State: 'TState
          UndoStack: Command<'TState> list
          RedoStack: Command<'TState> list }

    /// 初期状態からコマンド履歴を作成する
    let create (initialState: 'TState) : CommandHistory<'TState> =
        { State = initialState
          UndoStack = []
          RedoStack = [] }

    /// コマンドを実行する
    let execute (command: Command<'TState>) (history: CommandHistory<'TState>) : CommandHistory<'TState> =
        { State = command.Execute history.State
          UndoStack = command :: history.UndoStack
          RedoStack = [] }

    /// 直前のコマンドを取り消す
    let undo (history: CommandHistory<'TState>) : CommandHistory<'TState> =
        match history.UndoStack with
        | [] -> history
        | lastCommand :: rest ->
            { State = lastCommand.Undo history.State
              UndoStack = rest
              RedoStack = lastCommand :: history.RedoStack }

    /// 取り消したコマンドをやり直す
    let redo (history: CommandHistory<'TState>) : CommandHistory<'TState> =
        match history.RedoStack with
        | [] -> history
        | lastCommand :: rest ->
            { State = lastCommand.Execute history.State
              UndoStack = lastCommand :: history.UndoStack
              RedoStack = rest }

    // --- テキストエディタの例 ---

    /// テキストに文字列を追加するコマンド
    let appendText (text: string) : Command<string> =
        { Description = sprintf "Append '%s'" text
          Execute = fun state -> state + text
          Undo = fun state -> state.Substring(0, state.Length - text.Length) }

    /// テキストを大文字にするコマンド
    let toUpperCase (original: string) : Command<string> =
        { Description = "To upper case"
          Execute = fun state -> state.ToUpper()
          Undo = fun _ -> original }
