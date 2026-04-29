"""Command パターンのテスト"""

import os

from src.command import CompositeCommand, CreateFileCommand, DeleteFileCommand


class TestCreateFileCommand:
    def test_ファイルを作成できる(self, tmp_path):
        path = str(tmp_path / "test.txt")
        cmd = CreateFileCommand(path, "hello")
        cmd.execute()
        assert os.path.exists(path)
        with open(path) as f:
            assert f.read() == "hello"

    def test_作成をundoできる(self, tmp_path):
        path = str(tmp_path / "test.txt")
        cmd = CreateFileCommand(path, "hello")
        cmd.execute()
        cmd.undo()
        assert not os.path.exists(path)

    def test_descriptionを持つ(self):
        cmd = CreateFileCommand("/tmp/test.txt", "hello")
        assert "Create file" in cmd.description


class TestDeleteFileCommand:
    def test_ファイルを削除できる(self, tmp_path):
        path = str(tmp_path / "test.txt")
        with open(path, "w") as f:
            f.write("content")
        cmd = DeleteFileCommand(path)
        cmd.execute()
        assert not os.path.exists(path)

    def test_削除をundoできる(self, tmp_path):
        path = str(tmp_path / "test.txt")
        with open(path, "w") as f:
            f.write("content")
        cmd = DeleteFileCommand(path)
        cmd.execute()
        cmd.undo()
        assert os.path.exists(path)
        with open(path) as f:
            assert f.read() == "content"


class TestCompositeCommand:
    def test_複合コマンドを実行できる(self, tmp_path):
        path1 = str(tmp_path / "file1.txt")
        path2 = str(tmp_path / "file2.txt")

        composite = CompositeCommand()
        composite.add_command(CreateFileCommand(path1, "aaa"))
        composite.add_command(CreateFileCommand(path2, "bbb"))
        composite.execute()

        assert os.path.exists(path1)
        assert os.path.exists(path2)

    def test_複合コマンドをundoできる(self, tmp_path):
        path1 = str(tmp_path / "file1.txt")
        path2 = str(tmp_path / "file2.txt")

        composite = CompositeCommand()
        composite.add_command(CreateFileCommand(path1, "aaa"))
        composite.add_command(CreateFileCommand(path2, "bbb"))
        composite.execute()
        composite.undo()

        assert not os.path.exists(path1)
        assert not os.path.exists(path2)
