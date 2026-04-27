(ns design-pattern.factory)

;; Factory パターン
;; マルチメソッドでタイプに応じたオブジェクト生成をディスパッチする。

;; --- マルチメソッドファクトリ ---

(defmulti create-animal
  "動物を生成するファクトリ。:type でディスパッチ。"
  :type)

(defmethod create-animal :dog [{:keys [name]}]
  {:type :dog :name name :sound "Woof!" :legs 4})

(defmethod create-animal :cat [{:keys [name]}]
  {:type :cat :name name :sound "Meow!" :legs 4})

(defmethod create-animal :bird [{:keys [name]}]
  {:type :bird :name name :sound "Tweet!" :legs 2})

(defmethod create-animal :default [{:keys [type name]}]
  {:type type :name (or name "Unknown") :sound "..." :legs 0})

;; --- 動物の振る舞い ---

(defmulti speak
  "動物の鳴き声を返す。"
  :type)

(defmethod speak :dog [animal]
  (str (:name animal) " says: Woof!"))

(defmethod speak :cat [animal]
  (str (:name animal) " says: Meow!"))

(defmethod speak :bird [animal]
  (str (:name animal) " says: Tweet!"))

(defmethod speak :default [animal]
  (str (:name animal) " says: ..."))

;; --- Abstract Factory 風 ---

(defn create-habitat
  "生息地タイプに応じた動物セットを生成する。"
  [habitat-type]
  (case habitat-type
    :farm  [(create-animal {:type :dog :name "Rex"})
            (create-animal {:type :cat :name "Whiskers"})
            (create-animal {:type :bird :name "Tweety"})]
    :ocean [{:type :whale :name "Moby" :sound "Ooooo!" :legs 0}
            {:type :dolphin :name "Flipper" :sound "Click!" :legs 0}]
    :forest [(create-animal {:type :bird :name "Eagle"})
             {:type :bear :name "Teddy" :sound "Growl!" :legs 4}]
    []))
