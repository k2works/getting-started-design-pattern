"""Decorator パターンのテスト"""

from datetime import datetime

from src.decorator_pattern import (
    NumberingWriter,
    SimpleWriter,
    TimeStampingWriter,
    with_numbering,
)


class TestSimpleWriter:
    def test_行を書き込める(self):
        writer = SimpleWriter()
        writer.write_line("Hello")
        assert writer.lines == ["Hello"]

    def test_複数行を書き込める(self):
        writer = SimpleWriter()
        writer.write_line("Line 1")
        writer.write_line("Line 2")
        assert writer.lines == ["Line 1", "Line 2"]


class TestNumberingWriter:
    def test_行番号が付加される(self):
        writer = SimpleWriter()
        numbering = NumberingWriter(writer)
        numbering.write_line("Hello")
        assert numbering.lines == ["1: Hello"]

    def test_行番号がインクリメントされる(self):
        writer = SimpleWriter()
        numbering = NumberingWriter(writer)
        numbering.write_line("First")
        numbering.write_line("Second")
        assert numbering.lines == ["1: First", "2: Second"]


class TestTimeStampingWriter:
    def test_タイムスタンプが付加される(self):
        writer = SimpleWriter()
        fixed_time = datetime(2024, 1, 15, 10, 30, 0)
        ts_writer = TimeStampingWriter(writer, clock=fixed_time)
        ts_writer.write_line("Hello")
        assert ts_writer.lines == ["2024-01-15T10:30:00: Hello"]


class TestDecoratorComposition:
    def test_デコレーターを重ねて使える(self):
        writer = SimpleWriter()
        fixed_time = datetime(2024, 1, 15, 10, 30, 0)
        numbered = NumberingWriter(writer)
        timestamped = TimeStampingWriter(numbered, clock=fixed_time)
        timestamped.write_line("Hello")
        # TimeStamping -> Numbering -> SimpleWriter の順
        assert writer.lines == ["1: 2024-01-15T10:30:00: Hello"]


class TestFunctionDecorator:
    def test_関数デコレーターで行番号を付加できる(self):
        numbering = with_numbering(None)
        assert numbering("Hello") == "1: Hello"
        assert numbering("World") == "2: World"
