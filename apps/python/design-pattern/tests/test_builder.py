"""Builder パターンのテスト"""

import pytest
from src.builder import (
    DesktopBuilder,
    DisplayType,
    LaptopBuilder,
)


class TestDesktopBuilder:
    def test_デスクトップを組み立てる(self):
        builder = DesktopBuilder()
        builder.add_hard_disk(500000)
        computer = builder.build()
        assert computer.display == DisplayType.CRT
        assert computer.motherboard.cpu == "BasicCPU"

    def test_ターボCPUを設定できる(self):
        builder = DesktopBuilder()
        builder.turbo()
        builder.add_hard_disk(500000)
        computer = builder.build()
        assert computer.motherboard.cpu == "TurboCPU"

    def test_メモリサイズを設定できる(self):
        builder = DesktopBuilder()
        builder.memory_size(1024)
        builder.add_hard_disk(500000)
        computer = builder.build()
        assert computer.motherboard.memory_size == 1024

    def test_ドライブを追加できる(self):
        builder = DesktopBuilder()
        builder.add_hard_disk(500000)
        builder.add_cd()
        builder.add_dvd(writable=True)
        computer = builder.build()
        assert len(computer.drives) == 3


class TestLaptopBuilder:
    def test_ラップトップを組み立てる(self):
        builder = LaptopBuilder()
        builder.add_hard_disk(250000)
        computer = builder.build()
        assert computer.display == DisplayType.LCD

    def test_ラップトップのデフォルトメモリ(self):
        builder = LaptopBuilder()
        builder.add_hard_disk(250000)
        computer = builder.build()
        assert computer.motherboard.memory_size == 512


class TestValidation:
    def test_メモリ不足でエラー(self):
        builder = DesktopBuilder()
        builder.memory_size(100)
        builder.add_hard_disk(500000)
        with pytest.raises(ValueError, match="Not enough memory"):
            builder.build()

    def test_ドライブが多すぎるとエラー(self):
        builder = DesktopBuilder()
        for _ in range(5):
            builder.add_hard_disk(100000)
        with pytest.raises(ValueError, match="Too many drives"):
            builder.build()

    def test_ハードディスクがないとエラー(self):
        builder = DesktopBuilder()
        builder.add_cd()
        with pytest.raises(ValueError, match="Must have at least one hard disk"):
            builder.build()
