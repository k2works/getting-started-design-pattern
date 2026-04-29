(ns design-pattern.builder)

;; Builder パターン
;; スレッディングマクロ (->) で段階的にマップを構築する。

;; --- Computer Builder ---

(defn new-computer
  "コンピュータの初期状態を作成する。"
  []
  {:type :computer})

(defn with-cpu [computer cpu]
  (assoc computer :cpu cpu))

(defn with-ram [computer ram-gb]
  (assoc computer :ram-gb ram-gb))

(defn with-storage [computer storage-gb]
  (assoc computer :storage-gb storage-gb))

(defn with-gpu [computer gpu]
  (assoc computer :gpu gpu))

(defn with-os [computer os]
  (assoc computer :os os))

(defn validate-computer
  "コンピュータの設定を検証する。必須項目が欠けている場合は例外を投げる。"
  [computer]
  (let [required [:cpu :ram-gb :storage-gb]]
    (doseq [field required]
      (when-not (get computer field)
        (throw (ex-info (str "Missing required field: " (name field))
                        {:field field :computer computer})))))
  computer)

(defn build-computer
  "検証済みのコンピュータを返す。"
  [computer]
  (-> computer
      validate-computer
      (assoc :built true)))

;; --- Director 風ヘルパー ---

(defn gaming-computer
  "ゲーミング PC のプリセット。"
  []
  (-> (new-computer)
      (with-cpu "Intel Core i9")
      (with-ram 32)
      (with-storage 2000)
      (with-gpu "NVIDIA RTX 4090")
      (with-os "Windows 11")
      build-computer))

(defn office-computer
  "オフィス PC のプリセット。"
  []
  (-> (new-computer)
      (with-cpu "Intel Core i5")
      (with-ram 16)
      (with-storage 512)
      (with-os "Windows 11")
      build-computer))

;; --- reduce ベースのビルダー ---

(defn build-from-specs
  "仕様マップのシーケンスから段階的にコンピュータを構築する。"
  [specs]
  (let [builders {:cpu     with-cpu
                  :ram-gb  with-ram
                  :storage-gb with-storage
                  :gpu     with-gpu
                  :os      with-os}]
    (reduce (fn [computer [k v]]
              (if-let [builder-fn (get builders k)]
                (builder-fn computer v)
                computer))
            (new-computer)
            specs)))
