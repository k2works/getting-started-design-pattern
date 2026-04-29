# F# で学ぶデザインパターン

## はじめに

本シリーズでは、GoF（Gang of Four）のデザインパターンを F# の視点から学びます。F# は関数型ファーストの言語であり、GoF パターンの多くは言語機能で自然に代替されます。

## 関数型言語とデザインパターン

GoF パターンはオブジェクト指向言語の制約を補うために生まれました。F# では以下の言語機能がパターンの役割を果たします。

| 言語機能 | 代替されるパターン |
|:---|:---|
| 高階関数 | Strategy, Template Method, Command |
| 判別共用体 | Composite, Factory, Interpreter |
| パターンマッチング | Visitor, 条件分岐の排除 |
| 関数合成（`>>`） | Decorator |
| モジュール | Singleton |
| `Lazy<T>` | Proxy（仮想） |
| コンピュテーション式 | Builder |
| シーケンス式 | Iterator |

## 章構成

### 第 1 部：基礎パターン

1. [パターン入門](01-introduction-to-patterns.md) — なぜ関数型でパターンを学ぶのか
2. [Template Method](02-template-method.md) — 高階関数で「穴埋め」する
3. [Strategy](03-strategy.md) — 関数を値として渡す
4. [Observer](04-observer.md) — コールバック関数とイベント

### 第 2 部：構造パターン

5. [Composite](05-composite.md) — 判別共用体で木構造を表現する
6. [Iterator](06-iterator.md) — シーケンス式と遅延評価
7. [Command](07-command.md) — 関数でコマンドを表現する
8. [Adapter](08-adapter.md) — レコード型とアダプター関数

### 第 3 部：さらなる構造パターン

9. [Proxy](09-proxy.md) — Lazy と関数ラッパー
10. [Decorator](10-decorator.md) — 関数合成でデコレートする
11. [Singleton](11-singleton.md) — モジュールレベル束縛
12. [Factory](12-factory.md) — 判別共用体とファクトリ関数

### 第 4 部：高度なパターン

13. [Builder](13-builder.md) — コンピュテーション式とパイプライン
14. [Interpreter](14-interpreter.md) — 判別共用体で AST を表現する

### まとめ

15. [パターンの総括](15-patterns-summary.md) — OOP vs 関数型の比較
16. [F# らしい設計](16-interpreter.md) — 関数型イディオムとしてのパターン

## 対象読者

- F# の基本構文を理解している方
- OOP のデザインパターンを学んだことがある方
- 関数型プログラミングでの設計手法を知りたい方

## 使用技術

- F# (.NET 9.0)
- xUnit（テスティングフレームワーク）
