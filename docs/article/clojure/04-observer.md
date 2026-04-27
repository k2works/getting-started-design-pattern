# 第 4 章 Observer -- atom と watch による状態監視

## パターンの意図

Observer パターンは、あるオブジェクトの状態が変化したときに、依存するすべてのオブジェクトに自動的に通知するパターンです。

## Clojure での解釈

Clojure の `atom` と `add-watch` は Observer パターンを言語レベルで直接サポートしています。また、observer リストを atom で管理する手動実装も可能です。

## 実装（手動版）

```clojure
(defn create-subject [initial-value]
  {:state     (atom initial-value)
   :observers (atom [])})

(defn add-observer [subject observer-fn]
  (swap! (:observers subject) conj observer-fn))

(defn set-state! [subject new-value]
  (let [old-value @(:state subject)]
    (reset! (:state subject) new-value)
    (doseq [observer @(:observers subject)]
      (observer old-value new-value))))
```

## 実装（add-watch 版）

```clojure
(defn create-watched-atom [initial-value]
  (atom initial-value))

(defn watch! [a key callback]
  (add-watch a key (fn [_key _ref old-val new-val]
                     (callback old-val new-val))))
```

## クラス図

```plantuml
@startuml
class "Subject" as S {
  + state : atom
  + observers : atom
  + add-observer(fn)
  + remove-observer(fn)
  + set-state!(value)
  + get-state()
}

class "Observer" as O {
  + callback(old, new)
}

S "1" --> "*" O : notifies
@enduml
```

## テスト

```clojure
(deftest observer-notification-test
  (testing "状態変更時に observer が通知される"
    (let [subject  (create-subject 0)
          received (atom [])]
      (add-observer subject (fn [old new] (swap! received conj {:old old :new new})))
      (set-state! subject 42)
      (is (= [{:old 0 :new 42}] @received)))))
```

## まとめ

Clojure の atom + add-watch は Observer パターンの組み込み実装と言えます。手動実装も atom と関数のリストで簡潔に表現できます。
