(ns design-pattern.interpreter
  (:require [clojure.string :as str]))

;; Interpreter パターン
;; AST をマップで表現し、マルチメソッドで evaluate する。

;; --- AST ノード生成ヘルパー ---

(defn literal [value]
  {:type :literal :value value})

(defn variable [name]
  {:type :variable :name name})

(defn add [left right]
  {:type :add :left left :right right})

(defn subtract [left right]
  {:type :subtract :left left :right right})

(defn multiply [left right]
  {:type :multiply :left left :right right})

(defn divide [left right]
  {:type :divide :left left :right right})

;; --- 評価 ---

(defmulti evaluate
  "AST ノードを環境 (変数マップ) の下で評価する。"
  (fn [node _env] (:type node)))

(defmethod evaluate :literal [node _env]
  (:value node))

(defmethod evaluate :variable [node env]
  (if-let [val (get env (:name node))]
    val
    (throw (ex-info (str "Undefined variable: " (:name node))
                    {:variable (:name node) :env env}))))

(defmethod evaluate :add [node env]
  (+ (evaluate (:left node) env)
     (evaluate (:right node) env)))

(defmethod evaluate :subtract [node env]
  (- (evaluate (:left node) env)
     (evaluate (:right node) env)))

(defmethod evaluate :multiply [node env]
  (* (evaluate (:left node) env)
     (evaluate (:right node) env)))

(defmethod evaluate :divide [node env]
  (let [divisor (evaluate (:right node) env)]
    (if (zero? divisor)
      (throw (ex-info "Division by zero" {:node node}))
      (/ (evaluate (:left node) env) divisor))))

;; --- 式の文字列表現 ---

(defmulti to-string
  "AST ノードを文字列に変換する。"
  :type)

(defmethod to-string :literal [node]
  (str (:value node)))

(defmethod to-string :variable [node]
  (str (:name node)))

(defmethod to-string :add [node]
  (str "(" (to-string (:left node)) " + " (to-string (:right node)) ")"))

(defmethod to-string :subtract [node]
  (str "(" (to-string (:left node)) " - " (to-string (:right node)) ")"))

(defmethod to-string :multiply [node]
  (str "(" (to-string (:left node)) " * " (to-string (:right node)) ")"))

(defmethod to-string :divide [node]
  (str "(" (to-string (:left node)) " / " (to-string (:right node)) ")"))

;; --- 簡易パーサー（逆ポーランド記法） ---

(defn parse-rpn
  "逆ポーランド記法の文字列を AST に変換する。"
  [expression]
  (let [tokens (str/split expression #"\s+")
        ops    {"+" add "-" subtract "*" multiply "/" divide}]
    (reduce (fn [stack token]
              (if-let [op (get ops token)]
                (let [right (peek stack)
                      stack' (pop stack)
                      left  (peek stack')
                      stack'' (pop stack')]
                  (conj stack'' (op left right)))
                (conj stack (if (re-matches #"-?\d+(\.\d+)?" token)
                              (literal (read-string token))
                              (variable (keyword token))))))
            []
            tokens)
    ))
