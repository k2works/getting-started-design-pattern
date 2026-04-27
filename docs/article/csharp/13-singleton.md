# 第 13 章: Singleton

## はじめに

アプリケーション全体で 1 つのログインスタンスを共有したいとします。複数のインスタンスが存在すると、ログが分散してしまいます。

**Singleton パターン**は、クラスのインスタンスが 1 つしか存在しないことを保証し、そのグローバルなアクセスポイントを提供するパターンです。

---

## パターンの構造

```plantuml
@startuml
title Singleton パターン (C# Lazy<T> 版)

class SingletonLogger {
  - {static} _instance : Lazy<SingletonLogger>
  - _messages : List<string>
  - SingletonLogger()
  + {static} Instance : SingletonLogger
  + Log(message: string)
  + Messages : IReadOnlyList<string>
  + LatestMessage : string
  + MessageCount : int
}

note right of SingletonLogger::_instance
  Lazy<T> により
  スレッドセーフな
  遅延初期化を実現
end note
@enduml
```

---

## TDD で作る

### Red: テストを書く

```csharp
[Fact]
public void SingletonLogger_ReturnsSameInstance()
{
    var logger1 = SingletonLogger.Instance;
    var logger2 = SingletonLogger.Instance;

    Assert.Same(logger1, logger2);
}

[Fact]
public void SingletonLogger_SharedState()
{
    SingletonLogger.Instance.Reset();
    SingletonLogger.Instance.Log("shared message");

    Assert.Equal("shared message", SingletonLogger.Instance.LatestMessage);
}
```

### Green: 最小限の実装

```csharp
public sealed class SingletonLogger
{
    private static readonly Lazy<SingletonLogger> _instance =
        new(() => new SingletonLogger());

    private SingletonLogger() { }

    public static SingletonLogger Instance => _instance.Value;
}
```

---

## C# ならではのポイント

### `Lazy<T>` によるスレッドセーフ実装

```csharp
// .NET の Lazy<T> はデフォルトで LazyThreadSafetyMode.ExecutionAndPublication
// つまり、マルチスレッド環境でも安全に初期化される
private static readonly Lazy<SingletonLogger> _instance =
    new(() => new SingletonLogger());
```

### `sealed` キーワード

```csharp
// sealed で継承を禁止し、Singleton の保証を強化
public sealed class SingletonLogger { }
```

### 古い実装方法との比較

```csharp
// ダブルチェックロッキング（古い方法 - 不要）
private static volatile SingletonLogger? _instance;
private static readonly object _lock = new();

// Lazy<T>（推奨 - 簡潔でスレッドセーフ）
private static readonly Lazy<SingletonLogger> _instance =
    new(() => new SingletonLogger());
```

---

## 他言語との比較

| 観点 | Ruby | Python | C# |
|------|------|--------|-----|
| 実装方法 | モジュール変数 | `__new__` / モジュール | `Lazy<T>` |
| スレッド安全性 | GIL 依存 | GIL 依存 | `Lazy<T>` (組み込み) |
| 継承防止 | 不可 | 不可 | `sealed` キーワード |
| コンストラクタ制御 | `private_class_method` | `__init__` | `private` コンストラクタ |

---

## まとめ

- Singleton パターンは**唯一のインスタンス**を保証する
- C# では `Lazy<T>` により、スレッドセーフな遅延初期化を簡潔に実装できる
- `sealed` + `private` コンストラクタでインスタンス生成を完全に制御
- Singleton の乱用は避け、本当にグローバルな状態が必要な場合にのみ使用する
