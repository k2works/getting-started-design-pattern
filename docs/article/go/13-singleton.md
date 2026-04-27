# 第 13 章: Singleton

## はじめに

アプリケーション全体で 1 つだけのロガーインスタンスを共有したいとします。Singleton パターンは、クラスのインスタンスが 1 つだけ存在することを保証するパターンです。

Go では `sync.Once` を使うことで、スレッドセーフな Singleton を簡潔に実現できます。

---

## パターンの構造

```plantuml
@startuml
title Singleton パターン（Go 版）

class <<struct>> Logger {
  - messages : []string
  - mu : sync.Mutex
  + Log(message string)
  + Messages() : []string
  + Count() : int
  + Clear()
}

class <<package>> "singleton" {
  - instance : *Logger
  - once : sync.Once
  + GetInstance() : *Logger
}

"singleton" --> Logger : creates once
@enduml
```

---

## TDD で作る

### Red: テストを書く

```go
func TestGetInstanceReturnsSameInstance(t *testing.T) {
    a := GetInstance()
    b := GetInstance()
    if a != b {
        t.Error("GetInstance は常に同じインスタンスを返すべき")
    }
}

func TestConcurrentAccess(t *testing.T) {
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
    // 全インスタンスが同一であることを確認
}
```

### Green: 実装する

```go
var (
    instance *Logger
    once     sync.Once
)

func GetInstance() *Logger {
    once.Do(func() {
        instance = &Logger{}
    })
    return instance
}
```

### Refactor: 振り返り

- `sync.Once` は goroutine セーフな 1 回だけの初期化を保証します
- `sync.Mutex` でログ操作もスレッドセーフにしています
- テスト用に `ResetForTesting()` を提供し、テスト間の独立性を確保しています

---

## Ruby / Java / Python / JavaScript との比較

| 観点 | Ruby | Java | Python | JavaScript | Go |
|------|------|------|--------|------------|-----|
| 実現方法 | クラス変数 | static holder | モジュール | モジュールスコープ | sync.Once |
| スレッド安全 | Mutex | クラスローダ | GIL | シングルスレッド | sync.Once |
| 遅延初期化 | `||=` | lazy holder | `__new__` | モジュールキャッシュ | Once.Do |
| テスト対策 | リセット | リフレクション | モンキーパッチ | jest.resetModules | ResetForTesting |

**Go の特徴**: `sync.Once` が「1 回だけの初期化」と「goroutine 安全性」の両方を保証します。

---

## まとめ

| 観点 | 内容 |
|------|------|
| **意図** | インスタンスが 1 つだけ存在することを保証する |
| **Go での実現** | パッケージレベル変数 + sync.Once |
| **メリット** | goroutine セーフ、簡潔な実装 |
| **注意点** | テスト時のリセットが必要、グローバル状態は結合度を高める |
| **関連パターン** | Factory（インスタンス生成の制御）、Abstract Factory |
