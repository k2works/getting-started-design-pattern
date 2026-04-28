# 第 1 章 デザインパターンへの誘い

## はじめに

デザインパターンとは、ソフトウェア設計で繰り返し現れる問題に対する再利用可能な解決策のカタログです。1994 年に GoF（Gang of Four）が体系化した 23 のパターンは、オブジェクト指向プログラミングの文脈で生まれました。

---

## Clojure とデザインパター��

Clojure は関数型プログラミング言語であり、JVM 上で動作��ます。不変データ、第一級関数、マルチメソッド、プロトコルといった言語機能を持ち、オブジェクト指向言語とは異なるアプローチで問題を解決します。

多くの GoF パターンは、オブジェクト指向言語の制約を回避するための工夫でした。Clojure ではそれらの制約がそもそも存在しないため、パターンが言語機能に吸収されることが多くあります。

---

## パターンの Clojure 的解釈

| GoF パターン | Clojure での対応 |
|:---|:---|
| Template Method | 高階関数 |
| Strategy | 関数を引数として渡す |
| Observer | atom + add-watch |
| Composite | 再帰的データ構造 + マルチメソッド |
| Iterator | シーケンス抽象（lazy-seq） |
| Command | マップ（:execute, :undo） |
| Adapter | プロトコル + reify |
| Proxy | delay/force、関数ラッパー |
| Decorator | 関数合成（comp） |
| Singleton | def / defonce |
| Factory | マルチメソッド |
| Builder | スレッディングマクロ（->） |
| Interpreter | データとしての AST + マルチメソッド |

---

## 本シリーズの構成

4 部 16 章で構成し、各章ではパターンの意図、Clojure での実装、テストコードを示します。

### 第 1 部: パターンとは何か（第 1〜3 章）

デザインパターンの基礎、設計原則、開発環境のセットアップを扱います。

### 第 2 部: 振る舞いの取り扱い（第 4〜8 章）

Template Method、Strategy、Observer、Composite、Iterator の 5 パター���を扱います。

### 第 3 部: 操作と関係の表現（第 9〜12 章）

Command、Adapter、Proxy、Decorator の 4 パターンを扱います。

### 第 4 部: オブジェクトの作成と解釈（第 13〜16 章）

Singleton、Factory、Builder、Interpreter の 4 パターンを扱います。

---

## Clojure プロジェクトの構成

```
apps/clojure/design-pattern/
├── project.clj
├── src/design_pattern/
│   ├── template_method.clj
│   ├── strategy.clj
│   └── ...
└── test/design_pattern/
    ├── template_method_test.clj
    └── ...
```

テストの実行は以下のコマンドで行います。

```bash
lein test
```

---

## まとめ

- デザインパターンはソフトウェア設計の問題に対する再利用可能な解決策である
- Clojure の関数型特性により、多くのパターンが言語機能に吸収される
- 本シリーズでは 4 部 16 章で 13 のパターンを TDD で実装する
- 次章ではパターンを支える基本原則を Clojure の視点から解説する
