(ns design-pattern.command-test
  (:require [clojure.test :refer :all]
            [design-pattern.command :refer :all]))

(deftest create-and-execute-command-test
  (testing "コマンドを作成して実行する"
    (let [state (atom {:files {}})
          cmd   (create-file-command (:files state) "test.txt" "hello")]
      ;; state を直接使う
      (let [fs  (atom {})
            cmd (create-file-command fs "test.txt" "hello")]
        (execute cmd)
        (is (= {"test.txt" "hello"} @fs))))))

(deftest undo-command-test
  (testing "コマンドの取り消しができる"
    (let [fs  (atom {})
          cmd (create-file-command fs "test.txt" "hello")]
      (execute cmd)
      (is (= {"test.txt" "hello"} @fs))
      (undo cmd)
      (is (= {} @fs)))))

(deftest delete-and-undo-test
  (testing "削除コマンドの実行と取り消し"
    (let [fs      (atom {"readme.md" "# README"})
          del-cmd (delete-file-command fs "readme.md")]
      (execute del-cmd)
      (is (nil? (get @fs "readme.md")))
      (undo del-cmd)
      (is (= "# README" (get @fs "readme.md"))))))

(deftest composite-command-test
  (testing "コンポジットコマンドで複数操作をまとめて実行する"
    (let [fs   (atom {})
          cmds [(create-file-command fs "a.txt" "aaa")
                (create-file-command fs "b.txt" "bbb")]
          comp-cmd (composite-command "Create files" cmds)]
      (execute comp-cmd)
      (is (= {"a.txt" "aaa" "b.txt" "bbb"} @fs))
      (undo comp-cmd)
      (is (= {} @fs)))))

(deftest command-history-test
  (testing "コマンド履歴でundo ができる"
    (let [fs      (atom {})
          history (create-history)]
      (execute-with-history! history (create-file-command fs "x.txt" "xxx"))
      (execute-with-history! history (create-file-command fs "y.txt" "yyy"))
      (is (= {"x.txt" "xxx" "y.txt" "yyy"} @fs))
      (undo-last! history)
      (is (= {"x.txt" "xxx"} @fs))
      (undo-last! history)
      (is (= {} @fs)))))
