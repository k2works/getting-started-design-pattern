(ns design-pattern.iterator-pattern)

;; Iterator パターン
;; Clojure のシーケンス抽象が Iterator そのもの。
;; map, filter, reduce, take, drop など。

(defn external-iterator
  "外部イテレータ風のインターフェースを提供する。
   seq を内部に持ち、next で要素を取得する。"
  [coll]
  (let [state (atom (seq coll))]
    {:has-next? (fn [] (boolean @state))
     :next!     (fn []
                  (let [current (first @state)]
                    (swap! state next)
                    current))}))

;; --- フィルタリング・変換 ---

(defn filter-by
  "述語でフィルタリングする。"
  [pred coll]
  (filter pred coll))

(defn transform
  "変換関数を適用する。"
  [f coll]
  (map f coll))

(defn aggregate
  "集約関数を適用する。"
  [f init coll]
  (reduce f init coll))

;; --- 遅延シーケンス ---

(defn fibonacci
  "フィボナッチ数列の遅延シーケンス。"
  []
  (letfn [(fib [a b] (lazy-seq (cons a (fib b (+ a b)))))]
    (fib 0 1)))

(defn take-while-under
  "指定値未満の要素を取得する。"
  [limit coll]
  (take-while #(< % limit) coll))
