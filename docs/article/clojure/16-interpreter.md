# 第 16 章 Interpreter 応用 -- DSL と評価器

## はじめに

第 14 章では AST と評価器の基本を扱いました。本章では応用として、式の文字列表現と逆ポーランド記法（RPN）パーサーを追加し、DSL としての広がりを確認します。

## パターンの構造

```plantuml
@startuml
abstract class "Expression" as E {
  + type : keyword
  + evaluate(env)
  + to-string()
}

class "Literal" as L {
  + value : number
}

class "Variable" as V {
  + name : keyword
}

class "Add" as A {
  + left : Expression
  + right : Expression
}

class "Subtract" as S {
  + left : Expression
  + right : Expression
}

class "Multiply" as M {
  + left : Expression
  + right : Expression
}

class "Divide" as D {
  + left : Expression
  + right : Expression
}

E <|-- L
E <|-- V
E <|-- A
E <|-- S
E <|-- M
E <|-- D
@enduml
```

## Clojure イディオム: 表示器とパーサーを後付けする

### 式の文字列表現

```clojure
(defmulti to-string :type)

(defmethod to-string :literal [node]
  (str (:value node)))

(defmethod to-string :variable [node]
  (str (:name node)))

(defmethod to-string :add [node]
  (str "(" (to-string (:left node)) " + " (to-string (:right node)) ")"))
```

### 逆ポーランド記法パーサー

```clojure
(defn parse-rpn [expression]
  (let [tokens (clojure.string/split expression #"\s+")
        ops    {"+" add "-" subtract "*" multiply "/" divide}]
    (reduce (fn [stack token]
              (if-let [op (get ops token)]
                (let [right   (peek stack)
                      stack'  (pop stack)
                      left    (peek stack')
                      stack'' (pop stack')]
                  (conj stack'' (op left right)))
                (conj stack (if (re-matches #"-?\d+(\.\d+)?" token)
                              (literal (read-string token))
                              (variable (keyword token))))))
            []
            tokens)))
```

## TDD で作る

### Red: 失敗するテストを書く

```clojure
(deftest to-string-test
  (testing "式を文字列に変換する"
    (let [expr (add (variable :x) (multiply (literal 2) (variable :y)))]
      (is (= "(:x + (2 * :y))" (to-string expr))))))

(deftest division-by-zero-test
  (testing "ゼロ除算で例外を投げる"
    (is (thrown? clojure.lang.ExceptionInfo
                (evaluate (divide (literal 10) (literal 0)) {})))))
```

### Green: 最小限の実装

```clojure
(defmulti to-string :type)

(defmethod to-string :literal [node]
  (str (:value node)))

(defmethod to-string :variable [node]
  (str (:name node)))

(defmethod to-string :add [node]
  (str "(" (to-string (:left node)) " + " (to-string (:right node)) ")"))
```

### Refactor

評価器本体を壊さずに `to-string` や `parse-rpn` を後付けできるのは、AST をデータとして独立させている効果です。

## Lisp の哲学との関係

Clojure は Lisp の方言であり、「コードはデータ、データはコード」というホモイコニシティを持ちます。Interpreter パターンはその哲学の直接的な表現であり、マクロや DSL 設計とも強くつながっています。

## まとめ

Interpreter パターンは Clojure の本質に最も近いパターンです。データとしての AST、マルチメソッドによる評価、そしてホモイコニシティの哲学が三位一体となり、強力な DSL 構築基盤を提供します。
