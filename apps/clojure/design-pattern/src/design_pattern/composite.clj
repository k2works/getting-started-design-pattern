(ns design-pattern.composite)

;; Composite パターン
;; ネストされたマップとベクタで木構造を表現する。
;; マルチメソッドで :type に応じたディスパッチを行う。

(defn leaf
  "リーフノード（タスク）を作成する。"
  [name duration]
  {:type :leaf :name name :duration duration})

(defn composite
  "コンポジットノード（プロジェクト）を作成する。"
  [name & children]
  {:type :composite :name name :children (vec children)})

(defn add-child
  "コンポジットに子ノードを追加する。"
  [parent child]
  (update parent :children conj child))

(defn remove-child
  "コンポジットから指定名の子ノードを削除する。"
  [parent child-name]
  (update parent :children (fn [cs] (vec (remove #(= (:name %) child-name) cs)))))

;; --- マルチメソッドによるディスパッチ ---

(defmulti total-duration
  "ノードの合計所要時間を計算する。"
  :type)

(defmethod total-duration :leaf [node]
  (:duration node))

(defmethod total-duration :composite [node]
  (reduce + 0 (map total-duration (:children node))))

(defmulti display
  "ノードをインデント付きで表示する。"
  (fn [node _depth] (:type node)))

(defmethod display :leaf [node depth]
  (str (apply str (repeat depth "  ")) "- " (:name node)
       " (" (:duration node) "h)\n"))

(defmethod display :composite [node depth]
  (str (apply str (repeat depth "  ")) "+ " (:name node) "\n"
       (apply str (map #(display % (inc depth)) (:children node)))))
