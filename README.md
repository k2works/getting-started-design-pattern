# デザインパターンからはじめるプログラミング入門

## 概要

[デザインパターンからはじめるプログラミング入門 AI時代の写経](https://k2works.github.io/getting-started-design-pattern/slide/%E3%82%B9%E3%83%A9%E3%82%A4%E3%83%89.html)


デザインパターンを題材に、よいソフトウェア（変更を楽に安全にできて役に立つソフトウェア）を作るための規律と実践を学ぶプロジェクトです。AI コーディングエージェント（Claude Code / Codex CLI など）と XP（エクストリームプログラミング）のプラクティスを融合し、分析・開発・運用の各フェーズを Skills 体系でオーケストレーションします。

### 目的

- デザインパターンを通じて、SOLID 原則・DDD・TDD・リファクタリングといったソフトウェア開発の原理原則を体得する。
- AI エージェントとの協働で、分析→開発→運用のライフサイクル全体を体験する。
- 学習成果を MkDocs サイトとしてドキュメント化し、継続的に整備する。

### 前提

| ソフトウェア   | バージョン | 備考                                          |
| :------------- | :--------- | :-------------------------------------------- |
| Node.js        | 22.x       | Gulp タスクランナーの実行に必要               |
| Python         | 3.x        | MkDocs によるドキュメントビルドに必要         |
| Docker         | 最新       | `docker-compose` で MkDocs / dev コンテナ起動 |
| Nix            | Flakes 有効 | 任意。再現可能な開発環境を構築する場合に使用  |
| Claude Code    | 最新       | AI エージェントによる開発支援                 |

## 構成

- [ディレクトリ構成](#ディレクトリ構成)
- [分析](#分析)
- [開発](#開発)
- [運用](#運用)
- [構築](#構築)
- [配置](#配置)

## 詳細

### Quick Start

```bash
# 依存関係のインストール
npm install

# MkDocs サーバーを起動してブラウザで開く（http://localhost:8000）
npm start
```

### ディレクトリ構成

```
.
├── apps/                # アプリケーションコード（言語別サブディレクトリを配置）
├── docs/                # MkDocs で公開するドキュメント
│   ├── strategy/        # 戦略（企業分析・経営戦略・ビジネスアーキテクチャ）
│   ├── requirements/    # 要件定義（RDRA 2.0・ユースケース）
│   ├── design/          # 設計（アーキテクチャ・ドメイン・データ・UI）
│   ├── development/     # 開発（リリース計画・イテレーション計画）
│   ├── operation/       # 運用（環境構築・デプロイ）
│   ├── review/          # レビュー結果
│   ├── adr/             # Architecture Decision Records
│   ├── article/         # 学習用記事シリーズ
│   ├── reference/       # 開発ガイド・リファレンス
│   ├── template/        # 各種テンプレート
│   ├── journal/         # 作業履歴（Git ログから自動生成）
│   └── assets/          # MkDocs 用 CSS / JS
├── ops/                 # 運用スクリプト
│   ├── scripts/         # Gulp タスクモジュール（mkdocs / journal / vault など）
│   ├── docker/          # Docker 関連設定
│   └── nix/             # Nix 関連設定
├── .agents/             # AI エージェント関連リソース
├── .claude/             # Claude Code 設定（Skills を含む）
├── .devcontainer/       # Dev Container 設定
├── .github/             # GitHub Actions ワークフロー
├── flake.nix            # Nix Flakes 定義
├── gulpfile.js          # Gulp タスク定義
├── docker-compose.yml   # Docker Compose 定義
├── mkdocs.yml           # MkDocs 設定
├── CLAUDE.md            # AI エージェント実行ガイドライン
└── AGENTS.md            # AI コーディングエージェント向けガイドライン
```

**[⬆ back to top](#構成)**

### 分析

分析フェーズでは、戦略立案から要件定義・機能要件・非機能要件までを段階的に整理します。詳細なフローと各成果物のテンプレートは [開発ガイド](docs/reference/開発ガイド.md) と [Skills 体系](#aiアシスタントskills) を参照してください。

主な成果物の置き場所：

- 戦略 — `docs/strategy/`
- 要件定義 — `docs/requirements/`
- 設計（アーキテクチャ・ドメイン・データ・UI・テスト戦略・非機能） — `docs/design/`
- ADR — `docs/adr/`

オーケストレーションスキル `orchestrating-analysis` が分析フェーズ全体のワークフローを案内します。

**[⬆ back to top](#構成)**

### 開発

開発フェーズでは、リリース計画・イテレーション計画に基づいて TDD サイクルで実装を進めます。

- リリース・イテレーション計画 — `docs/development/`
- アプリケーションコード — `apps/`
- レビュー結果 — `docs/review/`

オーケストレーションスキル `orchestrating-development` が、バックエンド（インサイドアウト）／フロントエンド（アウトサイドイン）の TDD ワークフローと Codex 分業体制を案内します。

**[⬆ back to top](#構成)**

### 運用

運用フェーズでは、環境構築・プロビジョニング・CI/CD・デプロイ・運用スクリプト整備までを段階的に進めます。

#### ドキュメントの編集

1. ローカル環境で MkDocs サーバーを起動
   ```bash
   docker-compose up mkdocs
   ```
   または、Gulp タスクを使用:
   ```bash
   npm run docs:serve
   ```

2. ブラウザで http://localhost:8000 にアクセスして編集結果をプレビュー

3. `docs/` ディレクトリ内の Markdown ファイルを編集

4. 変更をコミットしてプッシュ
   ```bash
   git add .
   git commit -m "docs: ドキュメントを更新"
   git push
   ```

#### Gulp タスクの使用

プロジェクトには以下の Gulp タスクが用意されています。

##### MkDocs タスク

- MkDocs サーバーの起動: `npm run docs:serve` または `npx gulp mkdocs:serve`
- MkDocs サーバーの停止: `npm run docs:stop` または `npx gulp mkdocs:stop`
- MkDocs ドキュメントのビルド: `npm run docs:build` または `npx gulp mkdocs:build`

##### 作業履歴（ジャーナル）タスク

- すべてのコミット日付の作業履歴を生成: `npm run journal` または `npx gulp journal:generate`
- 特定の日付の作業履歴を生成:
  ```bash
  npx gulp journal:generate:date --date=YYYY-MM-DD
  ```
  (例: `npx gulp journal:generate:date --date=2023-04-01`)

生成された作業履歴は `docs/journal/` ディレクトリに保存され、各ファイルには指定された日付のコミット情報が含まれます。

##### Vault タスク

`.env.vault` を用いた環境変数の暗号化・復号・閲覧・再キーを行います。

- 暗号化: `npm run vault:encrypt`
- 復号: `npm run vault:decrypt`
- 閲覧: `npm run vault:view`
- 再キー: `npm run vault:rekey`

詳細は [環境変数管理ガイド](docs/reference/環境変数管理ガイド.md) を参照してください。

オーケストレーションスキル `orchestrating-operation` が運用フェーズ全体のワークフローを案内します。

**[⬆ back to top](#構成)**

### 構築

開発環境の構築手順です。AI エージェントとの協働を前提に、MCP サーバー登録、Skills 体系の有効化、再現可能な環境（Nix / Codespaces）を整備します。

#### MCP サーバー登録

```bash
claude mcp add -s project memory -- npx @modelcontextprotocol/server-memory
claude mcp add -s project codex -- npx @openai/codex mcp-server
```

#### ralph-loop の導入

- Claude Code 起動後、`/plugin` を実行
- 検索ボックスで ralph-loop を探して選択
- インストールするスコープを選ぶ（ユーザー / プロジェクト / ローカル）
- Claude Code を再起動
- コマンドで実行

```powershell
/ralph-loop "<プロンプト>" --max-iterations <数値> --completion-promise "<完了テキスト>"
```

#### AI アシスタント（Skills） {#aiアシスタントskills}

`.claude/skills/` ディレクトリに定義された Skills により、AI アシスタントがタスクに応じた専門的な指示を自動的に読み込みます。Progressive Disclosure（段階的開示）により、必要なスキルのみがコンテキストに展開されます。

Skills 一覧は [CLAUDE.md の Skills 体系](CLAUDE.md#skills-体系) を参照してください。

新しいスキルの追加・改善には `/skill-creator` プラグインを使用します。テスト・評価・最適化を含むスキル作成ワークフローが自動化されます。

#### Nix による開発環境

Nix を使用して、再現可能な開発環境を構築できます。

##### 準備

1. [Nix をインストール](https://nixos.org/download.html)します。
2. Flakes を有効にします（`~/.config/nix/nix.conf` に `experimental-features = nix-command flakes` を追加）。

##### 環境の利用

- **デフォルト環境（共通ツール）に入る:**
  ```bash
  nix develop
  ```

- **Node.js 環境に入る:**
  ```bash
  nix develop .#node
  ```

- **Python / MkDocs 環境に入る:**
  ```bash
  nix develop .#python
  ```

環境から抜けるには `exit` を入力します。

##### 依存関係の更新

```bash
nix flake update
```

#### GitHub Codespaces に SSH 接続

外部ターミナルアプリから GitHub Codespaces に SSH 接続することで、VS Code のエディタスペースを広く使いながら別ウィンドウのターミナルで作業できます。

##### 前提条件

- [GitHub CLI](https://cli.github.com/) がインストール済みであること

##### 手順

1. **Codespace を作成する**

   https://github.com/codespaces から Codespace を作成します。

2. **Codespace 名を確認する**

   ブラウザに表示される Codespace の URL から名前を取得します。

   例: URL が `https://upgraded-cod-rpxpjr97jrwcxxw7.github.dev/` の場合、Codespace 名は `upgraded-cod-rpxpjr97jrwcxxw7` です。

3. **SSH 接続する**

   ```bash
   gh codespace ssh -c <codespace名>
   ```

   例:
   ```bash
   gh codespace ssh -c upgraded-cod-rpxpjr97jrwcxxw7
   ```

接続後は `npm run build` や `git log` など通常のターミナル操作が可能です。

##### 参考

- [GitHub Codespaces に SSH 接続する](https://zenn.dev/hirokisakabe/articles/fdd7eb730423c0)

**[⬆ back to top](#構成)**

### 配置

#### GitHub Pages セットアップ

1. **GitHub リポジトリの Settings を開く**
    - リポジトリページで `Settings` タブをクリック

2. **Pages 設定を開く**
    - 左サイドバーの `Pages` をクリック

3. **Source を設定**
    - `Source` で `Deploy from a branch` を選択
    - `Branch` で `gh-pages` を選択し、フォルダは `/ (root)` を選択
    - `Save` をクリック

4. **初回デプロイ**
    - main ブランチにプッシュすると GitHub Actions が自動実行
    - Actions タブでデプロイ状況を確認

#### GitHub Container Registry

このプロジェクトでは、GitHub Container Registry（GHCR）を使用して開発コンテナイメージを管理しています。

##### 自動ビルド・プッシュ

タグをプッシュすると、GitHub Actions が自動的にコンテナイメージをビルドし、GHCR にプッシュします。

```bash
# タグを作成してプッシュ
git tag 0.0.1
git push origin 0.0.1
```

##### イメージの取得・実行

GHCR からイメージを取得して実行するには：

```bash
# イメージをプル
docker pull ghcr.io/k2works/getting-started-design-pattern:latest

# または特定バージョン
docker pull ghcr.io/k2works/getting-started-design-pattern:0.0.1

# コンテナを実行
docker run -it -v $(pwd):/srv ghcr.io/k2works/getting-started-design-pattern:latest
```

または、docker-compose を使用してローカルでビルド・実行することもできます：

```bash
# 開発環境を起動して中に入る
docker-compose run --rm dev bash
```

認証が必要な場合は、以下のコマンドでログインします：

```bash
# GitHub Personal Access Token でログイン
echo $GITHUB_TOKEN | docker login ghcr.io -u <username> --password-stdin
```

##### 権限設定

- リポジトリの Settings → Actions → General で `Read and write permissions` を設定
- `GITHUB_TOKEN` に `packages: write` 権限が付与されています

#### Dev Container の使用

VS Code で Dev Container を使用する場合：

1. VS Code で「Dev Containers: Reopen in Container」を実行
2. または「Dev Containers: Rebuild and Reopen in Container」で再ビルド

**[⬆ back to top](#構成)**

## 参照

- [CLAUDE.md](CLAUDE.md) — AI エージェント実行ガイドライン
- [AGENTS.md](AGENTS.md) — AI コーディングエージェント向けガイドライン
- [開発ガイド](docs/reference/開発ガイド.md) — 分析・開発・運用フェーズの全体像
- [よいソフトウェアとは](docs/reference/よいソフトウェアとは.md) — プロジェクトの価値観
- [ロジカルシンキング](docs/reference/ロジカルシンキング.md) — 思考の規律
- [ドキュメントサイト（MkDocs）](docs/index.md) — プロジェクトドキュメントの入口
