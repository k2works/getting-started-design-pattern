# C# で学ぶデザインパターン

## はじめに

本シリーズでは、Russ Olsen『Design Patterns in Ruby』で取り上げられた **13 のデザインパターン**を **C#** で実装します。C# の強力な型システム、LINQ、イベント/デリゲート、`Lazy<T>`、record 型などの言語機能を活かしたモダンな実装を通じて、パターンの本質を学びます。

## 目次

### 第 1 部: パターンの基礎

| 章 | タイトル | 内容 |
|----|---------|------|
| [第 1 章](01-introduction-to-patterns.md) | デザインパターンとパターン思考 | GoF、パターンの分類、変更コスト |
| [第 2 章](02-principles-and-patterns.md) | 設計原則とパターンの関係 | SOLID 原則と C# |
| [第 3 章](03-tdd-and-tooling.md) | TDD とツールチェイン | xUnit、dotnet CLI、TDD サイクル |

### 第 2 部: 振る舞いパターン（前半）

| 章 | タイトル | パターン |
|----|---------|---------|
| [第 4 章](04-template-method.md) | Template Method | 抽象クラスとオーバーライド |
| [第 5 章](05-strategy.md) | Strategy | `Func<T,TResult>` デリゲート |
| [第 6 章](06-observer.md) | Observer | C# イベントと `event` キーワード |
| [第 7 章](07-composite.md) | Composite | 再帰的ツリー構造 |
| [第 8 章](08-iterator.md) | Iterator | `IEnumerable<T>` と LINQ |

### 第 3 部: 振る舞いパターン（後半）と構造パターン

| 章 | タイトル | パターン |
|----|---------|---------|
| [第 9 章](09-command.md) | Command | `ICommand` と Undo |
| [第 10 章](10-adapter.md) | Adapter | インターフェース変換 |
| [第 11 章](11-proxy.md) | Proxy | Protection / Virtual (`Lazy<T>`) |
| [第 12 章](12-decorator.md) | Decorator | デコレータチェイン |

### 第 4 部: 生成パターン

| 章 | タイトル | パターン |
|----|---------|---------|
| [第 13 章](13-singleton.md) | Singleton | `Lazy<T>` によるスレッドセーフ実装 |
| [第 14 章](14-factory.md) | Factory | Factory Method / Abstract Factory |
| [第 15 章](15-builder.md) | Builder | Fluent Builder と record 型 |
| [第 16 章](16-interpreter.md) | Interpreter | Expression ツリー |

## 動作環境

- .NET 9.0
- C# 13
- xUnit（テストフレームワーク）

## プロジェクト構成

```
apps/csharp/design-pattern/
├── DesignPattern.sln
├── src/
│   └── DesignPattern/
│       ├── DesignPattern.csproj
│       └── Patterns/
│           ├── TemplateMethod/Report.cs
│           ├── Strategy/Report.cs
│           └── ...
└── tests/
    └── DesignPattern.Tests/
        ├── DesignPattern.Tests.csproj
        └── Patterns/
            ├── TemplateMethodTest.cs
            └── ...
```

## C# ならではの特徴

本シリーズでは、C# の以下の言語機能を積極的に活用します。

| 機能 | 活用するパターン |
|------|----------------|
| `event` / デリゲート | Observer |
| `Func<T,TResult>` | Strategy |
| `IEnumerable<T>` + LINQ | Iterator |
| `Lazy<T>` | Singleton, Virtual Proxy |
| `record` 型 | Builder (値オブジェクト) |
| パターンマッチング | Factory |
| 抽象クラス / インターフェース | Template Method, Adapter |
