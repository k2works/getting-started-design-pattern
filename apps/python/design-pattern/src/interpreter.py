"""Interpreter パターン

ファイル検索 DSL を式ツリーで表現する。
__and__, __or__ 演算子オーバーロードで式を組み立てる。
"""

from __future__ import annotations

from pathlib import Path


class Expression:
    """式の基底クラス"""

    def evaluate(self, directory: str) -> list[str]:
        raise NotImplementedError

    def __and__(self, other: Expression) -> And:
        return And(self, other)

    def __or__(self, other: Expression) -> Or:
        return Or(self, other)


class All(Expression):
    """すべてのファイルにマッチ"""

    def evaluate(self, directory: str) -> list[str]:
        return sorted(
            str(p) for p in Path(directory).rglob("*") if p.is_file()
        )


class FileName(Expression):
    """ファイル名パターンでマッチ"""

    def __init__(self, pattern: str) -> None:
        self._pattern = pattern

    def evaluate(self, directory: str) -> list[str]:
        return sorted(
            str(p) for p in Path(directory).rglob(self._pattern) if p.is_file()
        )


class Bigger(Expression):
    """サイズが指定バイト以上のファイル"""

    def __init__(self, size: int) -> None:
        self._size = size

    def evaluate(self, directory: str) -> list[str]:
        return sorted(
            str(p)
            for p in Path(directory).rglob("*")
            if p.is_file() and p.stat().st_size > self._size
        )


class Writable(Expression):
    """書き込み可能なファイル"""

    def evaluate(self, directory: str) -> list[str]:
        import os

        return sorted(
            str(p)
            for p in Path(directory).rglob("*")
            if p.is_file() and os.access(p, os.W_OK)
        )


class And(Expression):
    """AND 複合式"""

    def __init__(self, left: Expression, right: Expression) -> None:
        self._left = left
        self._right = right

    def evaluate(self, directory: str) -> list[str]:
        left_set = set(self._left.evaluate(directory))
        right_set = set(self._right.evaluate(directory))
        return sorted(left_set & right_set)


class Or(Expression):
    """OR 複合式"""

    def __init__(self, left: Expression, right: Expression) -> None:
        self._left = left
        self._right = right

    def evaluate(self, directory: str) -> list[str]:
        left_set = set(self._left.evaluate(directory))
        right_set = set(self._right.evaluate(directory))
        return sorted(left_set | right_set)


class Not(Expression):
    """NOT 式"""

    def __init__(self, expression: Expression) -> None:
        self._expression = expression

    def evaluate(self, directory: str) -> list[str]:
        all_files = set(All().evaluate(directory))
        excluded = set(self._expression.evaluate(directory))
        return sorted(all_files - excluded)
