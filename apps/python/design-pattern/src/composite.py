"""Composite パターン

Task を基底クラスとし、CompositeTask が子タスクを管理する。
ケーキ作りのタスクツリーで Composite パターンを示す。
"""

from __future__ import annotations


class Task:
    """基底タスククラス（Component）"""

    def __init__(self, name: str) -> None:
        self.name = name
        self.parent: Task | None = None

    def get_time_required(self) -> float:
        return 0.0

    @property
    def total_basic_tasks(self) -> int:
        return 1


class CompositeTask(Task):
    """複合タスククラス（Composite）"""

    def __init__(self, name: str) -> None:
        super().__init__(name)
        self._sub_tasks: list[Task] = []

    @property
    def sub_tasks(self) -> list[Task]:
        return list(self._sub_tasks)

    def add_sub_task(self, task: Task) -> None:
        self._sub_tasks.append(task)
        task.parent = self

    def remove_sub_task(self, task: Task) -> None:
        self._sub_tasks.remove(task)
        task.parent = None

    def get_time_required(self) -> float:
        return sum(t.get_time_required() for t in self._sub_tasks)

    @property
    def total_basic_tasks(self) -> int:
        return sum(t.total_basic_tasks for t in self._sub_tasks)


# --- リーフタスク群 ---


class AddDryIngredientsTask(Task):
    def __init__(self) -> None:
        super().__init__("乾燥材料を加える")

    def get_time_required(self) -> float:
        return 1.0


class AddLiquidsTask(Task):
    def __init__(self) -> None:
        super().__init__("液体材料を加える")

    def get_time_required(self) -> float:
        return 1.0


class MixTask(Task):
    def __init__(self) -> None:
        super().__init__("混ぜる")

    def get_time_required(self) -> float:
        return 3.0


class FillPanTask(Task):
    def __init__(self) -> None:
        super().__init__("型に流し込む")

    def get_time_required(self) -> float:
        return 2.0


class BakeTask(Task):
    def __init__(self) -> None:
        super().__init__("焼く")

    def get_time_required(self) -> float:
        return 10.0


class FrostTask(Task):
    def __init__(self) -> None:
        super().__init__("アイシングする")

    def get_time_required(self) -> float:
        return 4.0


class LickSpoonTask(Task):
    def __init__(self) -> None:
        super().__init__("スプーンをなめる")

    def get_time_required(self) -> float:
        return 1.0


# --- 複合タスク ---


class MakeBatterTask(CompositeTask):
    """生地を作る"""

    def __init__(self) -> None:
        super().__init__("生地を作る")
        self.add_sub_task(AddDryIngredientsTask())
        self.add_sub_task(AddLiquidsTask())
        self.add_sub_task(MixTask())


class MakeCakeTask(CompositeTask):
    """ケーキを作る"""

    def __init__(self) -> None:
        super().__init__("ケーキを作る")
        self.add_sub_task(MakeBatterTask())
        self.add_sub_task(FillPanTask())
        self.add_sub_task(BakeTask())
        self.add_sub_task(FrostTask())
        self.add_sub_task(LickSpoonTask())
