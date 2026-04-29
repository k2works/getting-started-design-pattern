"""Builder パターン

ComputerBuilder でコンピュータの構成を段階的に組み立てる。
DesktopBuilder / LaptopBuilder でバリエーションを提供。
"""

from __future__ import annotations

from dataclasses import dataclass, field
from enum import Enum, auto


class DriveType(Enum):
    CD = auto()
    DVD = auto()
    HARD_DISK = auto()


class DisplayType(Enum):
    CRT = auto()
    LCD = auto()


@dataclass(frozen=True)
class Drive:
    type: DriveType
    size: int
    writable: bool


@dataclass(frozen=True)
class Motherboard:
    cpu: str
    memory_size: int


@dataclass(frozen=True)
class Computer:
    display: DisplayType
    motherboard: Motherboard
    drives: list[Drive] = field(default_factory=list)


class ComputerBuilder:
    """コンピュータビルダー基底クラス"""

    def __init__(self) -> None:
        self._turbo: bool = False
        self._memory_size: int = 512
        self._drives: list[Drive] = []
        self._display: DisplayType = DisplayType.CRT

    def turbo(self, has_turbo: bool = True) -> ComputerBuilder:
        self._turbo = has_turbo
        return self

    def memory_size(self, size: int) -> ComputerBuilder:
        self._memory_size = size
        return self

    def add_cd(self, writable: bool = False) -> ComputerBuilder:
        self._drives.append(Drive(DriveType.CD, 760, writable))
        return self

    def add_dvd(self, writable: bool = False) -> ComputerBuilder:
        self._drives.append(Drive(DriveType.DVD, 4700, writable))
        return self

    def add_hard_disk(self, size: int) -> ComputerBuilder:
        self._drives.append(Drive(DriveType.HARD_DISK, size, True))
        return self

    def _validate(self) -> None:
        if self._memory_size < 250:
            raise ValueError(f"Not enough memory: {self._memory_size}")
        if len(self._drives) > 4:
            raise ValueError(f"Too many drives: {len(self._drives)}")
        if not any(d.type == DriveType.HARD_DISK for d in self._drives):
            raise ValueError("Must have at least one hard disk")

    def build(self) -> Computer:
        self._validate()
        cpu = "TurboCPU" if self._turbo else "BasicCPU"
        motherboard = Motherboard(cpu=cpu, memory_size=self._memory_size)
        return Computer(
            display=self._display,
            motherboard=motherboard,
            drives=list(self._drives),
        )


class DesktopBuilder(ComputerBuilder):
    def __init__(self) -> None:
        super().__init__()
        self._display = DisplayType.CRT


class LaptopBuilder(ComputerBuilder):
    def __init__(self) -> None:
        super().__init__()
        self._display = DisplayType.LCD

    def build(self) -> Computer:
        if self._display != DisplayType.LCD:
            raise ValueError("Laptop display must be LCD")
        return super().build()
