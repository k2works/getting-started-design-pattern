# 第 3 章: 開発環境と TDD 基盤

## はじめに

本シリーズでは、すべてのデザインパターンを **TDD（テスト駆動開発）** で実装します。本章では、Node.js + Jest による開発環境のセットアップと TDD の基本サイクルを解説します。

---

## 開発環境

### Node.js プロジェクトの構成

```
apps/javascript/design-pattern/
  ├── package.json
  ├── jest.config.js
  ├── src/          # 実装コード
  │   ├── template-method.js
  │   ├── strategy.js
  │   └── ...
  └── tests/        # テストコード
      ├── template-method.test.js
      ├── strategy.test.js
      └── ...
```

### package.json

```json
{
  "type": "module",
  "scripts": {
    "test": "node --experimental-vm-modules node_modules/.bin/jest --verbose",
    "test:coverage": "node --experimental-vm-modules node_modules/.bin/jest --coverage"
  },
  "devDependencies": {
    "jest": "^29.7.0",
    "@jest/globals": "^29.7.0"
  }
}
```

**ポイント**:
- `"type": "module"` で ES モジュール（`import` / `export`）を有効化
- `--experimental-vm-modules` で Jest が ESM をサポート

### jest.config.js

```javascript
export default {
  testMatch: ['**/tests/**/*.test.js'],
  transform: {},
  coverageDirectory: 'coverage',
  collectCoverageFrom: ['src/**/*.js'],
};
```

`transform: {}` は「トランスパイルしない」設定です。Node.js のネイティブ ESM をそのまま使います。

---

## TDD の基本サイクル

### Red - Green - Refactor

```plantuml
@startuml
title TDD サイクル

state Red : 失敗するテストを書く
state Green : テストを通す最小のコード
state Refactor : 設計を改善する

[*] --> Red
Red --> Green : 実装
Green --> Refactor : きれいにする
Refactor --> Red : 次のテスト
@enduml
```

1. **Red**: 実装したい振る舞いをテストで表現する。テストは失敗する
2. **Green**: テストを通す最小限のコードを書く
3. **Refactor**: テストが通った状態でコードを改善する

### テストの書き方

Jest では `describe` / `it` / `expect` を使います。

```javascript
import { describe, it, expect } from '@jest/globals';
import { HtmlReport } from '../src/template-method.js';

describe('Template Method パターン', () => {
  it('HtmlReport が HTML 形式で出力する', () => {
    const report = new HtmlReport();
    const output = report.outputReport();

    expect(output).toContain('<html>');
    expect(output).toContain('<title>月次報告</title>');
  });
});
```

### テスト命名の規約

テスト名は **「何が」「どうなるか」** を明確に表現します。

- `HtmlReport が HTML 形式で出力する`
- `基底クラス Report の outputLine は例外を投げる`
- `salary 変更で Payroll に通知が届く`

---

## テストの実行

```bash
# 全テスト実行
npm test

# カバレッジ付き
npm run test:coverage

# 特定ファイルのみ
npx jest tests/template-method.test.js
```

---

## ES モジュールの注意点

### import / export

```javascript
// 名前付きエクスポート
export class Report { }
export function htmlFormatter(report) { }

// インポート
import { Report, htmlFormatter } from '../src/strategy.js';
```

### Node.js 組み込みモジュール

```javascript
import { writeFileSync, existsSync } from 'fs';
import { join } from 'path';
import { tmpdir } from 'os';
```

---

## 静的コード解析: ESLint

### ESLint とは

ESLint は JavaScript の静的解析ツールです。コーディングスタイルの違反やバグの可能性を検出し、一部は自動修正できます。本プロジェクトでは flat config 形式で設定します。

### eslint.config.js の設定

