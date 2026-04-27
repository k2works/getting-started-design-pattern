(ns design-pattern.observer)

;; Observer パターン
;; atom + add-watch で実装。observer はコールバック関数。

(defn create-subject
  "監視対象を作成する。state-atom と observers リストを持つ。"
  [initial-value]
  {:state     (atom initial-value)
   :observers (atom [])})

(defn add-observer
  "observer 関数を追加する。observer は (fn [old-val new-val]) の形式。"
  [subject observer-fn]
  (swap! (:observers subject) conj observer-fn))

(defn remove-observer
  "observer 関数を削除する。"
  [subject observer-fn]
  (swap! (:observers subject) (fn [obs] (remove #(= % observer-fn) obs))))

(defn set-state!
  "状態を更新し、全 observer に通知する。"
  [subject new-value]
  (let [old-value @(:state subject)]
    (reset! (:state subject) new-value)
    (doseq [observer @(:observers subject)]
      (observer old-value new-value))))

(defn get-state
  "現在の状態を取得する。"
  [subject]
  @(:state subject))

;; --- add-watch を使った簡易版 ---

(defn create-watched-atom
  "add-watch を使ったシンプルな observer。"
  [initial-value]
  (atom initial-value))

(defn watch!
  "atom に watcher を追加する。"
  [a key callback]
  (add-watch a key (fn [_key _ref old-val new-val]
                     (callback old-val new-val))))
