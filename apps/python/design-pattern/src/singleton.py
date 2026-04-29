"""Singleton パターン

メタクラスによる Singleton と、モジュールレベルの Pythonic な Singleton。
"""

from __future__ import annotations

from typing import Any


class SingletonMeta(type):
    """Singleton メタクラス"""

    _instances: dict[type, Any] = {}

    def __call__(cls, *args: Any, **kwargs: Any) -> Any:
        if cls not in cls._instances:
            cls._instances[cls] = super().__call__(*args, **kwargs)
        return cls._instances[cls]

    @classmethod
    def _reset(mcs, cls: type) -> None:
        """テスト用: インスタンスをリセット"""
        mcs._instances.pop(cls, None)


class SingletonLogger(metaclass=SingletonMeta):
    """メタクラスベースの Singleton ロガー"""

    ERROR = 1
    WARNING = 2
    INFO = 3

    def __init__(self) -> None:
        self._messages: list[str] = []
        self.level: int = self.INFO

    def error(self, msg: str) -> None:
        if self.level >= self.ERROR:
            self._messages.append(f"[ERROR] {msg}")

    def warning(self, msg: str) -> None:
        if self.level >= self.WARNING:
            self._messages.append(f"[WARNING] {msg}")

    def info(self, msg: str) -> None:
        if self.level >= self.INFO:
            self._messages.append(f"[INFO] {msg}")

    @property
    def logged_content(self) -> str:
        return "\n".join(self._messages)

    def clear(self) -> None:
        self._messages.clear()


# --- モジュールレベル Singleton（Pythonic アプローチ）---


class _ModuleLogger:
    """モジュールレベルのロガー実装"""

    ERROR = 1
    WARNING = 2
    INFO = 3

    def __init__(self) -> None:
        self._messages: list[str] = []
        self.level: int = self.INFO

    def error(self, msg: str) -> None:
        if self.level >= self.ERROR:
            self._messages.append(f"[ERROR] {msg}")

    def warning(self, msg: str) -> None:
        if self.level >= self.WARNING:
            self._messages.append(f"[WARNING] {msg}")

    def info(self, msg: str) -> None:
        if self.level >= self.INFO:
            self._messages.append(f"[INFO] {msg}")

    @property
    def logged_content(self) -> str:
        return "\n".join(self._messages)

    def clear(self) -> None:
        self._messages.clear()


# モジュールレベルの唯一のインスタンス
module_logger = _ModuleLogger()
