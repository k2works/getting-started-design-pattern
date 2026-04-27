# イテレーション 4 計画 - JavaScript（プロトタイプベース）

## 概要

| 項目 | 内容 |
|------|------|
| **イテレーション** | 4 |
| **期間** | Week 7-8（2026-06-08 〜 2026-06-21） |
| **ゴール** | プロトタイプベースのオブジェクト指向と関数オブジェクトを活かした 13 パターンの TDD 実装と記事を完成させる |
| **目標 SP** | 13 |

### 成功基準

- [ ] `docs/article/javascript/` に 16 章 + index.md
- [ ] `apps/javascript/design-pattern/` のテストがすべてパス
- [ ] mkdocs.yml に JavaScript セクション追加
- [ ] テストカバレッジ 80% 以上
- [ ] `.github/workflows/ci-javascript.yml` が正常動作

### JavaScript 版の特徴

| 観点 | Python | JavaScript |
|------|--------|-----------|
| 型システム | Duck Typing + 型ヒント | Duck Typing |
| Strategy | 関数（第一級） | 関数 / アロー関数 |
| Iterator | \_\_iter\_\_ / yield | Symbol.iterator / ジェネレータ |
| Decorator | @decorator | 関数合成 / Proxy API |
| Singleton | メタクラス | クロージャ / モジュールスコープ |
| Proxy | \_\_getattr\_\_ | Proxy API（ES6） |

## タスク合計

| カテゴリ | SP | 状態 |
|---------|----|----|
| 環境構築（Jest + CI） | 1 | [ ] |
| 第 1-2 部（章 1-8） | 6 | [ ] |
| 第 3 部（章 9-12） | 3 | [ ] |
| 第 4 部（章 13-16） | 3 | [ ] |
| **合計** | **13** | |
