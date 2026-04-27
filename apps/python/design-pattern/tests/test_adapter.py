"""Adapter パターンのテスト"""

from src.adapter import BritishTextObject, BritishTextObjectAdapter, Renderer


class TestBritishTextObjectAdapter:
    def test_textプロパティがstringを返す(self):
        bto = BritishTextObject("Hello", 25.4, "red")
        adapter = BritishTextObjectAdapter(bto)
        assert adapter.text == "Hello"

    def test_size_inchesがmmからインチに変換する(self):
        bto = BritishTextObject("Hello", 25.4, "red")
        adapter = BritishTextObjectAdapter(bto)
        assert adapter.size_inches == pytest.approx(1.0)

    def test_colorプロパティがcolourを返す(self):
        bto = BritishTextObject("Hello", 25.4, "red")
        adapter = BritishTextObjectAdapter(bto)
        assert adapter.color == "red"

    def test_レンダラーがアダプターを使用できる(self):
        bto = BritishTextObject("Hello", 50.8, "blue")
        adapter = BritishTextObjectAdapter(bto)
        renderer = Renderer()
        result = renderer.render(adapter)
        assert "text:Hello" in result
        assert "size:2.0" in result
        assert "color:blue" in result


class TestRenderer:
    def test_レンダラーの出力形式(self):
        bto = BritishTextObject("Test", 25.4, "green")
        adapter = BritishTextObjectAdapter(bto)
        renderer = Renderer()
        result = renderer.render(adapter)
        assert result == "text:Test size:1.0 color:green"


import pytest
