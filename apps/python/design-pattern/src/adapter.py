"""Adapter パターン

BritishTextObject（mm / colour）を TextObject インターフェース
（inches / color）に適合させる。
"""

from typing import Protocol


class TextObject(Protocol):
    """テキストオブジェクトプロトコル（Target）"""

    @property
    def text(self) -> str: ...

    @property
    def size_inches(self) -> float: ...

    @property
    def color(self) -> str: ...


class BritishTextObject:
    """英国式テキストオブジェクト（Adaptee）"""

    def __init__(self, string: str, size_mm: float, colour: str) -> None:
        self.string = string
        self.size_mm = size_mm
        self.colour = colour


class BritishTextObjectAdapter:
    """Adapter: BritishTextObject を TextObject に適合させる"""

    def __init__(self, bto: BritishTextObject) -> None:
        self._bto = bto

    @property
    def text(self) -> str:
        return self._bto.string

    @property
    def size_inches(self) -> float:
        return self._bto.size_mm / 25.4

    @property
    def color(self) -> str:
        return self._bto.colour


class Renderer:
    """レンダラー（Client）"""

    def render(self, text_object: TextObject) -> str:
        return (
            f"text:{text_object.text} "
            f"size:{text_object.size_inches} "
            f"color:{text_object.color}"
        )
