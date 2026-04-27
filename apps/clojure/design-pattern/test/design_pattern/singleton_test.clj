(ns design-pattern.singleton-test
  (:require [clojure.test :refer :all]
            [design-pattern.singleton :refer :all]))

(deftest config-get-test
  (testing "設定値を取得できる"
    (is (= :info (get-config :log-level)))))

(deftest config-set-test
  (testing "設定値を更新できる"
    (let [original (get-config :log-level)]
      (set-config! :log-level :debug)
      (is (= :debug (get-config :log-level)))
      ;; 元に戻す
      (set-config! :log-level original))))

(deftest logger-test
  (testing "ログエントリを追加・取得できる"
    (clear-logs!)
    (log! :info "Test message")
    (log! :error "Error message")
    (is (= 2 (log-count)))
    (is (= :info (:level (first (get-logs)))))
    (clear-logs!)))

(deftest registry-test
  (testing "レジストリにサービスを登録・取得できる"
    (clear-registry!)
    (register! :db {:host "localhost" :port 5432})
    (is (= {:host "localhost" :port 5432} (lookup :db)))
    (clear-registry!)))

(deftest singleton-identity-test
  (testing "同じ atom への参照を共有している（シングルトン性）"
    (clear-logs!)
    (log! :info "first")
    (is (= 1 (log-count)))
    (log! :info "second")
    (is (= 2 (log-count)))
    (clear-logs!)))
