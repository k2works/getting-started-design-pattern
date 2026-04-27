(ns design-pattern.interpreter-test
  (:require [clojure.test :refer :all]
            [design-pattern.interpreter :refer :all]))

(deftest literal-test
  (testing "リテラルを評価する"
    (is (= 42 (evaluate (literal 42) {})))))

(deftest variable-test
  (testing "変数を環境から取得する"
    (is (= 10 (evaluate (variable :x) {:x 10})))))

(deftest undefined-variable-test
  (testing "未定義の変数で例外を投げる"
    (is (thrown? clojure.lang.ExceptionInfo
                (evaluate (variable :z) {:x 10})))))

(deftest arithmetic-test
  (testing "四則演算を評価する"
    (let [env {:x 10 :y 3}]
      (is (= 13 (evaluate (add (variable :x) (variable :y)) env)))
      (is (= 7 (evaluate (subtract (variable :x) (variable :y)) env)))
      (is (= 30 (evaluate (multiply (variable :x) (variable :y)) env)))
      (is (= 10/3 (evaluate (divide (variable :x) (variable :y)) env))))))

(deftest nested-expression-test
  (testing "ネストされた式を評価する: (x + y) * 2"
    (let [expr (multiply (add (variable :x) (variable :y)) (literal 2))
          env  {:x 5 :y 3}]
      (is (= 16 (evaluate expr env))))))

(deftest to-string-test
  (testing "式を文字列に変換する"
    (let [expr (add (variable :x) (multiply (literal 2) (variable :y)))]
      (is (= "(:x + (2 * :y))" (to-string expr))))))

(deftest division-by-zero-test
  (testing "ゼロ除算で例外を投げる"
    (is (thrown? clojure.lang.ExceptionInfo
                (evaluate (divide (literal 10) (literal 0)) {})))))
