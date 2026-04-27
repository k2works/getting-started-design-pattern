(ns design-pattern.command)

;; Command パターン
;; コマンドをマップ {:execute fn, :undo fn, :description str} で表現する。

(defn make-command
  "コマンドを作成する。"
  [description execute-fn undo-fn]
  {:description description
   :execute     execute-fn
   :undo        undo-fn})

(defn execute
  "コマンドを実行する。"
  [cmd]
  ((:execute cmd)))

(defn undo
  "コマンドを取り消す。"
  [cmd]
  ((:undo cmd)))

;; --- ファイル操作コマンド ---

(defn create-file-command
  "ファイル作成コマンド（シミュレーション）。state-atom にファイルリストを保持。"
  [state-atom filename content]
  (make-command
    (str "Create file: " filename)
    (fn [] (swap! state-atom assoc filename content))
    (fn [] (swap! state-atom dissoc filename))))

(defn delete-file-command
  "ファイル削除コマンド。"
  [state-atom filename]
  (let [backup (atom nil)]
    (make-command
      (str "Delete file: " filename)
      (fn []
        (reset! backup (get @state-atom filename))
        (swap! state-atom dissoc filename))
      (fn []
        (when @backup
          (swap! state-atom assoc filename @backup))))))

;; --- コンポジットコマンド ---

(defn composite-command
  "複数のコマンドをまとめて実行するコンポジットコマンド。"
  [description commands]
  (make-command
    description
    (fn [] (doseq [cmd commands] (execute cmd)))
    (fn [] (doseq [cmd (reverse commands)] (undo cmd)))))

;; --- コマンド履歴 ---

(defn create-history
  "コマンド履歴を作成する。"
  []
  (atom []))

(defn execute-with-history!
  "コマンドを実行し、履歴に記録する。"
  [history cmd]
  (execute cmd)
  (swap! history conj cmd))

(defn undo-last!
  "最後に実行したコマンドを取り消す。"
  [history]
  (when-let [cmd (peek @history)]
    (undo cmd)
    (swap! history pop)))
