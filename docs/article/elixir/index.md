# Elixir で学ぶデザインパターン入門

## テーマ: Behaviour・プロセス・パイプラインによるパターン

Elixir は Erlang VM (BEAM) 上で動作する関数型言語です。不変データ構造、パターンマッチング、パイプライン演算子 `|>`、Protocol、高階関数といった言語機能により、オブジェクト指向言語とは異なるアプローチでデザインパターンを表現できます。

本シリーズでは、GoF の 13 のデザインパターンを Elixir の関数型スタイルで再解釈し、TDD で実装していきます。

## 目次

### 第 1 部: 基礎編

| 章 | タイトル | パターン |
|:---:|:---|:---|
| 1 | [デザインパターンへの誘い](01-introduction-to-patterns.md) | - |
| 2 | [Elixir とパターンの世界](02-elixir-and-patterns.md) | - |
| 3 | [TDD で始めるパターン実装](03-tdd-and-patterns.md) | - |

### 第 2 部: 振る舞いのパターン

| 章 | タイトル | パターン |
|:---:|:---|:---|
| 4 | [高階関数でアルゴリズムの骨格を定める](04-template-method.md) | Template Method |
| 5 | [関数を渡してアルゴリズムを切り替える](05-strategy.md) | Strategy |
| 6 | [コールバックで変化を通知する](06-observer.md) | Observer |
| 7 | [再帰で木構造を統一的に扱う](07-composite.md) | Composite |
| 8 | [Enum と Stream で走査する](08-iterator.md) | Iterator |
| 9 | [操作をデータとして扱う](09-command.md) | Command |

### 第 3 部: 構造のパターン

| 章 | タイトル | パターン |
|:---:|:---|:---|
| 10 | [Protocol でインターフェースを合わせる](10-adapter.md) | Adapter |
| 11 | [遅延評価とアクセス制御で間接化する](11-proxy.md) | Proxy |
| 12 | [パイプラインで機能を積み重ねる](12-decorator.md) | Decorator |

### 第 4 部: 生成のパターン

| 章 | タイトル | パターン |
|:---:|:---|:---|
| 13 | [Application 環境で唯一の状態を管理する](13-singleton.md) | Singleton |
| 14 | [パターンマッチングで適切なデータを生成する](14-factory.md) | Factory |
| 15 | [パイプラインで段階的に構築する](15-builder.md) | Builder |
| 16 | [タグ付きタプルで言語を解釈する](16-interpreter.md) | Interpreter |

## 動作環境

- Elixir 1.18 以降
- Erlang/OTP 27 以降

## テストの実行

```bash
cd apps/elixir/design-pattern
mix test
```
