(ns design-pattern.adapter
  (:require [clojure.string :as str]))

;; Adapter パターン
;; プロトコルで共通インターフェースを定義し、既存のデータ構造を適合させる。

;; --- 共通プロトコル ---

(defprotocol Renderer
  (render [this text] "テキストを描画する。"))

;; --- 既存の「古い」レンダラー（マップベース） ---

(defn legacy-renderer
  "レガシーレンダラーのシミュレーション。大文字変換する。"
  [text]
  (str/upper-case text))

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
  (let [lines  (str/split-lines csv-string)
        header (mapv str/trim (str/split (first lines) #","))
        rows   (rest lines)]
    (mapv (fn [row]
            (zipmap (map keyword header)
                    (mapv str/trim (str/split row #","))))
          rows)))

(defn maps->csv
  "マップのシーケンスを CSV 文字列に変換する。"
  [maps]
  (when (seq maps)
    (let [ks     (keys (first maps))
          header (str/join "," (map name ks))
          rows   (map (fn [m] (str/join "," (map #(get m %) ks))) maps)]
      (str/join "\n" (cons header rows)))))
