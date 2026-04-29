# 第 3 章 パターンで変わるものと変わらないもの

## はじめに

デザインパターンの本質は「変化する部分をカプセル化する」ことです。GoF の 23 パターンは、異なる種類の変化に対応するための設計テクニックを体系化したものです。本章では、パターンが何を一定に保ち、何を変化可能にするのかを整理します。

## 変わるものと変わらないものの分離

```plantuml
@startuml
class "変わらないもの（骨格）" as Stable {
  + アルゴリズムの構造
  + 呼び出しプロトコル
  + 組み合わせ方
}

class "変わるもの（詳細）" as Variable {
  + 具体的な処理
  + 生成するオブジェクト
  + 通知先
}

Stable --> Variable : 委譲 / 継承 / 注入
@enduml
```

### パターン別の「変わるもの」

| パターン | 変わらないもの | 変わるもの |
|:---|:---|:---|
| Template Method | アルゴリズムの骨格 | 具体的なステップの実装 |
| Strategy | コンテキストの構造 | アルゴリズム全体 |
| Observer | 通知メカニズム | オブザーバーの数と種類 |
| Composite | ツリー構造の走査 | ノードの種類と振る舞い |
| Iterator | 走査プロトコル | コレクションの内部構造 |
| Command | 実行/取消のプロトコル | 具体的な操作 |
| Adapter | クライアントが期待する API | 適合先の API |
| Proxy | アクセスプロトコル | アクセス制御のルール |
| Decorator | 基本インターフェース | 追加される振る舞い |
| Singleton | インスタンスの一意性 | インスタンスの状態 |
| Factory | 生成プロトコル | 生成されるオブジェクトの種類 |
| Builder | 構築手順 | 構築されるオブジェクトの表現 |
| Interpreter | 文法構造の走査 | 具体的な文法規則 |

## TypeScript での「変わるもの」のカプセル化

### 1. interface による抽象化

```typescript
// 「変わるもの」を interface で定義する
interface Formatter {
  format(title: string, text: string[]): string;
}

// コンテキストは interface に依存する
class Report {
  constructor(private formatter: Formatter) {}
  output(title: string, text: string[]): string {
    return this.formatter.format(title, text);
  }
}
```

### 2. abstract class によるテンプレート

```typescript
abstract class Report {
  // 変わらないもの: outputReport() の構造
  outputReport(): string {
    return this.outputStart() + this.outputBody() + this.outputEnd();
  }
  // 変わるもの: 具体的なステップ
  protected abstract outputStart(): string;
  protected abstract outputBody(): string;
  protected abstract outputEnd(): string;
}
```

### 3. Generics による型安全な汎用化

```typescript
// T が「変わるもの」
function createProxy<T extends object>(target: T, handler: ProxyHandler<T>): T {
  return new Proxy(target, handler);
}
```

### 4. 関数型による Strategy 注入

```typescript
type Formatter = (title: string, text: string[]) => string;

// 関数として「変わるもの」を渡す
class Report {
  constructor(private formatter: Formatter) {}
}
```

## 継承 vs 委譲

GoF の原則:「継承よりもオブジェクトの合成を好め」

```plantuml
@startuml
package "継承（Template Method）" {
  abstract class "AbstractReport" as AR {
    + outputReport()
    # {abstract} outputLine()
  }
  class "HtmlReport" as HR
  AR <|-- HR
}

package "委譲（Strategy）" {
  class "Report" as R {
    - formatter: Formatter
    + outputReport()
  }
  interface "Formatter" as F {
    + format()
  }
  R --> F
}
@enduml
```

| 観点 | 継承 | 委譲 |
|:---|:---|:---|
| 柔軟性 | コンパイル時に決定 | 実行時に変更可能 |
| 結合度 | 高い | 低い |
| 適用場面 | 骨格が固定、詳細が変化 | アルゴリズム全体が差し替え |

---

## 静的コード解析: ESLint + @typescript-eslint

### ESLint + @typescript-eslint とは

ESLint は JavaScript / TypeScript の静的解析ツールです。`@typescript-eslint` プラグインを組み合わせることで、TypeScript の型情報を活用した高度な解析が可能になります。

### eslint.config.mjs の設定

```javascript
// eslint.config.mjs
import tseslint from "@typescript-eslint/eslint-plugin";
import tsparser from "@typescript-eslint/parser";

export default [
  {
    files: ["**/*.ts"],
    languageOptions: {
      parser: tsparser,
      parserOptions: {
        ecmaVersion: 2022,
        sourceType: "module",
      },
    },
    plugins: {
      "@typescript-eslint": tseslint,
    },
    rules: {
      "@typescript-eslint/no-unused-vars": ["error", { argsIgnorePattern: "^_" }],
      "@typescript-eslint/no-explicit-any": "warn",
      complexity: ["error", 7],
      "prefer-const": "error",
      eqeqeq: ["error", "always"],
    },
  },
];
```

### 主要なルールの解説

| ルール | 設定 | 説明 |
|--------|------|------|
| `@typescript-eslint/no-unused-vars` | error | 未使用変数の検出（TypeScript 対応版） |
| `@typescript-eslint/no-explicit-any` | warn | `any` 型の使用を警告 |
| `complexity` | Max: 7 | 循環的複雑度の上限 |
| `prefer-const` | error | 再代入しない変数は `const` を使用 |

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
    "check": "eslint . && jest --verbose"
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
| 静的解析 | RuboCop | Checkstyle + PMD | ESLint + @typescript-eslint | Ruff |
| フォーマッター | RuboCop | Checkstyle | Prettier | Ruff |
| カバレッジ | SimpleCov | JaCoCo | @vitest/coverage-v8 | pytest-cov |
| 複雑度チェック | RuboCop Metrics | Checkstyle CyclomaticComplexity | ESLint complexity | Ruff McCabe |

---

## まとめ

デザインパターンの本質は、変化する部分を見極め、それを安全にカプセル化することです。TypeScript では、`interface`、`abstract class`、Generics、関数型を使い分けることで、「変わるもの」と「変わらないもの」の境界を型レベルで明確に定義できます。この明確さが、保守性の高い設計につながります。

- ESLint + @typescript-eslint で静的解析・コード複雑度（循環的複雑度 7 以下）を自動チェックする
- `npm run check` で静的解析 + テストを一括実行できる
