"""Interpreter パターンのテスト"""

import os
import tempfile

from src.interpreter import All, And, Bigger, FileName, Not, Or


class TestInterpreter:
    """一時ディレクトリにテスト用ファイルを作成して検証"""

    def setup_method(self):
        self.tmpdir = tempfile.mkdtemp()
        # テスト用ファイルを作成
        self._create_file("hello.txt", "Hello World")
        self._create_file("readme.md", "# README")
        self._create_file("data.txt", "x" * 1000)
        os.makedirs(os.path.join(self.tmpdir, "sub"), exist_ok=True)
        self._create_file("sub/nested.txt", "nested")

    def _create_file(self, name: str, content: str) -> None:
        path = os.path.join(self.tmpdir, name)
        with open(path, "w") as f:
            f.write(content)

    def test_allが全ファイルを返す(self):
        result = All().evaluate(self.tmpdir)
        assert len(result) == 4

    def test_filenameがパターンにマッチするファイルを返す(self):
        result = FileName("*.txt").evaluate(self.tmpdir)
        names = [os.path.basename(p) for p in result]
        assert "hello.txt" in names
        assert "data.txt" in names
        assert "readme.md" not in names

    def test_biggerが指定サイズ以上のファイルを返す(self):
        result = Bigger(500).evaluate(self.tmpdir)
        names = [os.path.basename(p) for p in result]
        assert "data.txt" in names
        assert "hello.txt" not in names

    def test_and演算子で式を組み合わせる(self):
        expr = FileName("*.txt") & Bigger(500)
        result = expr.evaluate(self.tmpdir)
        names = [os.path.basename(p) for p in result]
        assert names == ["data.txt"]

    def test_or演算子で式を組み合わせる(self):
        expr = FileName("*.md") | FileName("*.txt")
        result = expr.evaluate(self.tmpdir)
        assert len(result) == 4  # 3 txt + 1 md

    def test_not式で除外する(self):
        expr = Not(FileName("*.md"))
        result = expr.evaluate(self.tmpdir)
        names = [os.path.basename(p) for p in result]
        assert "readme.md" not in names
        assert "hello.txt" in names

    def test_ネストしたディレクトリのファイルも検索する(self):
        result = FileName("*.txt").evaluate(self.tmpdir)
        names = [os.path.basename(p) for p in result]
        assert "nested.txt" in names
