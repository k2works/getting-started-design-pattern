# 第 1 章：パターン入門 — なぜ関数型でパターンを学ぶのか

## はじめに

デザインパターンは、ソフトウェア設計における繰り返し発生する問題への定石的な解決策です。GoF（Gang of Four）が 1994 年に体系化した 23 のパターンは、オブジェクト指向プログラミングの文脈で生まれました。

F# のような関数型ファーストの言語では、多くの GoF パターンが言語機能として組み込まれています。Peter Norvig が指摘したように、「デザインパターンの多くは、言語の制約を補うものである」のです。

## 「パターンが不要になる」関数型の視点

OOP では、振る舞いの差し替えにインターフェースと継承を使います。F# では、関数が第一級値であるため、関数を渡すだけで同じことが実現できます。

```fsharp
// OOP 的アプローチ（C#）:
// interface IStrategy { string Format(string text); }
// class HtmlStrategy : IStrategy { ... }

// F# のアプローチ: 関数を渡すだけ
let format (strategy: string -> string) text = strategy text
let html text = sprintf "<p>%s</p>" text
let result = format html "Hello"
```

## パターンの構造

```plantuml
@startuml
title GoF パターンと F# の対応

class <<module>> "高階関数" as HOF {
  Strategy
  Template Method
  Command
}

class <<module>> "判別共用体" as DU {
  Composite
  Factory
  Interpreter
}

class <<module>> "関数合成" as FC {
  Decorator
}

class <<module>> "モジュール" as Mod {
  Singleton
}

class <<module>> "Lazy / ラッパー" as Lazy {
  Proxy
}

class <<module>> "コンピュテーション式" as CE {
  Builder
}

class <<module>> "シーケンス式" as Seq {
  Iterator
}

class <<module>> "コールバック" as CB {
  Observer
}

class <<module>> "レコード型" as Rec {
  Adapter
}

@enduml
```

## TDD で学ぶ

本シリーズでは、すべてのパターンを TDD（テスト駆動開発）で実装します。

1. **Red** — パターンの振る舞いを表現する失敗テストを書く
2. **Green** — テストを通す最小の F# コードを書く
3. **Refactor** — 関数型イディオムでコードを改善する

## OOP 版（C#）との比較

各章では、C# での典型的な実装と F# での実装を比較します。これにより、関数型言語がどのようにパターンの複雑さを解消するかを理解できます。

## まとめ

- GoF パターンの多くは、OOP 言語の制約を補うために存在する
- F# では言語機能が直接パターンの役割を果たす
- パターンの「意図」は有効だが、「実装」は大幅に簡素化される
- TDD で段階的にパターンを学ぶことで、実践的な理解が得られる
