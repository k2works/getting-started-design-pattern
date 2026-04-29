"""Iterator パターン

Python の __iter__ プロトコルを活用して、
Portfolio が for-in ループをサポートする。
"""

from __future__ import annotations

from functools import total_ordering
from typing import Iterator


@total_ordering
class Account:
    """口座クラス"""

    def __init__(self, name: str, balance: float) -> None:
        self.name = name
        self.balance = balance

    def __eq__(self, other: object) -> bool:
        if not isinstance(other, Account):
            return NotImplemented
        return self.balance == other.balance

    def __lt__(self, other: object) -> bool:
        if not isinstance(other, Account):
            return NotImplemented
        return self.balance < other.balance

    def __repr__(self) -> str:
        return f"Account({self.name!r}, {self.balance})"


class Portfolio:
    """ポートフォリオクラス（Iterable）"""

    def __init__(self) -> None:
        self._accounts: list[Account] = []

    def add_account(self, account: Account) -> None:
        self._accounts.append(account)

    def __iter__(self) -> Iterator[Account]:
        return iter(self._accounts)

    def __len__(self) -> int:
        return len(self._accounts)

    @property
    def total_balance(self) -> float:
        return sum(a.balance for a in self._accounts)
