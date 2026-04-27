(ns design-pattern.iterator-pattern-test
  (:require [clojure.test :refer :all]
            [design-pattern.iterator-pattern :refer :all]))

(deftest external-iterator-test
  (testing "外部イテレータで要素を順に取得する"
    (let [iter     (external-iterator [1 2 3])
          has-next (:has-next? iter)
          next!    (:next! iter)]
      (is (has-next))
      (is (= 1 (next!)))
      (is (= 2 (next!)))
      (is (= 3 (next!)))
      (is (not (has-next))))))

(deftest filter-by-test
  (testing "述語でフィルタリングする"
    (is (= [2 4 6] (vec (filter-by even? [1 2 3 4 5 6]))))))

(deftest transform-test
  (testing "変換関数を適用する"
    (is (= [2 4 6] (vec (transform #(* 2 %) [1 2 3]))))))

(deftest aggregate-test
  (testing "集約関数を適用する"
    (is (= 15 (aggregate + 0 [1 2 3 4 5])))))

(deftest fibonacci-test
  (testing "フィボナッチ数列の最初の10項を取得する"
    (is (= [0 1 1 2 3 5 8 13 21 34] (take 10 (fibonacci))))))

(deftest take-while-under-test
  (testing "指定値未満の要素を取得する"
    (is (= [0 1 1 2 3 5 8] (vec (take-while-under 10 (fibonacci)))))))
