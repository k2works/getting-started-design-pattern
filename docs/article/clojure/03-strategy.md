# 第 3 章 Strategy -- 関数は最良の戦略

## パターンの意図

Strategy パターンは、アルゴリズムをカプセル化し、実行時に交換可能にするパターンです。

## Clojure での解釈

Clojure では関数が第一級オブジェクトなので、戦略は単なる関数です。インターフェースもクラスも不要で、関数を引数として渡すだけで Strategy パターンが実現します。

## 実装

```clojure
(defn format-report [formatter report]
  (formatter report))

(defn html-formatter [{:keys [title items]}]
  (str "<html><head><title>" title "</title></head><body>\n"
       (apply str (map #(str "  <p>" % "</p>\n") items))
       "</body></html>\n"))

(defn text-formatter [{:keys [title items]}]
  (str "=== " title " ===\n"
       (apply str (map #(str "  - " % "\n") items))
       "==========\n"))

(defn markdown-formatter [{:keys [title items]}]
  (str "# " title "\n\n"
       (apply str (map #(str "- " % "\n") items))))
```

## クラス図

```plantuml
@startuml
class "format-report" as FR {
  + formatter : fn
  + report : map
}

class "html-formatter" as HF {
  + call(report) : string
}

class "text-formatter" as TF {
  + call(report) : string
}

class "markdown-formatter" as MF {
  + call(report) : string
}

FR --> HF : uses
FR --> TF : uses
FR --> MF : uses
@enduml
```

## テスト

```clojure
(deftest strategy-is-just-a-function-test
  (testing "戦略は任意の関数で差し替えられる"
    (let [custom-fn (fn [{:keys [title]}] (str "Custom: " title))
          result    (format-report custom-fn sample-report)]
      (is (= "Custom: Monthly Sales" result)))))
```

## Template Method との違い

Template Method は骨格の中の一部ステップを差し替えるのに対し、Strategy はアルゴリズム全体を差し替えます。Clojure ではどちらも高階関数で表現でき、その境界は曖昧になります。

## まとめ

関数型言語において Strategy パターンは最も自然なパターンです。関数を値として扱えること自体が、Strategy パターンの本質だからです。
