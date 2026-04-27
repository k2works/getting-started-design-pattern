(ns design-pattern.proxy-pattern)

;; Proxy パターン
;; delay/force で Virtual Proxy、関数ラッパーで Protection Proxy。

;; --- Virtual Proxy (delay/force) ---

(defn create-heavy-resource
  "重い初期化処理をシミュレートする。"
  [name]
  (Thread/sleep 10) ;; シミュレーション用の短い遅延
  {:name name :data (str "Heavy data for " name) :loaded true})

(defn virtual-proxy
  "遅延初期化プロキシ。初回アクセス時にのみリソースを生成する。"
  [name]
  (let [resource (delay (create-heavy-resource name))]
    {:name       name
     :loaded?    (fn [] (realized? resource))
     :get-data   (fn [] (:data (force resource)))
     :get-resource (fn [] (force resource))}))

;; --- Protection Proxy ---

(defn protection-proxy
  "アクセス制御プロキシ。role が許可リストに含まれる場合のみ操作を許可する。"
  [target-fn allowed-roles]
  (fn [role & args]
    (if (contains? (set allowed-roles) role)
      (apply target-fn args)
      (throw (ex-info "Access denied" {:role role :allowed allowed-roles})))))

;; --- Logging Proxy ---

(defn logging-proxy
  "ロギングプロキシ。呼び出しをログに記録する。"
  [target-fn log-atom]
  (fn [& args]
    (swap! log-atom conj {:fn-name "target" :args args :timestamp (System/currentTimeMillis)})
    (apply target-fn args)))

;; --- Caching Proxy ---

(defn caching-proxy
  "キャッシュプロキシ。同じ引数での呼び出し結果をキャッシュする。"
  [target-fn]
  (let [cache (atom {})]
    {:call  (fn [& args]
              (if-let [cached (get @cache args)]
                cached
                (let [result (apply target-fn args)]
                  (swap! cache assoc args result)
                  result)))
     :cache (fn [] @cache)
     :clear (fn [] (reset! cache {}))}))
