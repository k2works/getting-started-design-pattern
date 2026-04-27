# 第 1 章: デザインパターンとパターン思考

## はじめに

デザインパターンとは、ソフトウェア設計で繰り返し現れる問題に対する、再利用可能な解決策のカタログです。GoF（Gang of Four）が 1994 年に体系化した 23 のパターンが有名ですが、本シリーズではその中から実務で特に有用な 13 パターンを取り上げます。

Go 言語でデザインパターンを学ぶことには特別な意味があります。Go にはクラスも継承もありません。オブジェクト指向言語を前提に書かれた GoF のパターンを、Go の言語機能だけで実現する過程で、パターンの「本質」が見えてきます。

---

## パターンとは何か

パターンとは「特定の文脈で繰り返し現れる問題と、その解決策の組み合わせ」です。

```plantuml
@startuml
title パターンの 3 要素

class <<stereotype>> Pattern {
  + context : String
  + problem : String
  + solution : String
}

note right of Pattern::context
  どのような状況で
end note

note right of Pattern::problem
  どのような問題が発生し
end note

note right of Pattern::solution
  どのように解決するか
end note
@enduml
```

---

## GoF パターンの分類

本シリーズで扱う 13 パターンは以下の 3 カテゴリに分類されます。

```plantuml
@startuml
title GoF パターンの分類（本シリーズで扱う 13 パターン）

package "振る舞い（Behavioral）" {
  class <<stereotype>> TemplateMethod
  class <<stereotype>> Strategy
  class <<stereotype>> Observer
  class <<stereotype>> Composite
  class <<stereotype>> Iterator
  class <<stereotype>> Command
  class <<stereotype>> Interpreter
}

package "構造（Structural）" {
  class <<stereotype>> Adapter
  class <<stereotype>> Proxy
  class <<stereotype>> Decorator
}

package "生成（Creational）" {
  class <<stereotype>> Singleton
  class <<stereotype>> Factory
  class <<stereotype>> Builder
}
@enduml
```

---

## Go でパターンを学ぶ意義

Go には以下の特徴があり、パターンの実現方法がクラスベースの言語とは異なります。

| Go の特徴 | パターンへの影響 |
|-----------|----------------|
| クラスがない | struct + メソッドで表現 |
| 継承がない | struct embedding / interface で代替 |
| インターフェースが暗黙的 | structural typing による柔軟な実装 |
| 関数が第一級 | Strategy や Template Method を関数で表現 |
| ゴルーチンとチャネル | Observer を channel で実現可能 |
| `sync.Once` | Singleton のスレッドセーフな初期化 |
| エラー返却 | 例外ではなく `(value, error)` パターン |

---

## 他言語との比較

| 観点 | Ruby | Java | Python | JavaScript | Go |
|------|------|------|--------|------------|-----|
| パラダイム | OOP | OOP | マルチ | プロトタイプ | 構造的 |
| 継承 | あり | あり | あり | プロトタイプ | なし |
| インターフェース | Duck Typing | 明示的 | ABC | なし | 暗黙的 |
| 関数 | Proc/Lambda | SAM | 第一級 | 第一級 | 第一級 |
| 並行処理 | Thread | Thread/FJP | asyncio | Event Loop | goroutine |

---

## まとめ

| 観点 | 内容 |
|------|------|
| **デザインパターンとは** | 繰り返し現れる設計上の問題に対する再利用可能な解決策 |
| **Go で学ぶ意義** | 継承なしでパターンの本質を理解できる |
| **本シリーズの構成** | 13 パターンを TDD で実装しながら学ぶ |
| **次章** | パターンを支える基本原則（SOLID、シンプルな設計の 4 ルール） |
