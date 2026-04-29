(ns design-pattern.factory-test
  (:require [clojure.test :refer :all]
            [design-pattern.factory :refer :all]))

(deftest create-dog-test
  (testing "犬を生成する"
    (let [dog (create-animal {:type :dog :name "Rex"})]
      (is (= :dog (:type dog)))
      (is (= "Rex" (:name dog)))
      (is (= "Woof!" (:sound dog)))
      (is (= 4 (:legs dog))))))

(deftest create-cat-test
  (testing "猫を生成する"
    (let [cat (create-animal {:type :cat :name "Whiskers"})]
      (is (= :cat (:type cat)))
      (is (= "Meow!" (:sound cat))))))

(deftest create-bird-test
  (testing "鳥を生成する"
    (let [bird (create-animal {:type :bird :name "Tweety"})]
      (is (= 2 (:legs bird))))))

(deftest speak-test
  (testing "動物の鳴き声を返す"
    (let [dog (create-animal {:type :dog :name "Rex"})]
      (is (= "Rex says: Woof!" (speak dog))))))

(deftest default-animal-test
  (testing "未知のタイプにはデフォルト値を返す"
    (let [unknown (create-animal {:type :fish :name "Nemo"})]
      (is (= "..." (:sound unknown))))))

(deftest create-habitat-test
  (testing "生息地タイプに応じた動物セットを生成する"
    (let [farm (create-habitat :farm)]
      (is (= 3 (count farm)))
      (is (= :dog (:type (first farm)))))))
