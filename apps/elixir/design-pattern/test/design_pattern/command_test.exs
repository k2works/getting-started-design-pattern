defmodule DesignPattern.CommandTest do
  use ExUnit.Case
  alias DesignPattern.Command

  test "コマンドを実行できる" do
    cmd = Command.new("add", fn n -> n + 10 end, fn n -> n - 10 end)
    assert Command.execute(cmd, 5) == 15
  end

  test "コマンドを取り消せる" do
    cmd = Command.new("add", fn n -> n + 10 end, fn n -> n - 10 end)
    assert Command.undo(cmd, 15) == 5
  end

  test "コマンド履歴で実行と取り消しができる" do
    cmd1 = Command.new("double", fn n -> n * 2 end, fn n -> div(n, 2) end)
    cmd2 = Command.new("add5", fn n -> n + 5 end, fn n -> n - 5 end)

    history =
      %{Command.new_history() | state: 10}
      |> Command.execute_with_history(cmd1)
      |> Command.execute_with_history(cmd2)

    assert history.state == 25

    undone = Command.undo_last(history)
    assert undone.state == 20
  end

  test "空の履歴で undo しても安全" do
    history = Command.new_history()
    assert Command.undo_last(history) == history
  end

  test "マクロコマンドで複数操作を一括実行する" do
    cmd1 = Command.new("a", fn n -> n + 1 end, fn n -> n - 1 end)
    cmd2 = Command.new("b", fn n -> n * 3 end, fn n -> div(n, 3) end)
    macro = Command.macro("macro", [cmd1, cmd2])

    assert Command.execute(macro, 2) == 9
    assert Command.undo(macro, 9) == 2
  end
end
