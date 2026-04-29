(ns design-pattern.composite-test
  (:require [clojure.test :refer :all]
            [design-pattern.composite :refer :all]))

(deftest leaf-duration-test
  (testing "リーフノードの所要時間を返す"
    (let [task (leaf "Write code" 3.0)]
      (is (= 3.0 (total-duration task))))))

(deftest composite-duration-test
  (testing "コンポジットノードの合計所要時間を計算する"
    (let [project (composite "Project"
                             (leaf "Design" 2.0)
                             (leaf "Code" 5.0)
                             (leaf "Test" 3.0))]
      (is (= 10.0 (total-duration project))))))

(deftest nested-composite-test
  (testing "ネストされたコンポジットの合計所要時間を計算する"
    (let [sub1    (composite "Backend" (leaf "API" 4.0) (leaf "DB" 3.0))
          sub2    (composite "Frontend" (leaf "UI" 5.0) (leaf "CSS" 2.0))
          project (composite "Full Project" sub1 sub2)]
      (is (= 14.0 (total-duration project))))))

(deftest add-child-test
  (testing "コンポジットに子を追加する"
    (let [project  (composite "Project" (leaf "Task1" 1.0))
          project' (add-child project (leaf "Task2" 2.0))]
      (is (= 3.0 (total-duration project'))))))

(deftest remove-child-test
  (testing "コンポジットから子を削除する"
    (let [project  (composite "Project" (leaf "Task1" 1.0) (leaf "Task2" 2.0))
          project' (remove-child project "Task1")]
      (is (= 2.0 (total-duration project'))))))

(deftest display-test
  (testing "ツリーを文字列で表示する"
    (let [project (composite "Project" (leaf "Task1" 1.0) (leaf "Task2" 2.0))
          result  (display project 0)]
      (is (clojure.string/includes? result "+ Project"))
      (is (clojure.string/includes? result "- Task1"))
      (is (clojure.string/includes? result "- Task2")))))
