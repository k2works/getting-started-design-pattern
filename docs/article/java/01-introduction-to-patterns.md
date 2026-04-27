# 第 1 章: デザインパターンとパターン思考

## はじめに

Java は GoF 『Design Patterns』 のメインターゲット言語です。1994 年の GoF 本は C++ と Smalltalk で書かれましたが、その直後に登場した Java は、インターフェースと抽象クラスという仕組みによってパターンを最も自然に表現できる言語となりました。

本シリーズでは、GoF の 13 パターンを Java の TDD（JUnit 5）で実装しながら学びます。

---

## デザインパターンとは何か

### GoF と Java

GoF の 23 パターンは、オブジェクト指向設計の共通語彙を確立しました。Java は以下の理由でパターンとの親和性が高い言語です。

- **インターフェース**: 抽象型を明示的に宣言でき、Strategy / Observer / Iterator などのパターンを型安全に表現できる
- **抽象クラス**: Template Method パターンの基底クラスを `abstract` で厳密に定義できる
- **ジェネリクス**: 型パラメータによって Composite / Iterator を型安全に実装できる
- **ラムダ式（Java 8+）**: Strategy / Command を軽量に表現できる

### 本シリーズで扱うパターン

| カテゴリ | パターン | Java での特徴 |
|---------|---------|--------------|
| **生成** | Singleton, Factory, Builder | enum Singleton、流暢なインターフェース |
| **構造** | Adapter, Composite, Proxy, Decorator | java.io の Decorator、動的プロキシ |
| **振る舞い** | Template Method, Strategy, Observer, Iterator, Command, Interpreter | 関数型インターフェース、Iterable |

---

## パターンが解く問題

すべてのパターンの核心は「**変化するものを、変化しないものから分離する**」ことです。

Java ではこの分離を**インターフェース**で実現します。

```java
// 変化する部分をインターフェースで抽象化
interface Formatter {
    String format(String title, List<String> text);
}

// 変化しない部分
class Report {
    private final Formatter formatter;

    Report(Formatter formatter) {
        this.formatter = formatter;
    }

    String output() {
        return formatter.format(title, text);
    }
}
```

---

## 本シリーズの読み方

各パターン章は **TDD の Red-Green-Refactor サイクル**で進みます。

1. **Red**: JUnit 5 でパターンの期待動作をテストで定義する
2. **Green**: テストを通す最小限の実装を書く
3. **Refactor**: パターンの構造に沿ってリファクタリングする

さらに各章末に「**Ruby との比較**」セクションを設け、動的型付け（Duck Typing）と静的型付け（インターフェース）の表現の違いを解説します。

---

## まとめ

- Java は GoF パターンを最も自然に表現できる言語の 1 つである
- インターフェースと抽象クラスが「変化の分離」を型安全に実現する
- Java 8+ のラムダ式により、一部のパターンはより軽量に書ける
- 本シリーズでは TDD サイクルで 13 パターンを実装し、Ruby 版との対比で理解を深める
