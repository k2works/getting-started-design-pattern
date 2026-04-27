# 第 2 章: パターンを支える基本原則

## はじめに

Java ではインターフェースと抽象クラスにより、設計原則を言語レベルで強制できます。Ruby の Duck Typing が「信頼」に基づく設計であるのに対し、Java は「契約」に基づく設計です。

---

## 4 つの設計原則

### 1. 変化するものを分離する

```java
// インターフェースで変化する部分を宣言
interface Formatter {
    String format(Report report);
}

class HtmlFormatter implements Formatter {
    public String format(Report report) { /* HTML 出力 */ }
}

class PlainTextFormatter implements Formatter {
    public String format(Report report) { /* テキスト出力 */ }
}
```

### 2. インターフェースに対してプログラムする

Java ではこの原則が最も明確に表現されます。`interface` キーワードで抽象型を宣言し、実装を切り替えます。

```java
// インターフェースに依存（具象クラスに依存しない）
Report report = new Report(new HtmlFormatter());
```

### 3. 継承より委譲を選ぶ

Java でも継承は強力ですが、`final` クラスや `sealed` クラス（Java 17+）が示すように、過度な継承は推奨されません。

### 4. YAGNI

フレームワーク開発でない限り、将来の拡張に備えた過剰な抽象化は避けます。

---

## SOLID 原則と Java

| 原則 | Java での表現 |
|------|-------------|
| **S** - 単一責任 | 1 クラス 1 責務。`Report` はデータ保持、`Formatter` は出力 |
| **O** - 開放閉鎖 | `interface` で拡張ポイントを定義。新しい `Formatter` を追加しても `Report` は変更不要 |
| **L** - リスコフの置換 | `HtmlFormatter` と `PlainTextFormatter` は `Formatter` として交換可能 |
| **I** - インターフェース分離 | 大きなインターフェースを小さな機能単位に分割 |
| **D** - 依存性逆転 | 上位モジュール（`Report`）はインターフェース（`Formatter`）に依存 |

---

## パターンと原則の対応

| パターン | 主に活用する原則 | Java の特徴 |
|---------|-----------------|-------------|
| Template Method | OCP, LSP | `abstract class` + `abstract method` |
| Strategy | SRP, OCP, DIP | `interface` + ラムダ式 |
| Observer | SRP, OCP | リスナーインターフェース |
| Iterator | SRP, ISP | `Iterable<T>` / `Iterator<T>` |
| Factory | DIP, OCP | 戻り値型をインターフェースにする |

---

## まとめ

- Java のインターフェースは設計原則を型安全に強制する仕組みである
- SOLID 原則はパターンの基盤であり、Java で最も自然に適用できる
- Ruby が Duck Typing で暗黙的に満たす原則を、Java は明示的な型宣言で保証する
