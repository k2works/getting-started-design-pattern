(ns design-pattern.strategy)

;; Strategy パターン
;; Clojure では関数が第一級オブジェクトなので、戦略は単なる関数。

(defn format-report
  "レポートデータを受け取り、formatter 関数で整形する。"
  [formatter report]
  (formatter report))

;; --- HTML 戦略 ---

(defn html-formatter [{:keys [title items]}]
  (str "<html><head><title>" title "</title></head><body>\n"
       (apply str (map #(str "  <p>" % "</p>\n") items))
       "</body></html>\n"))

;; --- Plain Text 戦略 ---

(defn text-formatter [{:keys [title items]}]
  (str "=== " title " ===\n"
       (apply str (map #(str "  - " % "\n") items))
       "==========\n"))

;; --- Markdown 戦略 ---

(defn markdown-formatter [{:keys [title items]}]
  (str "# " title "\n\n"
       (apply str (map #(str "- " % "\n") items))))
