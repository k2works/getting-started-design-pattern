defmodule DesignPattern.Command do
  @moduledoc """
  Command パターン: 操作をマップとして表現し、実行・取り消しを可能にする。
  各コマンドは :execute と :undo のキーに関数を持つ。
  """

  @doc "コマンドを作成する"
  def new(name, execute_fn, undo_fn) do
    %{name: name, execute: execute_fn, undo: undo_fn}
  end

  @doc "コマンドを実行する"
  def execute(command, state) do
    command.execute.(state)
  end

  @doc "コマンドを取り消す"
  def undo(command, state) do
    command.undo.(state)
  end

  @doc "コマンド履歴を管理するヒストリーを作成する"
  def new_history do
    %{executed: [], state: nil}
  end

  @doc "コマンドを実行して履歴に追加する"
  def execute_with_history(history, command) do
    new_state = execute(command, history.state)
    %{history | executed: [command | history.executed], state: new_state}
  end

  @doc "最後のコマンドを取り消す"
  def undo_last(%{executed: []} = history), do: history

  def undo_last(%{executed: [last | rest]} = history) do
    new_state = undo(last, history.state)
    %{history | executed: rest, state: new_state}
  end

  @doc "マクロコマンド（複数コマンドの一括実行）"
  def macro(name, commands) do
    %{
      name: name,
      execute: fn state ->
        Enum.reduce(commands, state, fn cmd, acc -> cmd.execute.(acc) end)
      end,
      undo: fn state ->
        Enum.reduce(Enum.reverse(commands), state, fn cmd, acc -> cmd.undo.(acc) end)
      end
    }
  end
end
