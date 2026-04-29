package interpreter

import (
	"os"
	"path/filepath"
	"sort"
	"testing"
)

func setupTestDir(t *testing.T) string {
	t.Helper()
	dir := t.TempDir()
	files := map[string]string{
		"report.txt":  "short",
		"data.csv":    "this is a longer file with more content inside it",
		"image.png":   "binary data placeholder for testing size",
		"readme.md":   "# Readme",
		"notes.txt":   "some notes here for testing purposes and more text",
		"script.go":   "package main\nfunc main() {}\n",
	}
	for name, content := range files {
		if err := os.WriteFile(filepath.Join(dir, name), []byte(content), 0644); err != nil {
			t.Fatalf("テストファイル作成失敗: %v", err)
		}
	}
	return dir
}

func sorted(s []string) []string {
	sort.Strings(s)
	return s
}

func TestAllExpression(t *testing.T) {
	dir := setupTestDir(t)
	result := (&All{}).Evaluate(dir)

	if len(result) != 6 {
		t.Errorf("期待値 6 ファイル, 実際 %d", len(result))
	}
}

func TestFileNameExpression(t *testing.T) {
	dir := setupTestDir(t)
	expr := &FileName{Pattern: "*.txt"}
	result := sorted(expr.Evaluate(dir))

	if len(result) != 2 {
		t.Errorf("期待値 2 ファイル, 実際 %d: %v", len(result), result)
	}
}

func TestBiggerExpression(t *testing.T) {
	dir := setupTestDir(t)
	expr := &Bigger{Size: 10, Inner: &All{}}
	result := expr.Evaluate(dir)

	// Files with content > 10 bytes
	if len(result) == 0 {
		t.Error("10 バイトより大きいファイルが存在するはず")
	}
}

func TestNotExpression(t *testing.T) {
	dir := setupTestDir(t)
	expr := &Not{Inner: &FileName{Pattern: "*.txt"}}
	result := sorted(expr.Evaluate(dir))

	if len(result) != 4 {
		t.Errorf("期待値 4 ファイル, 実際 %d: %v", len(result), result)
	}
	for _, name := range result {
		if filepath.Ext(name) == ".txt" {
			t.Errorf(".txt ファイルが含まれるべきではない: %s", name)
		}
	}
}

func TestAndExpression(t *testing.T) {
	dir := setupTestDir(t)
	expr := &And{
		Left:  &FileName{Pattern: "*.txt"},
		Right: &Bigger{Size: 10, Inner: &All{}},
	}
	result := expr.Evaluate(dir)

	for _, name := range result {
		if filepath.Ext(name) != ".txt" {
			t.Errorf(".txt ファイルのみであるべき: %s", name)
		}
	}
}

func TestOrExpression(t *testing.T) {
	dir := setupTestDir(t)
	expr := &Or{
		Left:  &FileName{Pattern: "*.txt"},
		Right: &FileName{Pattern: "*.md"},
	}
	result := sorted(expr.Evaluate(dir))

	if len(result) != 3 {
		t.Errorf("期待値 3 ファイル (.txt x2 + .md x1), 実際 %d: %v", len(result), result)
	}
}

func TestWithExtension(t *testing.T) {
	dir := setupTestDir(t)
	expr := &WithExtension{Ext: "go"}
	result := expr.Evaluate(dir)

	if len(result) != 1 {
		t.Errorf("期待値 1 ファイル, 実際 %d: %v", len(result), result)
	}
	if len(result) > 0 && result[0] != "script.go" {
		t.Errorf("期待値 'script.go', 実際 %q", result[0])
	}
}

func TestComplexExpression(t *testing.T) {
	dir := setupTestDir(t)
	// (.txt OR .md) AND NOT bigger than 10 bytes
	expr := &And{
		Left: &Or{
			Left:  &FileName{Pattern: "*.txt"},
			Right: &FileName{Pattern: "*.md"},
		},
		Right: &Not{
			Inner: &Bigger{Size: 10, Inner: &All{}},
		},
	}
	result := expr.Evaluate(dir)

	for _, name := range result {
		ext := filepath.Ext(name)
		if ext != ".txt" && ext != ".md" {
			t.Errorf(".txt または .md のみであるべき: %s", name)
		}
	}
}
