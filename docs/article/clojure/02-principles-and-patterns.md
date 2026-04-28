# 第 2 章: パターンを支える基本原則 -- Clojure の視点から

## はじめに

デザインパターンは「魔法の呪文」ではありません。パターンの背後には設計原則があり、原則を理解せずにパターンだけを適用しても、かえってコードを複雑にするだけです。

本章では、Clojure の特性を踏まえてデザインパターンを支える設計原則を紹介します。関数型言語では、オブジェクト指向言語とは異なるアプローチで同じ原則を実現できます。

---

## Clojure の 3 つの柱

### 1. 不変性（Immutability）

Clojure のデータ構造はデフォルトで不変です。状態の変更は `atom`、`ref`、`agent` といった明示的な参照型を通じてのみ行います。

```clojure
;; 不変データ -- assoc は新しいマップを返す
(def config {:host "localhost" :port 3000})
(def new-config (assoc config :port 8080))
;; config は変わらない

;; 明示的な状態管理 -- atom
(def state (atom {:count 0}))
(swap! state update :count inc)
```

不変性が設計に与える影響は大きく、Builder パターンの中間状態が安全になり、Command パターンの undo がデータの保持だけで済みます。

### 2. データ指向（Data-Oriented Programming）

Clojure は「データとしてのプログラム」を重視します。クラス階層を作る代わりに、マップ、ベクタ、セットといった汎用データ構造でドメインを表現します。

```clojure
;; クラスではなくマップで表現する
(def dog {:type :dog :name "Rex" :sound "Woof!" :legs 4})
(def cat {:type :cat :name "Whiskers" :sound "Meow!" :legs 4})

;; マルチメソッドで振る舞いをデータから分離する
(defmulti speak :type)
(defmethod speak :dog [animal] (str (:name animal) " says: Woof!"))
(defmethod speak :cat [animal] (str (:name animal) " says: Meow!"))
```

### 3. ホモイコニシティ（Homoiconicity）

Clojure は Lisp の方言であり、「コードはデータ、データはコード」という性質を持ちます。この特性は Interpreter パターンとマクロシステムの基盤となります。

```clojure
;; コードもデータもリスト
(def expr '(+ 1 (* 2 3)))  ;; これはデータ
(eval expr)                  ;; これはコードとして実行できる => 7
```

---

## 4 つの設計原則（Clojure 版）

### 1. 変化するものを分離する

ソフトウェアで最も確実なことは「変化する」ということです。Clojure では高階関数を使って変化する部分を引数として外部化します。

```clojure
;; 変化する部分（フォーマッタ）を引数で外部化
(defn generate-report [formatter title items]
  (formatter {:title title :items items}))

;; 戦略の差し替えは関数を渡すだけ
(generate-report html-formatter "Sales" ["Item A"])
(generate-report text-formatter "Sales" ["Item A"])
```

### 2. インターフェースに対してプログラムする

Clojure ではプロトコルとマルチメソッドが抽象を提供します。さらに、関数のシグネチャ自体が暗黙のインターフェースとして機能します。

```clojure
;; プロトコルによる明示的インターフェース
(defprotocol Renderer
  (render [this text]))

;; マルチメソッドによるオープンなディスパッチ
(defmulti total-duration :type)
(defmethod total-duration :leaf [node] (:duration node))
```

### 3. 継承より合成を選ぶ

Clojure にはクラス継承がありません。関数合成（`comp`）とマップのマージで機能を組み立てます。

```clojure
;; 関数合成でデコレータを実現
(def enhanced-writer
  (with-timestamp (with-numbering plain-writer)))

;; マップのマージで設定を合成
(def defaults {:host "localhost" :port 3000})
(def overrides {:port 8080 :debug true})
(merge defaults overrides)  ;; => {:host "localhost" :port 8080 :debug true}
```

### 4. YAGNI（You Ain't Gonna Need It）

将来必要になるかもしれない機能を先回りして実装しないことです。Clojure のマルチメソッドは `defmethod` を後から追加できるため、必要になった時点で拡張できます。

---

## SOLID 原則の Clojure 的解釈

### S - 単一責任の原則

> 関数を変更する理由は、ただ 1 つであるべきだ

Clojure では関数を小さく保つことで自然に実現されます。

### O - 開放閉鎖原則

> ソフトウェアは拡張に対して開いていて、修正に対して閉じているべきだ

マルチメソッドの `defmethod` で、既存コードを変更せずに新しい振る舞いを追加できます。

### L - リスコフの置換原則

> 同じプロトコルを実装する値は置換可能でなければならない

プロトコルを実装するすべての型は、同じ契約を満たす必要があります。

### I - インターフェース分離の原則

> クライアントが使わない関数に依存させてはならない

Clojure ではプロトコルが小さなインターフェース（1〜3 メソッド）として機能し、自然に分離されます。

### D - 依存性逆転の原則

> 上位モジュールは下位モジュールに依存してはならない

高階関数により、具体的な実装への依存を引数として注入します。

---

## パターンと原則の対応

| パターン | 主に活用する原則 | Clojure の言語機能 |
|---------|-----------------|-------------------|
| Template Method | OCP, LSP | 高階関数 + マップ |
| Strategy | SRP, OCP, DIP | 第一級関数 |
| Observer | SRP, OCP | atom + add-watch |
| Composite | LSP | 再帰データ + マルチメソッド |
| Iterator | SRP, ISP | seq 抽象 |
| Command | SRP, OCP | マップ + クロージャ |
| Adapter | DIP, ISP | プロトコル + reify |
| Proxy | LSP, SRP | delay + 関数ラッパー |
| Decorator | OCP, SRP | 関数合成 |
| Singleton | SRP | def / defonce |
| Factory | DIP, OCP | マルチメソッド |
| Builder | SRP | -> マクロ + assoc |
| Interpreter | OCP | マップ AST + マルチメソッド |

---

## まとめ

- デザインパターンは設計原則の具体的な適用例である
- Clojure の不変性、データ指向、ホモイコニシティが多くのパターンを簡素化する
- 高階関数が継承の代替手段となり、合成優先の設計を自然に実現する
- マルチメソッドの後付け可能性が開放閉鎖原則を直接体現する
- 原則を理解した上でパターンを適用することで、過剰設計を避けられる
