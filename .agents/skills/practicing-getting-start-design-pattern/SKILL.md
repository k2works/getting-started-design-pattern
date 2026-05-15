---
name: practicing-getting-start-design-pattern
description: "「デザインパターンからはじめるプログラミング入門」の対話式チュートリアル。Russ Olsen 『Design Patterns in Ruby』 を源流に、13 パターンを 14 言語で TDD とともに学ぶ。「デザインパターンを練習したい」「Template Method から学びたい」「Strategy を実装したい」「OOP パターンを言語別に比較したい」「getting-start-design-pattern をやりたい」「デザインパターンのハンズオンがしたい」といった場面で発動する。デザインパターン学習や設計リファクタリングの要望があれば積極的に使用すること。"
---

# デザインパターン プログラミング入門 - 対話式チュートリアル

`docs/article/` の教材を使って、デザインパターンの背景・素朴な実装・パターン適用・TDD リファクタリングを段階的に体験する対話式チュートリアル。

## 教材

- シリーズ概要: `docs/article/index.md`
- 執筆計画: `docs/article/outline.md`
- 執筆ワークフロー: `docs/article/workflow.md`
- 言語別教材: `docs/article/{lang}/`
- 多言語統合解説: `docs/article/all/`
- 一次資料（Ruby 実装）: `docs/reference/ruby-design-pattern/`

## チュートリアルの進め方

### Step 0: 開発環境の準備

開始前にユーザーの開発環境を確認し、環境構築は必ず合意を得てから進める。勝手にコマンドを実行しない。

#### コード配置ルール

実装コードは `apps/{lang}/design-pattern/{NN-pattern}/` に配置する。

```text
apps/
├── ruby/design-pattern/04-template-method/
├── java/design-pattern/05-strategy/
├── python/design-pattern/06-observer/
└── ...
```

#### 推奨環境

- GitHub Codespaces + devcontainer + Nix
- ローカルの場合は OS に応じてセットアップし、可能なら `nix develop .#{lang}` を利用

### Step 1: 言語選択

ユーザーに対象言語を確認する。対応言語は `docs/article/` 配下の 14 言語（`ruby`, `java`, `javascript`, `typescript`, `python`, `php`, `go`, `rust`, `csharp`, `fsharp`, `clojure`, `scala`, `elixir`, `haskell`）。

初回は **Ruby を推奨** する。理由は、一次資料が Ruby 実装でありパターンの源流を追いやすいため。

### Step 2: 章の選択

`docs/article/{lang}/` の章構成に従って進める。

- 第 1 部（1〜3 章）: 導入、原則、TDD 基盤
- 第 2 部（4〜8 章）: Template Method / Strategy / Observer / Composite / Iterator
- 第 3 部（9〜12 章）: Command / Adapter / Proxy / Decorator
- 第 4 部（13〜16 章）: Singleton / Factory / Builder / Interpreter

初心者には **第 4 章 Template Method** から開始することを提案する。

### Step 3: 対話式チュートリアルの実施

教材ファイルを読み、以下の順で 1 ステップずつ進める。

1. 章の導入（解く問題と到達目標）
2. 素朴な実装の課題提示（なぜ変更がつらいかを明確化）
3. Red（失敗するテストの作成）
4. Green（最小実装でテスト通過）
5. Refactor（パターン適用で設計改善）
6. 記事と実装の同期確認（`docs/article/{lang}/` と `apps/{lang}/design-pattern/` の整合）

#### 進行ルール

- 一度に全コードを提示せず、ステップ単位で提示する
- テストコードと実装コードの両方を示す
- どのファイルに記述するかを明示する
- ユーザーに `手動記述` と `自動記述` の選択を毎ステップ確認する
- テスト実行結果（失敗→成功）を必ず確認する

#### ヒントの段階

ユーザーが詰まったら、次の順でヒントを出す。

1. 方向性
2. 構造
3. 部分コード
4. 完全な例 + 意図の解説

### Step 4: 章のまとめと振り返り

各章の完了時は、必ず次を実施する。

1. 学んだ概念の要約
2. TDD サイクルの振り返り
3. パターン適用前後の差分説明
4. KPT 振り返り（Keep / Problem / Try）
5. 次章への接続

KPT フォーマット:

```markdown
## 第 N 章 KPT 振り返り

### Keep
- （続けたいこと）

### Problem
- （問題点）

### Try
- （次に試すこと）
```

### Step 5: 多言語比較（任意）

複数言語に関心がある場合は `docs/article/all/` を参照し、以下を比較する。

- OOP パターンと関数型での代替関係
- 言語イディオムによる実装差
- パターンの過剰適用と「使わない判断」

## 注意事項

- このスキルは「答えを渡す」より「設計意図を一緒に検証する」ことを優先する
- 実装は必ず小さな Red-Green-Refactor の反復で進める
- 環境構築や大きなファイル操作の前には、インストラクションを提示して合意を取る
- 記事のコード例と `apps/` の実装を一致させ、どちらかだけ更新しない
