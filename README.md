# デザインパターンからはじめるプログラミング入門

このリポジトリは、写経しながらデザインパターンとソフトウェア開発の原理原則を学ぶための教材です。

[デザインパターンからはじめるプログラミング入門 AI 時代の写経](https://k2works.github.io/getting-started-design-pattern/slide/%E3%82%B9%E3%83%A9%E3%82%A4%E3%83%89.html)

## Quick Start

写経を始めるまでの手順です。

1. `sandbox` ブランチをチェックアウトします。

```bash
git clone https://github.com/k2works/getting-started-design-pattern.git
cd getting-started-design-pattern
git checkout sandbox
```

2. GitHub Codespaces を起動します。

ブラウザから起動する場合:

- GitHub でこのリポジトリを開き、`Code` → `Codespaces` → `Create codespace on sandbox` を選択します。

GitHub CLI から起動する場合:

```bash
gh auth login
gh codespace create --repo k2works/getting-started-design-pattern --branch sandbox
```

3. Codespaces の起動後、教材を開いて写経を開始します。

- スライド: [デザインパターンからはじめるプログラミング入門 AI 時代の写経](https://k2works.github.io/getting-started-design-pattern/slide/%E3%82%B9%E3%83%A9%E3%82%A4%E3%83%89.html)
- ドキュメント: [MkDocs サイト](https://k2works.github.io/getting-started-design-pattern/)

必要に応じて、ローカルでドキュメントを起動できます。

```bash
npm install
npm run docs:serve
```

作業を再開する場合は、既存の Codespace に接続します。

```bash
gh codespace ssh
```

複数の Codespace がある場合は、先に一覧を確認します。

```bash
gh codespace list
gh codespace ssh --codespace <codespace-name>
```
