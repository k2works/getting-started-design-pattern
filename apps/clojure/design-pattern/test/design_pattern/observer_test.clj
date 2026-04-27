(ns design-pattern.observer-test
  (:require [clojure.test :refer :all]
            [design-pattern.observer :refer :all]))

(deftest create-subject-test
  (testing "subject を作成し初期値を持つ"
    (let [subject (create-subject 0)]
      (is (= 0 (get-state subject))))))

(deftest observer-notification-test
  (testing "状態変更時に observer が通知される"
    (let [subject  (create-subject 0)
          received (atom [])]
      (add-observer subject (fn [old new] (swap! received conj {:old old :new new})))
      (set-state! subject 42)
      (is (= [{:old 0 :new 42}] @received)))))

(deftest multiple-observers-test
  (testing "複数の observer が通知される"
    (let [subject (create-subject "initial")
          log1    (atom [])
          log2    (atom [])]
      (add-observer subject (fn [_ new] (swap! log1 conj new)))
      (add-observer subject (fn [_ new] (swap! log2 conj new)))
      (set-state! subject "updated")
      (is (= ["updated"] @log1))
      (is (= ["updated"] @log2)))))

(deftest remove-observer-test
  (testing "observer を削除すると通知されなくなる"
    (let [subject  (create-subject 0)
          received (atom [])
          obs-fn   (fn [_ new] (swap! received conj new))]
      (add-observer subject obs-fn)
      (set-state! subject 1)
      (remove-observer subject obs-fn)
      (set-state! subject 2)
      (is (= [1] @received)))))

(deftest add-watch-test
  (testing "add-watch を使った簡易版 observer"
    (let [a       (create-watched-atom 0)
          changes (atom [])]
      (watch! a :test (fn [old new] (swap! changes conj {:old old :new new})))
      (reset! a 10)
      (is (= [{:old 0 :new 10}] @changes)))))
