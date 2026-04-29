# 第 1 章 はじめに ― TypeScript で学ぶデザインパターン

## はじめに

本シリーズでは、TypeScript を使ってデザインパターンを TDD（テスト駆動開発）で実装していきます。TypeScript は JavaScript に静的型システムを加えた言語であり、interface、Generics、Union Types といった機能が、デザインパターンを型安全に表現するための強力な道具を提供します。

## なぜ TypeScript でデザインパターンを学ぶのか

### JavaScript との違い

JavaScript はプロトタイプベースのオブジェクト指向言語ですが、TypeScript はこれに静的型付けを加えることで、設計の意図をコードに明示できるようになります。

| 観点 | JavaScript | TypeScript |
|:---|:---|:---|
| 型チェック | 実行時のみ | コンパイル時 + 実行時 |
| interface | なし（ダックタイピング） | `interface` キーワード |
| アクセス修飾子 | 慣例的 (`_prefix`) | `private`, `protected`, `public` |
| ジェネリクス | なし | `<T>` 構文 |
| 抽象クラス | なし | `abstract class` |
| 列挙型 | なし | `enum` / `const enum` |

### デザインパターンとの親和性

GoF のデザインパターンは元々 C++ と Smalltalk で記述されました。TypeScript は以下の理由でパターンの表現に適しています。

1. **interface による契約の明示** ― Strategy、Observer、Command の「型」を明確に定義できる
2. **abstract class による骨格の提供** ― Template Method の抽象クラスをそのまま表現できる
3. **Generics による型安全な汎用化** ― Factory、Proxy、Iterator を型パラメータで安全に汎用化できる
4. **Union Types と Type Guards** ― パターンマッチング的な条件分岐を型安全に書ける

## 本シリーズの構成

| 章 | パターン | 分類 |
|:---|:---|:---|
| 1 | はじめに | - |
| 2 | Ruby から TypeScript へ | - |
| 3 | パターンで変わるものと変わらないもの | - |
| 4 | Template Method | 振る舞い |
| 5 | Strategy | 振る舞い |
| 6 | Observer | 振る舞い |
| 7 | Composite | 構造 |
| 8 | Iterator | 振る舞い |
| 9 | Command | 振る舞い |
| 10 | Adapter | 構造 |
| 11 | Proxy | 構造 |
| 12 | Decorator | 構造 |
| 13 | Singleton | 生成 |
| 14 | Factory Method / Abstract Factory | 生成 |
| 15 | Builder | 生成 |
| 16 | Interpreter | 振る舞い |

## 開発環境

- **TypeScript** 5.7+
- **Jest** + **ts-jest** によるテスト
- **Node.js** 18+

## TDD のサイクル

本シリーズでは全てのパターンを Red-Green-Refactor のサイクルで実装します。

1. **Red** ― 失敗するテストを書く
2. **Green** ― テストを通す最小限のコードを書く
3. **Refactor** ― 設計を改善する

## まとめ

TypeScript の型システムは、デザインパターンが解決しようとする問題 ― インターフェースの一貫性、実装の差し替え可能性、構造の安全性 ― を言語レベルでサポートします。TDD と組み合わせることで、「動くきれいなコード」を段階的に構築していきます。
