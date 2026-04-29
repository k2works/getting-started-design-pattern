package singleton

import (
	"sync"
	"testing"
)

func setup() {
	ResetForTesting()
}

func TestGetInstanceReturnsSameInstance(t *testing.T) {
	setup()
	a := GetInstance()
	b := GetInstance()
	if a != b {
		t.Error("GetInstance は常に同じインスタンスを返すべき")
	}
}

func TestLogMessage(t *testing.T) {
	setup()
	logger := GetInstance()
	logger.Log("テストメッセージ")

	if logger.Count() != 1 {
		t.Errorf("期待値 1, 実際 %d", logger.Count())
	}
	if logger.Messages()[0] != "テストメッセージ" {
		t.Errorf("期待値 'テストメッセージ', 実際 %q", logger.Messages()[0])
	}
}

func TestClear(t *testing.T) {
	setup()
	logger := GetInstance()
	logger.Log("a")
	logger.Log("b")
	logger.Clear()

	if logger.Count() != 0 {
		t.Errorf("Clear 後の件数は 0 であるべき、実際 %d", logger.Count())
	}
}

func TestString(t *testing.T) {
	setup()
	logger := GetInstance()
	logger.Log("行1")
	logger.Log("行2")

	expected := "行1\n行2"
	if logger.String() != expected {
		t.Errorf("期待値 %q, 実際 %q", expected, logger.String())
	}
}

func TestConcurrentAccess(t *testing.T) {
	setup()
	var wg sync.WaitGroup
	instances := make([]*Logger, 100)

	for i := 0; i < 100; i++ {
		wg.Add(1)
		go func(idx int) {
			defer wg.Done()
			instances[idx] = GetInstance()
		}(i)
	}
	wg.Wait()

	for i := 1; i < 100; i++ {
		if instances[i] != instances[0] {
			t.Error("並行アクセスで異なるインスタンスが返された")
			break
		}
	}
}

func TestConcurrentLog(t *testing.T) {
	setup()
	logger := GetInstance()
	var wg sync.WaitGroup

	for i := 0; i < 50; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			logger.Log("msg")
		}()
	}
	wg.Wait()

	if logger.Count() != 50 {
		t.Errorf("期待値 50, 実際 %d", logger.Count())
	}
}

func TestDescribe(t *testing.T) {
	setup()
	logger := GetInstance()
	logger.Log("a")
	expected := "Logger with 1 messages"
	if logger.Describe() != expected {
		t.Errorf("期待値 %q, 実際 %q", expected, logger.Describe())
	}
}
