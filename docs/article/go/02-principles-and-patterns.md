# 第 2 章: パターンを支える基本原則

## はじめに

デザインパターンを効果的に使うには、その背景にある設計原則を理解する必要があります。本章では SOLID 原則とシンプルな設計の 4 つのルールを Go の視点から解説します。

---

## SOLID 原則と Go

### 単一責任の原則（SRP）

Go ではパッケージ単位で責務を分離します。1 つのパッケージは 1 つの責務を持ちます。

```plantuml
@startuml
title 単一責任の原則

package "templatemethod" {
  class <<struct>> ReportFormat {
    + OutputStart : func
    + OutputLine : func
  }
}

package "strategy" {
  class <<struct>> Report {
    + Formatter : func
  }
}

note "パッケージごとに\n1 つの責務" as N1
@enduml
```

### 開放閉鎖の原則（OCP）

Go ではインターフェースを使って拡張に対して開き、修正に対して閉じます。新しい型を追加するだけで、既存コードを変更せずに振る舞いを拡張できます。

### リスコフの置換原則（LSP）

Go のインターフェースは暗黙的に実装されるため、メソッドシグネチャが一致すれば置換可能です。

### インターフェース分離の原則（ISP）

Go では小さなインターフェースを推奨します。`io.Reader`、`io.Writer` のように 1-2 メソッドのインターフェースが標準ライブラリに多数あります。

### 依存性逆転の原則（DIP）

Go では具象型ではなくインターフェースに依存することで、依存の方向を逆転させます。

---

## シンプルな設計の 4 つのルール

Kent Beck が提唱した 4 つのルールを Go に当てはめます。

```plantuml
@startuml
title シンプルな設計の 4 つのルール（優先度順）

class <<stereotype>> SimpleDesign {
  + 1. すべてのテストが通る
  + 2. 意図が明確に表現されている
  + 3. 重複がない
  + 4. 要素が最小
}
@enduml
```

| ルール | Go での実践 |
|--------|-----------|
| テストが通る | `go test ./...` ですべてのテストが PASS |
| 意図が明確 | 明確な命名、小さな関数、Go doc コメント |
| 重複がない | interface を使った共通化、embedding |
| 要素が最小 | 使われない export を排除、パッケージを分割 |

---

## Go 特有の設計哲学

Go のことわざ（Go Proverbs）には設計原則に通じるものがあります。

- **"Accept interfaces, return structs"** — 引数はインターフェース、戻り値は具象型
- **"A little copying is better than a little dependency"** — 小さな重複は小さな依存より良い
- **"Make the zero value useful"** — ゼロ値を有用にする
- **"Don't communicate by sharing memory; share memory by communicating"** — チャネルで通信する

---

## まとめ

| 観点 | 内容 |
|------|------|
| **SOLID** | Go のインターフェースとパッケージで自然に実現 |
| **シンプルな設計** | テスト + 明確な命名 + 最小要素 |
| **Go の哲学** | 小さなインターフェース、暗黙的実装、ゼロ値の活用 |
| **次章** | 開発環境と TDD 基盤のセットアップ |
