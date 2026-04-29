"""Iterator パターンのテスト"""

from src.iterator_pattern import Account, Portfolio


class TestAccount:
    def test_口座の初期状態(self):
        account = Account("普通預金", 1000.0)
        assert account.name == "普通預金"
        assert account.balance == 1000.0

    def test_口座の比較(self):
        a = Account("A", 1000.0)
        b = Account("B", 2000.0)
        assert a < b
        assert b > a

    def test_口座の等値比較(self):
        a = Account("A", 1000.0)
        b = Account("B", 1000.0)
        assert a == b

    def test_口座のソート(self):
        accounts = [
            Account("C", 3000.0),
            Account("A", 1000.0),
            Account("B", 2000.0),
        ]
        sorted_accounts = sorted(accounts)
        assert [a.name for a in sorted_accounts] == ["A", "B", "C"]


class TestPortfolio:
    def test_ポートフォリオにアカウントを追加できる(self):
        portfolio = Portfolio()
        portfolio.add_account(Account("A", 1000.0))
        assert len(portfolio) == 1

    def test_forループでイテレートできる(self):
        portfolio = Portfolio()
        portfolio.add_account(Account("A", 1000.0))
        portfolio.add_account(Account("B", 2000.0))

        names = [a.name for a in portfolio]
        assert names == ["A", "B"]

    def test_合計残高を計算できる(self):
        portfolio = Portfolio()
        portfolio.add_account(Account("A", 1000.0))
        portfolio.add_account(Account("B", 2000.0))
        assert portfolio.total_balance == 3000.0

    def test_空のポートフォリオ(self):
        portfolio = Portfolio()
        assert len(portfolio) == 0
        assert portfolio.total_balance == 0.0
