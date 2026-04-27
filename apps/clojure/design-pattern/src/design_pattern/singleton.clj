(ns design-pattern.singleton)

;; Singleton パターン
;; Clojure では def / defonce が名前空間レベルのシングルトンを自然に提供する。
;; atom で状態を持つシングルトンも表現できる。

;; --- defonce によるシングルトン ---

(defonce app-config
  (atom {:database-url "jdbc:postgresql://localhost:5432/mydb"
         :max-connections 10
         :log-level :info}))

(defn get-config
  "設定値を取得する。"
  [key]
  (get @app-config key))

(defn set-config!
  "設定値を更新する。"
  [key value]
  (swap! app-config assoc key value))

;; --- ロガーシングルトン ---

(defonce ^:private log-entries (atom []))

(defn log!
  "ログエントリを追加する。"
  [level message]
  (swap! log-entries conj {:level level :message message :timestamp (System/currentTimeMillis)}))

(defn get-logs
  "全ログエントリを取得する。"
  []
  @log-entries)

(defn clear-logs!
  "ログをクリアする。"
  []
  (reset! log-entries []))

(defn log-count
  "ログエントリ数を取得する。"
  []
  (count @log-entries))

;; --- レジストリパターン（シングルトンの一般化） ---

(defonce registry (atom {}))

(defn register!
  "レジストリにサービスを登録する。"
  [key service]
  (swap! registry assoc key service))

(defn lookup
  "レジストリからサービスを取得する。"
  [key]
  (get @registry key))

(defn clear-registry!
  "レジストリをクリアする。"
  []
  (reset! registry {}))
