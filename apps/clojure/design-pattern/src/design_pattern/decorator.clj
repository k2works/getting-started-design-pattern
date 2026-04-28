(ns design-pattern.decorator
  (:require [clojure.string :as str]))

;; Decorator パターン
;; 関数合成 (comp) でデコレータを実現する。
;; 各デコレータは (fn [text] -> text) の形式。

;; --- 基本ライター ---

(defn plain-writer
  "そのまま出力する基本ライター。"
  [text]
  text)

;; --- デコレータ関数 ---

(defn with-numbering
  "行番号を付与するデコレータ。"
  [writer-fn]
  (fn [text]
    (let [result (writer-fn text)
          lines  (str/split-lines result)]
      (str/join
        "\n"
        (map-indexed (fn [i line] (str (inc i) ": " line)) lines)))))

(defn with-timestamp
  "タイムスタンプを付与するデコレータ。"
  [writer-fn]
  (fn [text]
    (let [result (writer-fn text)
          now    (java.time.LocalDateTime/now)
          fmt    (java.time.format.DateTimeFormatter/ofPattern "yyyy-MM-dd HH:mm:ss")]
      (str "[" (.format now fmt) "]\n" result))))

(defn with-brackets
  "括弧で囲むデコレータ。"
  [writer-fn]
  (fn [text]
    (let [result (writer-fn text)]
      (str "<<< " result " >>>"))))

(defn with-uppercase
  "大文字に変換するデコレータ。"
  [writer-fn]
  (fn [text]
    (let [result (writer-fn text)]
      (str/upper-case result))))

;; --- 合成例 ---

(def numbered-writer
  "行番号付きライター。"
  (with-numbering plain-writer))

(def timestamped-numbered-writer
  "タイムスタンプ + 行番号付きライター。"
  (with-timestamp (with-numbering plain-writer)))
