"""Command パターン

コマンドオブジェクトで操作をカプセル化し、
実行と取り消し（undo）をサポートする。
"""

from __future__ import annotations

from pathlib import Path
from typing import Protocol


class Command(Protocol):
    """コマンドプロトコル"""

    @property
    def description(self) -> str: ...

    def execute(self) -> None: ...

    def undo(self) -> None: ...


class CreateFileCommand:
    """ファイル作成コマンド"""

    def __init__(self, path: str, contents: str) -> None:
        self._path = Path(path)
        self._contents = contents

    @property
    def description(self) -> str:
        return f"Create file: {self._path}"

    def execute(self) -> None:
        self._path.write_text(self._contents, encoding="utf-8")

    def undo(self) -> None:
        if self._path.exists():
            self._path.unlink()


class DeleteFileCommand:
    """ファイル削除コマンド"""

    def __init__(self, path: str) -> None:
        self._path = Path(path)
        self._contents: str | None = None

    @property
    def description(self) -> str:
        return f"Delete file: {self._path}"

    def execute(self) -> None:
        if self._path.exists():
            self._contents = self._path.read_text(encoding="utf-8")
            self._path.unlink()

    def undo(self) -> None:
        if self._contents is not None:
            self._path.write_text(self._contents, encoding="utf-8")


class CompositeCommand:
    """複合コマンド"""

    def __init__(self) -> None:
        self._commands: list[Command] = []

    def add_command(self, cmd: Command) -> None:
        self._commands.append(cmd)

    @property
    def description(self) -> str:
        return "\n".join(c.description for c in self._commands)

    def execute(self) -> None:
        for cmd in self._commands:
            cmd.execute()

    def undo(self) -> None:
        for cmd in reversed(self._commands):
            cmd.undo()
