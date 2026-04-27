(ns design-pattern.decorator-test
  (:require [clojure.test :refer :all]
            [design-pattern.decorator :refer :all]))

(deftest plain-writer-test
  (testing "plain-writer はそのまま出力する"
    (is (= "hello" (plain-writer "hello")))))

(deftest numbering-decorator-test
  (testing "行番号デコレータが行番号を付与する"
    (let [writer (with-numbering plain-writer)
          result (writer "line1\nline2\nline3")]
      (is (clojure.string/includes? result "1: line1"))
      (is (clojure.string/includes? result "2: line2"))
      (is (clojure.string/includes? result "3: line3")))))

(deftest brackets-decorator-test
  (testing "括弧デコレータがテキストを囲む"
    (let [writer (with-brackets plain-writer)
          result (writer "hello")]
      (is (= "<<< hello >>>" result)))))

(deftest uppercase-decorator-test
  (testing "大文字デコレータが大文字に変換する"
    (let [writer (with-uppercase plain-writer)
          result (writer "hello")]
      (is (= "HELLO" result)))))

(deftest composed-decorators-test
  (testing "複数のデコレータを合成できる"
    (let [writer (with-uppercase (with-brackets plain-writer))
          result (writer "hello")]
      (is (= "<<< HELLO >>>" result)))))

(deftest timestamp-decorator-test
  (testing "タイムスタンプデコレータがタイムスタンプを付与する"
    (let [writer (with-timestamp plain-writer)
          result (writer "hello")]
      (is (clojure.string/includes? result "hello"))
      (is (re-find #"\[\d{4}-\d{2}-\d{2}" result)))))