```javascript
// eslint.config.js
export default [
  {
    files: ["**/*.js"],
    languageOptions: {
      ecmaVersion: 2022,
      sourceType: "module",
    },
    rules: {
      "no-unused-vars": ["error", { argsIgnorePattern: "^_" }],
      "no-undef": "error",
      complexity: ["error", 7],
      "no-var": "error",
      "prefer-const": "error",
      eqeqeq: ["error", "always"],
    },
  },
  {
    files: ["tests/**/*.js"],
    languageOptions: {
      globals: {
        describe: "readonly",
        it: "readonly",
        expect: "readonly",
        // ... Jest グローバル
      },
    },
  },
];
```

### 主要なルールの解説

| ルール | 設定 | 説明 |
|--------|------|------|
| `no-unused-vars` | error | 未使用変数の検出（`_` 開始は除外） |
| `no-undef` | error | 未定義変数の使用を禁止 |
| `complexity` | Max: 7 | 循環的複雑度の上限 |
| `prefer-const` | error | 再代入しない変数は `const` を使用 |
| `eqeqeq` | always | `===` / `!==` の使用を強制 |

### ESLint の実行

```bash
# 解析の実行
npx eslint .

# 自動修正
npx eslint . --fix
```

---

## コード複雑度のチェック

### 循環的複雑度（Cyclomatic Complexity）

循環的複雑度とは、コードがどれぐらい複雑であるかを関数単位で数値にして表す指標です。本プロジェクトでは **7 以下** に制限しています。

| 複雑度の範囲 | 意味 |
|-------------|------|
| 1〜10 | 低複雑度: 管理しやすく、問題なし |
| 11〜20 | 中程度の複雑度: リファクタリングを検討 |
| 21〜50 | 高複雑度: リファクタリングが強く推奨される |
| 51 以上 | 非常に高い複雑度: コードを分割する必要がある |

---

## 品質チェックの一括実行

package.json に `check` スクリプトを追加して、ESLint + Jest を一括実行できます。

```json
{
  "scripts": {
    "lint": "eslint .",
    "check": "eslint . && node --experimental-vm-modules node_modules/.bin/jest --verbose"
  }
}
```

```bash
# 静的解析 + テストを一括実行
npm run check
```

### 各言語の品質ツール比較

| 用途 | Ruby | Java | TypeScript | Python |
|------|------|------|-----------|--------|
| パッケージ管理 | Bundler | Gradle | npm | uv |
| テスト | minitest | JUnit 5 | Jest | pytest |
| 静的解析 | RuboCop | Checkstyle + PMD | ESLint | Ruff |
| フォーマッター | RuboCop | Checkstyle | Prettier | Ruff |
| カバレッジ | SimpleCov | JaCoCo | @vitest/coverage-v8 | pytest-cov |
| 複雑度チェック | RuboCop Metrics | Checkstyle CyclomaticComplexity | ESLint complexity | Ruff McCabe |

---

## Ruby / Java / Python との比較

| 観点 | Ruby | Java | Python | JavaScript |
|------|------|------|--------|------------|
| テストフレームワーク | Minitest / RSpec | JUnit | pytest | Jest |
| モジュールシステム | `require` | `import` (パッケージ) | `import` | ES Modules (`import`/`export`) |
| 型チェック | なし | コンパイル時 | なし (型ヒント) | なし (TypeScript で可能) |
| パッケージ管理 | Bundler | Maven / Gradle | pip | npm |
| テスト実行 | `rake test` | `mvn test` | `pytest` | `npm test` |

---

## まとめ

| 観点 | 内容 |
|------|------|
| **環境** | Node.js + Jest、ES モジュール |
| **TDD サイクル** | Red → Green → Refactor を数分以内で回す |
| **テスト構成** | `describe` / `it` / `expect` で意図を明確に |
| **ES モジュール** | `"type": "module"` + `--experimental-vm-modules` |
| **静的解析** | ESLint で静的解析・コード複雑度（循環的複雑度 7 以下）を自動チェックする |
| **一括実行** | `npm run check` で静的解析 + テストを一括実行できる |
| **次章から** | Template Method パターンを TDD で実装する |
