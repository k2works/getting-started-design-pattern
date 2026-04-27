# Clojure で学ぶデザインパターン

プロトコル・マルチメソッド・不変データによるパターン代替

## はじめに

本シリーズでは、GoF デザインパターンを Clojure の視点から再解釈します。オブジェクト指向言語で生まれたパターンの多くは、関数型言語では言語機能そのものに吸収されます。Clojure のプロトコル、マルチメソッド、不変データ構造、高階関数、遅延シーケンスといった機能が、従来のパターンをどのように代替・簡素化するかを探ります。

## 目次

### 第 1 部 基礎編

1. [デザインパターンへの誘い](01-introduction-to-patterns.md)
2. [Template Method -- 高階関数による骨格の定義](02-template-method.md)
3. [Strategy -- 関数は最良の戦略](03-strategy.md)
4. [Observer -- atom と watch による状態監視](04-observer.md)

### 第 2 部 構造編

5. [Composite -- 再帰データとマルチメソッド](05-composite.md)
6. [Iterator -- シーケンス抽象という究極の反復子](06-iterator.md)
7. [Command -- マップとクロージャで操作を具体化](07-command.md)
8. [Adapter -- プロトコルによる型適合](08-adapter.md)

### 第 3 部 拡張編

9. [Proxy -- delay と関数ラッパーによる代理](09-proxy.md)
10. [Decorator -- 関数合成による装飾](10-decorator.md)
11. [Singleton -- 名前空間レベルの唯一性](11-singleton.md)
12. [Factory -- マルチメソッドによる生成](12-factory.md)

### 第 4 部 応用編

13. [Builder -- スレッディングマクロで段階構築](13-builder.md)
14. [Interpreter -- データとしての AST](14-interpreter.md)
15. [まとめ -- 関数型パラダイムとパターンの融合](15-and-beyond.md)
16. [Interpreter 応用 -- DSL と評価器](16-interpreter.md)
