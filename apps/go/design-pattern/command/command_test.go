package command

import (
	"os"
	"path/filepath"
	"testing"
)

func tempPath(t *testing.T, name string) string {
	t.Helper()
	return filepath.Join(t.TempDir(), name)
}

func TestCreateFileCommand(t *testing.T) {
	path := tempPath(t, "test.txt")
	cmd := &CreateFileCommand{Path: path, Content: "hello"}

	if err := cmd.Execute(); err != nil {
		t.Fatalf("Execute 失敗: %v", err)
	}

	data, err := os.ReadFile(path)
	if err != nil {
		t.Fatalf("ファイル読み取り失敗: %v", err)
	}
	if string(data) != "hello" {
		t.Errorf("期待値 'hello', 実際 %q", string(data))
	}
}

func TestCreateFileCommandUndo(t *testing.T) {
	path := tempPath(t, "test.txt")
	cmd := &CreateFileCommand{Path: path, Content: "hello"}

	_ = cmd.Execute()
	if err := cmd.Undo(); err != nil {
		t.Fatalf("Undo 失敗: %v", err)
	}

	if _, err := os.Stat(path); !os.IsNotExist(err) {
		t.Error("Undo 後にファイルが残っている")
	}
}

func TestDeleteFileCommand(t *testing.T) {
	path := tempPath(t, "test.txt")
	_ = os.WriteFile(path, []byte("content"), 0644)

	cmd := &DeleteFileCommand{Path: path}
	if err := cmd.Execute(); err != nil {
		t.Fatalf("Execute 失敗: %v", err)
	}

	if _, err := os.Stat(path); !os.IsNotExist(err) {
		t.Error("削除後にファイルが残っている")
	}
}

func TestDeleteFileCommandUndo(t *testing.T) {
	path := tempPath(t, "test.txt")
	_ = os.WriteFile(path, []byte("content"), 0644)

	cmd := &DeleteFileCommand{Path: path}
	_ = cmd.Execute()

	if err := cmd.Undo(); err != nil {
		t.Fatalf("Undo 失敗: %v", err)
	}

	data, err := os.ReadFile(path)
	if err != nil {
		t.Fatalf("Undo 後のファイル読み取り失敗: %v", err)
	}
	if string(data) != "content" {
		t.Errorf("期待値 'content', 実際 %q", string(data))
	}
}

func TestCompositeCommand(t *testing.T) {
	dir := t.TempDir()
	path1 := filepath.Join(dir, "file1.txt")
	path2 := filepath.Join(dir, "file2.txt")

	cc := &CompositeCommand{
		Commands: []Command{
			&CreateFileCommand{Path: path1, Content: "a"},
			&CreateFileCommand{Path: path2, Content: "b"},
		},
	}

	if err := cc.Execute(); err != nil {
		t.Fatalf("Execute 失敗: %v", err)
	}

	if _, err := os.Stat(path1); os.IsNotExist(err) {
		t.Error("file1 が作成されていない")
	}
	if _, err := os.Stat(path2); os.IsNotExist(err) {
		t.Error("file2 が作成されていない")
	}
}

func TestCompositeCommandUndo(t *testing.T) {
	dir := t.TempDir()
	path1 := filepath.Join(dir, "file1.txt")
	path2 := filepath.Join(dir, "file2.txt")

	cc := &CompositeCommand{
		Commands: []Command{
			&CreateFileCommand{Path: path1, Content: "a"},
			&CreateFileCommand{Path: path2, Content: "b"},
		},
	}

	_ = cc.Execute()
	if err := cc.Undo(); err != nil {
		t.Fatalf("Undo 失敗: %v", err)
	}

	if _, err := os.Stat(path1); !os.IsNotExist(err) {
		t.Error("Undo 後に file1 が残っている")
	}
	if _, err := os.Stat(path2); !os.IsNotExist(err) {
		t.Error("Undo 後に file2 が残っている")
	}
}

func TestCommandDescription(t *testing.T) {
	cmd := &CreateFileCommand{Path: "/tmp/test.txt", Content: ""}
	if cmd.Description() != "ファイル作成: /tmp/test.txt" {
		t.Errorf("Description が期待通りでない: %s", cmd.Description())
	}
}
