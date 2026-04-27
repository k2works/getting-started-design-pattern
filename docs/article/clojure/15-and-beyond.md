# 第 15 章 まとめ -- 関数型パラダイムとパターンの融合

## 振り返り

本シリーズでは 13 の GoF デザインパターンを Clojure で再解釈しました。多くのパターンが、Clojure の言語機能によって大幅に簡素化されることを確認しました。

## パターンと言語機能の対応

| パターン | OOP での実装 | Clojure での実装 | 簡素化の程度 |
|:---|:---|:---|:---|
| Template Method | 抽象クラス + 継承 | 高階関数 + マップ | 大幅に簡素化 |
| Strategy | インターフェース + 実装クラス | 関数を引数として渡す | パターンが消失 |
| Observer | Subject/Observer インターフェース | atom + add-watch | 言語組み込み |
| Composite | Component/Leaf/Composite クラス | 再帰マップ + マルチメソッド | 大幅に簡素化 |
| Iterator | Iterator インターフェース | seq 抽象 | 言語組み込み |
| Command | Command インターフェース | マップ {:execute fn, :undo fn} | 大幅に簡素化 |
| Adapter | Adapter クラス | プロトコル + reify | 簡素化 |
| Proxy | Proxy クラス | delay / 関数ラッパー | 大幅に簡素化 |
| Decorator | Decorator クラス | 関数合成 | パターンが消失 |
| Singleton | private コンストラクタ | def / defonce | 言語組み込み |
| Factory | Factory クラス | マルチメソッド | 簡素化 |
| Builder | Builder クラス | -> マクロ + assoc | 大幅に簡素化 |
| Interpreter | Expression クラス階層 | マップ AST + マルチメソッド | 簡素化 |

## Clojure の強み

1. **第一級関数**: Strategy, Decorator, Template Method が関数操作に吸収される
2. **不変データ**: Builder の中間状態が安全、Command の undo が明確
3. **マルチメソッド**: Factory, Composite, Interpreter のディスパッチが簡潔
4. **プロトコル**: Adapter の型適合が軽量
5. **atom + watch**: Observer が言語レベルでサポート
6. **delay/force**: Virtual Proxy が組み込み
7. **シーケンス抽象**: Iterator が不要

## 設計の原則は不変

言語が変わっても、パターンの背後にある設計原則は変わりません。

- **関心の分離**: 各関数は 1 つのことだけを行う
- **開放閉鎖原則**: マルチメソッドで拡張に対して開いている
- **依存性逆転**: 高階関数で具体的な実装に依存しない
- **コンポジション優先**: 関数合成で機能を組み立てる

## 結論

デザインパターンは「解決策のカタログ」ではなく「問題の言語」です。Clojure を使うことで、多くのパターンが言語機能に吸収され、より本質的な問題解決に集中できるようになります。
