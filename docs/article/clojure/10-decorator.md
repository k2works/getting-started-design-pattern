# 第 10 章 Decorator -- 関数合成による装飾

## パターンの意図

Decorator パターンは、オブジェクトに動的に新しい責務を追加するパターンです。

## Clojure での解釈

Clojure では関数合成がデコレータそのものです。各デコレータは `(fn [text] -> text)` 形式の関数を受け取り、新しい関数を返す高階関数として実装します。

## 実装

```clojure
(defn plain-writer [text] text)

(defn with-numbering [writer-fn]
  (fn [text]
    (let [result (writer-fn text)
          lines  (clojure.string/split-lines result)]
      (clojure.string/join
        "\n"
        (map-indexed (fn [i line] (str (inc i) ": " line)) lines)))))

(defn with-timestamp [writer-fn]
  (fn [text]
    (let [result (writer-fn text)]
      (str "[" (java.time.LocalDateTime/now) "]\n" result))))

(defn with-brackets [writer-fn]
  (fn [text]
    (str "<<< " (writer-fn text) " >>>")))
```

## クラス図

```plantuml
@startuml
class "plain-writer" as PW {
  + call(text) : string
}

class "with-numbering" as WN {
  + wraps(writer-fn)
  + call(text) : string
}

class "with-timestamp" as WT {
  + wraps(writer-fn)
  + call(text) : string
}

class "with-brackets" as WB {
  + wraps(writer-fn)
  + call(text) : string
}

WN --> PW : decorates
WT --> PW : decorates
WB --> PW : decorates
@enduml
```

## テスト

```clojure
(deftest composed-decorators-test
  (testing "複数のデコレータを合成できる"
    (let [writer (with-uppercase (with-brackets plain-writer))
          result (writer "hello")]
      (is (= "<<< HELLO >>>" result)))))
```

## まとめ

関数合成は Decorator パターンの最も自然な表現です。`comp` やネストされた高階関数呼び出しで、任意の数のデコレータを自由に組み合わせられます。
