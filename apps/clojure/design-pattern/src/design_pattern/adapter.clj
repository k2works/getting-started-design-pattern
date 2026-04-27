(ns design-pattern.adapter)

;; Adapter パターン
;; プロトコルで共通インターフェースを定義し、既存のデータ構造を適合させる。

;; --- 共通プロトコル ---

(defprotocol Renderer
  (render [this text] "テキストを描画する。"))

;; --- 既存の「古い」レンダラー（マップベース） ---

(defn legacy-renderer
  "レガシーレンダラーのシミュレーション。大文字変換する。"
  [text]
  (clojure.string/upper-case text))

(defn modern-renderer
  "モダンレンダラー。Markdown 形式で出力する。"
  [text]
  (str "**" text "**"))

;; --- アダプター（ラッパー関数） ---

(defn adapt-to-renderer
  "任意の (fn [text] -> string) を Renderer プロトコルに適合させる。"
  [render-fn]
  (reify Renderer
    (render [_ text] (render-fn text))))

;; --- データフォーマットアダプター ---

(defn csv->maps
  "CSV 文字列（ヘッダー付き）をマップのシーケンスに変換する。"
  [csv-string]
  (let [lines  (clojure.string/split-lines csv-string)
        header (mapv clojure.string/trim (clojure.string/split (first lines) #","))
        rows   (rest lines)]
    (mapv (fn [row]
            (zipmap (map keyword header)
                    (mapv clojure.string/trim (clojure.string/split row #","))))
          rows)))

(defn maps->csv
  "マップのシーケンスを CSV 文字列に変換する。"
  [maps]
  (when (seq maps)
    (let [ks     (keys (first maps))
          header (clojure.string/join "," (map name ks))
          rows   (map (fn [m] (clojure.string/join "," (map #(get m %) ks))) maps)]
      (clojure.string/join "\n" (cons header rows)))))
