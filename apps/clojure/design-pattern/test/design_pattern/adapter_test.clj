(ns design-pattern.adapter-test
  (:require [clojure.test :refer :all]
            [design-pattern.adapter :refer :all]))

(deftest legacy-adapter-test
  (testing "レガシーレンダラーをプロトコルに適合させる"
    (let [renderer (adapt-to-renderer legacy-renderer)]
      (is (= "HELLO WORLD" (render renderer "hello world"))))))

(deftest modern-adapter-test
  (testing "モダンレンダラーをプロトコルに適合させる"
    (let [renderer (adapt-to-renderer modern-renderer)]
      (is (= "**hello**" (render renderer "hello"))))))

(deftest csv-to-maps-test
  (testing "CSV 文字列をマップのシーケンスに変換する"
    (let [csv    "name,age,city\nAlice,30,Tokyo\nBob,25,Osaka"
          result (csv->maps csv)]
      (is (= 2 (count result)))
      (is (= "Alice" (:name (first result))))
      (is (= "30" (:age (first result))))
      (is (= "Osaka" (:city (second result)))))))

(deftest maps-to-csv-test
  (testing "マップのシーケンスを CSV 文字列に変換する"
    (let [maps   [{:name "Alice" :age "30"} {:name "Bob" :age "25"}]
          result (maps->csv maps)]
      (is (clojure.string/includes? result "name"))
      (is (clojure.string/includes? result "Alice"))
      (is (clojure.string/includes? result "Bob")))))

(deftest roundtrip-test
  (testing "CSV -> Maps -> CSV のラウンドトリップ"
    (let [csv      "name,age\nAlice,30\nBob,25"
          maps     (csv->maps csv)
          csv-back (maps->csv maps)]
      (is (clojure.string/includes? csv-back "Alice"))
      (is (clojure.string/includes? csv-back "Bob")))))
