(ns design-pattern.template-method)

;; Template Method パターン
;; Clojure では高階関数でテンプレートメソッドを表現する。
;; 「骨格」となる関数が、カスタマイズ可能なステップ関数を受け取る。

(defn generate-report
  "レポート生成のテンプレート。format-header, format-item, format-footer を差し替え可能。"
  [{:keys [format-header format-item format-footer]} title items]
  (str (format-header title)
       (apply str (map format-item items))
       (format-footer)))

;; --- HTML フォーマット ---

(def html-formatter
  {:format-header (fn [title] (str "<html><head><title>" title "</title></head><body>\n"))
   :format-item   (fn [item] (str "  <p>" item "</p>\n"))
   :format-footer (fn [] "</body></html>\n")})

;; --- Plain Text フォーマット ---

(def text-formatter
  {:format-header (fn [title] (str "=== " title " ===\n"))
   :format-item   (fn [item] (str "  - " item "\n"))
   :format-footer (fn [] "==========\n")})
