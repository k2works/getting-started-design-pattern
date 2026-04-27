(ns design-pattern.strategy-test
  (:require [clojure.test :refer :all]
            [design-pattern.strategy :refer :all]))

(def sample-report {:title "Monthly Sales" :items ["Item A" "Item B" "Item C"]})

(deftest html-strategy-test
  (testing "HTML 戦略でレポートを整形する"
    (let [result (format-report html-formatter sample-report)]
      (is (clojure.string/includes? result "<html>"))
      (is (clojure.string/includes? result "Monthly Sales"))
      (is (clojure.string/includes? result "<p>Item A</p>")))))

(deftest text-strategy-test
  (testing "Plain Text 戦略でレポートを整形する"
    (let [result (format-report text-formatter sample-report)]
      (is (clojure.string/includes? result "=== Monthly Sales ==="))
      (is (clojure.string/includes? result "- Item A")))))

(deftest markdown-strategy-test
  (testing "Markdown 戦略でレポートを整形する"
    (let [result (format-report markdown-formatter sample-report)]
      (is (clojure.string/includes? result "# Monthly Sales"))
      (is (clojure.string/includes? result "- Item A")))))

(deftest strategy-is-just-a-function-test
  (testing "戦略は任意の関数で差し替えられる"
    (let [custom-fn (fn [{:keys [title]}] (str "Custom: " title))
          result    (format-report custom-fn sample-report)]
      (is (= "Custom: Monthly Sales" result)))))

(deftest empty-items-strategy-test
  (testing "空のアイテムリストでも正常に動作する"
    (let [result (format-report text-formatter {:title "Empty" :items []})]
      (is (clojure.string/includes? result "=== Empty ===")))))
