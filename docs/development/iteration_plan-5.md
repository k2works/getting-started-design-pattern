# イテレーション 5 計画 - TypeScript（型安全なパターン）

## 概要

| 項目 | 内容 |
|------|------|
| **イテレーション** | 5 |
| **期間** | Week 9-10（2026-06-22 〜 2026-07-05） |
| **ゴール** | ジェネリクス・ユニオン型・型ガードを活用した型安全な 13 パターンの TDD 実装と記事を完成させ、Phase 1（Release 0.1.0）を完了する |
| **目標 SP** | 13 |

### 成功基準

- [ ] `docs/article/typescript/` に 16 章 + index.md
- [ ] `apps/typescript/design-pattern/` のテストがすべてパス
- [ ] mkdocs.yml に TypeScript セクション追加
- [ ] テストカバレッジ 80% 以上
- [ ] `.github/workflows/ci-typescript.yml` が正常動作

### TypeScript 版の特徴

| 観点 | JavaScript | TypeScript |
|------|-----------|-----------|
| 型システム | Duck Typing | 構造的型付け + ジェネリクス |
| Strategy | 関数オブジェクト | 型付き関数型（`(r: Report) => string`） |
| Iterator | Symbol.iterator | `Iterable<T>` / `Iterator<T>` |
| Proxy | ES6 Proxy API | `ProxyHandler<T>` |
| Singleton | クロージャ | `private constructor` |
| Builder | メソッドチェーン | 型安全なメソッドチェーン |
| Composite | Duck Typing | `interface` + ジェネリクス |

## タスク合計

| カテゴリ | SP | 状態 |
|---------|----|----|
| 環境構築（ts-jest + CI） | 1 | [ ] |
| 第 1-2 部（章 1-8） | 6 | [ ] |
| 第 3 部（章 9-12） | 3 | [ ] |
| 第 4 部（章 13-16） | 3 | [ ] |
| **合計** | **13** | |
