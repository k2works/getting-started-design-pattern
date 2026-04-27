(ns design-pattern.template-method-test
  (:require [clojure.test :refer :all]
            [design-pattern.template-method :refer :all]))

(deftest html-report-test
  (testing "HTML フォーマットでレポートを生成する"
    (let [result (generate-report html-formatter "Sales Report" ["Item A" "Item B"])]
      (is (clojure.string/includes? result "<html>"))
      (is (clojure.string/includes? result "Sales Report"))
      (is (clojure.string/includes? result "<p>Item A</p>"))
      (is (clojure.string/includes? result "<p>Item B</p>"))
      (is (clojure.string/includes? result "</html>")))))

(deftest text-report-test
  (testing "Plain Text フォーマットでレポートを生成する"
    (let [result (generate-report text-formatter "Sales Report" ["Item A" "Item B"])]
      (is (clojure.string/includes? result "=== Sales Report ==="))
      (is (clojure.string/includes? result "- Item A"))
      (is (clojure.string/includes? result "- Item B"))
      (is (clojure.string/includes? result "==========")))))

(deftest empty-items-test
  (testing "アイテムが空の場合でも正常に動作する"
    (let [result (generate-report text-formatter "Empty Report" [])]
      (is (clojure.string/includes? result "=== Empty Report ==="))
      (is (clojure.string/includes? result "==========")))))

(deftest custom-formatter-test
  (testing "カスタムフォーマッタを渡せる"
    (let [custom {:format-header (fn [title] (str "[" title "]\n"))
                  :format-item   (fn [item] (str "* " item "\n"))
                  :format-footer (fn [] "[END]\n")}
          result (generate-report custom "My Report" ["X" "Y"])]
      (is (= "[My Report]\n* X\n* Y\n[END]\n" result)))))
