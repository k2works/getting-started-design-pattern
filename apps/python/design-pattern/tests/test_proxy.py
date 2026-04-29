"""Proxy パターンのテスト"""

import getpass

import pytest
from src.proxy import BankAccount, ProtectionProxy, VirtualProxy


class TestBankAccount:
    def test_初期残高(self):
        account = BankAccount(100)
        assert account.balance == 100

    def test_入金(self):
        account = BankAccount(100)
        account.deposit(50)
        assert account.balance == 150

    def test_出金(self):
        account = BankAccount(100)
        account.withdraw(30)
        assert account.balance == 70


class TestProtectionProxy:
    def test_オーナーはアクセスできる(self):
        account = BankAccount(100)
        proxy = ProtectionProxy(account, getpass.getuser())
        assert proxy.balance == 100

    def test_オーナーは入金できる(self):
        account = BankAccount(100)
        proxy = ProtectionProxy(account, getpass.getuser())
        proxy.deposit(50)
        assert proxy.balance == 150

    def test_非オーナーはアクセスできない(self):
        account = BankAccount(100)
        proxy = ProtectionProxy(account, "unauthorized_user")
        with pytest.raises(PermissionError):
            _ = proxy.balance


class TestVirtualProxy:
    def test_遅延初期化される(self):
        created = {"count": 0}

        def create():
            created["count"] += 1
            return BankAccount(100)

        proxy = VirtualProxy(create)
        assert created["count"] == 0  # まだ作られていない

        _ = proxy.balance
        assert created["count"] == 1  # 初アクセスで作成

    def test_二回目以降は再作成されない(self):
        created = {"count": 0}

        def create():
            created["count"] += 1
            return BankAccount(100)

        proxy = VirtualProxy(create)
        _ = proxy.balance
        _ = proxy.balance
        assert created["count"] == 1

    def test_仮想プロキシ経由で操作できる(self):
        proxy = VirtualProxy(lambda: BankAccount(100))
        proxy.deposit(50)
        assert proxy.balance == 150
