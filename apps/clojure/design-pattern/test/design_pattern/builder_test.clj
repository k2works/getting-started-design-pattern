(ns design-pattern.builder-test
  (:require [clojure.test :refer :all]
            [design-pattern.builder :refer :all]))

(deftest basic-builder-test
  (testing "スレッディングマクロでコンピュータを構築する"
    (let [pc (-> (new-computer)
                 (with-cpu "Intel Core i7")
                 (with-ram 16)
                 (with-storage 512)
                 build-computer)]
      (is (= "Intel Core i7" (:cpu pc)))
      (is (= 16 (:ram-gb pc)))
      (is (= 512 (:storage-gb pc)))
      (is (:built pc)))))

(deftest validation-fails-test
  (testing "必須フィールドが欠けている場合は例外を投げる"
    (is (thrown? clojure.lang.ExceptionInfo
                (-> (new-computer)
                    (with-cpu "Intel")
                    build-computer)))))

(deftest gaming-computer-test
  (testing "ゲーミング PC プリセット"
    (let [pc (gaming-computer)]
      (is (= "NVIDIA RTX 4090" (:gpu pc)))
      (is (= 32 (:ram-gb pc)))
      (is (:built pc)))))

(deftest office-computer-test
  (testing "オフィス PC プリセット"
    (let [pc (office-computer)]
      (is (= "Intel Core i5" (:cpu pc)))
      (is (nil? (:gpu pc)))
      (is (:built pc)))))

(deftest build-from-specs-test
  (testing "仕様マップからコンピュータを構築する"
    (let [specs {:cpu "AMD Ryzen 9" :ram-gb 64 :storage-gb 4000 :gpu "NVIDIA RTX 4080"}
          pc    (build-computer (build-from-specs specs))]
      (is (= "AMD Ryzen 9" (:cpu pc)))
      (is (= 64 (:ram-gb pc)))
      (is (:built pc)))))
