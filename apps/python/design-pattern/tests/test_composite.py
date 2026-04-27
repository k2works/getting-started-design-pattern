"""Composite パターンのテスト"""

from src.composite import (
    AddDryIngredientsTask,
    CompositeTask,
    MakeBatterTask,
    MakeCakeTask,
    Task,
)


class TestLeafTask:
    def test_リーフタスクの名前(self):
        task = AddDryIngredientsTask()
        assert task.name == "乾燥材料を加える"

    def test_リーフタスクの時間(self):
        task = AddDryIngredientsTask()
        assert task.get_time_required() == 1.0

    def test_リーフタスクの基本タスク数は1(self):
        task = AddDryIngredientsTask()
        assert task.total_basic_tasks == 1


class TestCompositeTask:
    def test_サブタスクを追加できる(self):
        composite = CompositeTask("テスト")
        task = AddDryIngredientsTask()
        composite.add_sub_task(task)
        assert len(composite.sub_tasks) == 1
        assert task.parent is composite

    def test_サブタスクを削除できる(self):
        composite = CompositeTask("テスト")
        task = AddDryIngredientsTask()
        composite.add_sub_task(task)
        composite.remove_sub_task(task)
        assert len(composite.sub_tasks) == 0
        assert task.parent is None


class TestMakeBatterTask:
    def test_生地作りの合計時間(self):
        batter = MakeBatterTask()
        assert batter.get_time_required() == 5.0  # 1 + 1 + 3

    def test_生地作りの基本タスク数(self):
        batter = MakeBatterTask()
        assert batter.total_basic_tasks == 3


class TestMakeCakeTask:
    def test_ケーキ作りの合計時間(self):
        cake = MakeCakeTask()
        assert cake.get_time_required() == 22.0  # 5 + 2 + 10 + 4 + 1

    def test_ケーキ作りの基本タスク数(self):
        cake = MakeCakeTask()
        assert cake.total_basic_tasks == 7

    def test_ケーキタスクの名前(self):
        cake = MakeCakeTask()
        assert cake.name == "ケーキを作る"
