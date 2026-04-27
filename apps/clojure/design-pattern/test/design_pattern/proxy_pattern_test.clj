(ns design-pattern.proxy-pattern-test
  (:require [clojure.test :refer :all]
            [design-pattern.proxy-pattern :refer :all]))

(deftest virtual-proxy-lazy-test
  (testing "Virtual Proxy は初回アクセスまでリソースを生成しない"
    (let [p       (virtual-proxy "TestResource")
          loaded? (:loaded? p)
          get-data (:get-data p)]
      (is (not (loaded?)))
      (is (= "Heavy data for TestResource" (get-data)))
      (is (loaded?)))))

(deftest protection-proxy-allowed-test
  (testing "許可された role はアクセスできる"
    (let [secret-fn  (fn [x] (str "secret: " x))
          protected  (protection-proxy secret-fn [:admin :manager])]
      (is (= "secret: data" (protected :admin "data"))))))

(deftest protection-proxy-denied-test
  (testing "許可されていない role はアクセスが拒否される"
    (let [secret-fn  (fn [x] (str "secret: " x))
          protected  (protection-proxy secret-fn [:admin])]
      (is (thrown? clojure.lang.ExceptionInfo (protected :guest "data"))))))

(deftest logging-proxy-test
  (testing "Logging Proxy は呼び出しをログに記録する"
    (let [log     (atom [])
          add-fn  (fn [a b] (+ a b))
          proxied (logging-proxy add-fn log)]
      (is (= 5 (proxied 2 3)))
      (is (= 1 (count @log)))
      (is (= [2 3] (:args (first @log)))))))

(deftest caching-proxy-test
  (testing "Caching Proxy は同じ引数の結果をキャッシュする"
    (let [call-count (atom 0)
          expensive  (fn [x] (swap! call-count inc) (* x x))
          proxy      (caching-proxy expensive)]
      (is (= 25 ((:call proxy) 5)))
      (is (= 25 ((:call proxy) 5)))
      (is (= 1 @call-count))
      (is (= {[5] 25} ((:cache proxy)))))))
