"""Proxy パターン

BankAccount への保護プロキシと仮想（遅延初期化）プロキシ。
"""

from __future__ import annotations

import getpass
from typing import Any, Callable


class BankAccount:
    """銀行口座（Real Subject）"""

    def __init__(self, starting_balance: float = 0) -> None:
        self._balance = starting_balance

    @property
    def balance(self) -> float:
        return self._balance

    def deposit(self, amount: float) -> None:
        self._balance += amount

    def withdraw(self, amount: float) -> None:
        self._balance -= amount


class ProtectionProxy:
    """保護プロキシ: オーナーのみアクセスを許可"""

    def __init__(self, real_account: BankAccount, owner_name: str) -> None:
        self._subject = real_account
        self._owner_name = owner_name

    def _check_access(self) -> None:
        current_user = getpass.getuser()
        if current_user != self._owner_name:
            raise PermissionError(
                f"Illegal access: {current_user} cannot access account."
            )

    @property
    def balance(self) -> float:
        self._check_access()
        return self._subject.balance

    def deposit(self, amount: float) -> None:
        self._check_access()
        self._subject.deposit(amount)

    def withdraw(self, amount: float) -> None:
        self._check_access()
        self._subject.withdraw(amount)


class VirtualProxy:
    """仮想プロキシ: 遅延初期化"""

    def __init__(self, creation_func: Callable[[], BankAccount]) -> None:
        self._creation_func = creation_func
        self._subject: BankAccount | None = None

    def _get_subject(self) -> BankAccount:
        if self._subject is None:
            self._subject = self._creation_func()
        return self._subject

    @property
    def balance(self) -> float:
        return self._get_subject().balance

    def deposit(self, amount: float) -> None:
        self._get_subject().deposit(amount)

    def withdraw(self, amount: float) -> None:
        self._get_subject().withdraw(amount)
