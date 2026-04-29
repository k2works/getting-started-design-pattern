"""Observer パターン

Employee がサブジェクト（観察対象）として、
給与やタイトルの変更をオブザーバーに通知する。
"""

from typing import Protocol


class Observer(Protocol):
    """オブザーバープロトコル"""

    def update(self, employee: "Employee") -> None: ...


class Employee:
    """従業員クラス（Observer パターン - Subject）"""

    def __init__(self, name: str, title: str, salary: int) -> None:
        self.name = name
        self._title = title
        self._salary = salary
        self._observers: list[Observer] = []

    def add_observer(self, observer: Observer) -> None:
        self._observers.append(observer)

    def remove_observer(self, observer: Observer) -> None:
        self._observers.remove(observer)

    def _notify_observers(self) -> None:
        for observer in self._observers:
            observer.update(self)

    @property
    def salary(self) -> int:
        return self._salary

    @salary.setter
    def salary(self, new_salary: int) -> None:
        self._salary = new_salary
        self._notify_observers()

    @property
    def title(self) -> str:
        return self._title

    @title.setter
    def title(self, new_title: str) -> None:
        self._title = new_title
        self._notify_observers()


class Payroll:
    """給与計算オブザーバー"""

    def __init__(self) -> None:
        self.last_notification: str = ""

    def update(self, employee: Employee) -> None:
        self.last_notification = (
            f"{employee.name} の給与が {employee.salary} に変更されました"
        )


class TaxMan:
    """税務担当オブザーバー"""

    def __init__(self) -> None:
        self.last_notification: str = ""

    def update(self, employee: Employee) -> None:
        self.last_notification = (
            f"{employee.name} に新しい税金の請求書を送付します"
        )
