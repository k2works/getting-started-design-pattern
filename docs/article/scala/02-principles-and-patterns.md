# 第 2 章: パターンを支える基本原則

## はじめに

デザインパターンは「レシピ集」ではありません。パターンの背後には、オブジェクト指向設計の基本原則があります。原則を理解せずにパターンだけを暗記しても、適切な場面で適切なパターンを選べません。

この章では、パターンを支える基本原則を Scala の視点から整理します。

---

## 変化に強い設計の 3 原則

### 1. 変化するものを分離する

最も重要な原則です。「何が変わる可能性があるか」を見極め、変わる部分を独立したモジュールとして切り出します。

```scala
// 悪い例: フォーマットが Report に密結合
class Report:
  def output(): String = "<html>..."

// 良い例: フォーマットを分離
type Formatter = (String, Seq[String]) => String
case class Report(title: String, text: Seq[String], formatter: Formatter)
```

### 2. インターフェースに対してプログラムする

具体的な実装ではなく、抽象（trait）に依存します。Scala では trait がこの役割を果たします。

```scala
trait Writer:
  def writeLine(line: String): String

// 具体実装に依存しない
def processLines(writer: Writer, lines: Seq[String]): Seq[String] =
  lines.map(writer.writeLine)
```

### 3. 継承よりコンポジションを選ぶ

Scala ではこの原則が特に強調されます。trait のミックスインやケースクラスの合成で柔軟な設計を実現します。

```scala
// 継承: 硬直しやすい
class NumberedWriter extends Writer

// コンポジション: 柔軟
class NumberingWriter(wrapped: Writer) extends Writer:
  def writeLine(line: String): String = s"1: ${wrapped.writeLine(line)}"
```

---

## SOLID 原則と Scala

### 単一責任の原則（SRP）

「クラスを変更する理由は 1 つだけであるべき」。Scala のケースクラスはデータの保持に特化し、ビジネスロジックは別の場所に置く設計が自然です。

### 開放閉鎖の原則（OCP）

「拡張に対して開き、修正に対して閉じている」。Scala の enum と拡張メソッドはこの原則を強力にサポートします。

```scala
enum Expression:
  case All
  case FileName(pattern: String)
  // 新しい式を追加しても既存コードは変更不要
```

### リスコフの置換原則（LSP）

「サブタイプはその基底型と置換可能であるべき」。Scala の sealed trait / enum はこの原則を型システムで保証します。

### インターフェース分離の原則（ISP）

「クライアントが使わないメソッドへの依存を強制しない」。Scala の trait は細粒度に定義でき、必要な trait だけをミックスインします。

### 依存性逆転の原則（DIP）

「上位モジュールは下位モジュールに依存すべきでない。どちらも抽象に依存すべき」。Scala の given/using は DIP を自然に実現します。

---

## パターンと原則の対応

| パターン | 主に活用する原則 |
|---------|-----------------|
| Template Method | OCP（フックメソッドで拡張） |
| Strategy | OCP + DIP（関数で差し替え） |
| Observer | OCP（オブザーバーの追加が容易） |
| Composite | LSP（Leaf と Composite が同一インターフェース） |
| Iterator | ISP（Iterable trait のみに依存） |
| Command | SRP（操作のカプセル化） |
| Adapter | DIP（インターフェースの変換） |
| Proxy | LSP（プロキシと実体が同一インターフェース） |
| Decorator | OCP + LSP（動的な機能追加） |
| Singleton | --- （object で言語が保証） |
| Factory | DIP（生成の抽象化） |
| Builder | SRP（構築プロセスの分離） |
| Interpreter | OCP（新しい式の追加が容易） |

---

## まとめ

| 観点 | 内容 |
|------|------|
| **3 原則** | 変化の分離、インターフェース依存、コンポジション優先 |
| **SOLID** | Scala の型システムが原則の遵守をコンパイル時に支援 |
| **パターンとの関係** | パターンは原則の具体的な適用例 |
