"""Decorator パターン

SimpleWriter にデコレーターで行番号やタイムスタンプを付加する。
テスト容易性のため、ファイルではなくリストに書き込む。
"""

from __future__ import annotations

from datetime import datetime


class SimpleWriter:
    """シンプルライター（Component）"""

    def __init__(self) -> None:
        self.lines: list[str] = []

    def write_line(self, line: str) -> None:
        self.lines.append(line)


class NumberingWriter:
    """行番号付きデコレーター"""

    def __init__(self, writer: SimpleWriter) -> None:
        self._writer = writer
        self._line_number = 1

    def write_line(self, line: str) -> None:
        self._writer.write_line(f"{self._line_number}: {line}")
        self._line_number += 1

    @property
    def lines(self) -> list[str]:
        return self._writer.lines


class TimeStampingWriter:
    """タイムスタンプ付きデコレーター"""

    def __init__(self, writer: SimpleWriter, *, clock: datetime | None = None) -> None:
        self._writer = writer
        self._clock = clock

    def _get_timestamp(self) -> str:
        ts = self._clock if self._clock else datetime.now()
        return ts.isoformat()

    def write_line(self, line: str) -> None:
        self._writer.write_line(f"{self._get_timestamp()}: {line}")

    @property
    def lines(self) -> list[str]:
        return self._writer.lines


# --- 関数ベースのデコレーター（Python らしいアプローチ） ---


def with_numbering(write_func):
    """行番号を付加するデコレーター"""
    counter = {"n": 1}

    def wrapper(line: str) -> str:
        result = f"{counter['n']}: {line}"
        counter["n"] += 1
        return result

    return wrapper
