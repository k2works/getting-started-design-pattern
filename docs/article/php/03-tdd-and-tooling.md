# 第 3 章: 開発環境と TDD 基盤

## はじめに

本シリーズでは PHP 8.x と PHPUnit 11 を使い、TDD（テスト駆動開発）で 13 のデザインパターンを実装します。この章では開発環境のセットアップと TDD の基本サイクルを確認します。

---

## 環境セットアップ

### 必要なツール

| ツール | バージョン | 用途 |
|-------|----------|------|
| PHP | 8.1 以上 | 実行環境 |
| Composer | 2.x | パッケージ管理 |
| PHPUnit | 11.x | テストフレームワーク |

### プロジェクトの初期化

```bash
mkdir -p apps/php/design-pattern && cd apps/php/design-pattern
mkdir -p src tests
```

### composer.json

```json
{
    "name": "design-pattern/php",
    "autoload": {
        "psr-4": { "DesignPattern\\": "src/" },
        "classmap": ["src/"]
    },
    "autoload-dev": {
        "psr-4": { "DesignPattern\\Tests\\": "tests/" }
    },
    "require-dev": {
        "phpunit/phpunit": "^11.0"
    }
}
```

### phpunit.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<phpunit bootstrap="vendor/autoload.php" colors="true">
    <testsuites>
        <testsuite name="Design Patterns">
            <directory>tests</directory>
        </testsuite>
    </testsuites>
    <source>
        <include><directory suffix=".php">src</directory></include>
    </source>
</phpunit>
```

### 依存関係のインストール

```bash
composer install
```

---

## TDD の基本サイクル

### Red-Green-Refactor

```plantuml
@startuml
title TDD サイクル

state "Red" as R : 失敗するテストを書く
state "Green" as G : テストを通す最小のコードを書く
state "Refactor" as F : 設計を改善する

R --> G : 最小限の実装
G --> F : テストが通った
F --> R : 次のテスト
@enduml
```

1. **Red**: 実装したい振る舞いをテストで表現する
2. **Green**: テストを通す最小限のコードを書く
3. **Refactor**: テストが通った状態でコードを改善する

### PHPUnit テストの基本構造

```php
<?php
declare(strict_types=1);

namespace DesignPattern\Tests;

use PHPUnit\Framework\TestCase;

class ExampleTest extends TestCase
{
    public function testSomething(): void
    {
        // Arrange（準備）
        $sut = new SomeClass();

        // Act（実行）
        $result = $sut->doSomething();

        // Assert（検証）
        $this->assertSame('expected', $result);
    }
}
```

### テストの実行

```bash
# 全テスト実行
./vendor/bin/phpunit

# 特定のテストファイル
./vendor/bin/phpunit tests/TemplateMethodTest.php

# 特定のテストメソッド
./vendor/bin/phpunit --filter testHtmlReportContainsTitle
```

---

## PHP 8.x の主要機能

本シリーズで活用する PHP 8.x の機能を紹介します。

### 型宣言

```php
function add(int $a, int $b): int {
    return $a + $b;
}
```

### Constructor Promotion

```php
class Account {
    public function __construct(
        private readonly string $name,
        private float $balance
    ) {}
}
```

### Named Arguments

```php
$report = new Report(
    title: '月次報告',
    text: ['順調', '最高の調子']
);
```

### Match 式

```php
$result = match($type) {
    'html' => new HtmlFormatter(),
    'text' => new PlainTextFormatter(),
    default => throw new \InvalidArgumentException("Unknown type: {$type}"),
};
```

### Enum (PHP 8.1+)

```php
enum Color: string {
    case Red = 'red';
    case Blue = 'blue';
    case Green = 'green';
}
```

---

## ディレクトリ構成

```
apps/php/design-pattern/
├── composer.json
├── phpunit.xml
├── src/
│   ├── TemplateMethod/
│   │   ├── Report.php
│   │   ├── HtmlReport.php
│   │   └── PlainTextReport.php
│   ├── Strategy/
│   ├── Observer/
│   └── ...
├── tests/
│   ├── TemplateMethodTest.php
│   ├── StrategyTest.php
│   └── ...
└── vendor/
```

---

## 静的コード解析: PHP_CodeSniffer

PHP_CodeSniffer（phpcs）はコーディング規約への準拠をチェックする静的解析ツールです。

### インストール

```json
{
    "require-dev": {
        "phpunit/phpunit": "^11.0",
        "squizlabs/php_codesniffer": "^3.10"
    }
}
```

```bash
composer update
```

### phpcs.xml の設定

プロジェクトルートに `phpcs.xml` を配置します。

```xml
<?xml version="1.0"?>
<ruleset name="DesignPattern">
    <description>PSR-12 with exceptions for design pattern examples</description>

    <file>src/</file>

    <rule ref="PSR12"/>

    <!-- パターン実装では関連クラス・インターフェースを1ファイルにまとめる -->
    <rule ref="PSR1.Classes.ClassDeclaration.MultipleClasses">
        <severity>0</severity>
    </rule>
</ruleset>
```

### 実行

```bash
# コーディング規約チェック
./vendor/bin/phpcs

# 自動修正
./vendor/bin/phpcbf
```

### 主な PSR-12 ルール

| ルール | 説明 |
|--------|------|
| インデント | スペース 4 つ |
| 行の長さ | 120 文字以下（推奨） |
| 名前空間 | `namespace` 宣言の後に空行 |
| `use` 宣言 | `namespace` の後にまとめる |
| クラス定義 | 開き波括弧は次の行 |
| メソッド定義 | 開き波括弧は次の行 |

### 意図的なルール除外

デザインパターンの教材では、関連するクラスやインターフェースを 1 ファイルにまとめて解説するため、PSR-1 の「1 ファイル 1 クラス」ルールを除外しています。

---

## コード複雑度のチェック

PHP_CodeSniffer は循環的複雑度（Cyclomatic Complexity）のチェックも提供しています。`phpcs.xml` に以下を追加することで有効化できます:

```xml
<rule ref="Generic.Metrics.CyclomaticComplexity">
    <properties>
        <property name="complexity" value="7"/>
        <property name="absoluteComplexity" value="10"/>
    </properties>
</rule>
```

---

## 品質チェックの一括実行

`composer.json` の `scripts` セクションに一括実行コマンドを定義します。

### composer.json scripts

```json
{
    "scripts": {
        "test": "./vendor/bin/phpunit",
        "phpcs": "./vendor/bin/phpcs",
        "phpcbf": "./vendor/bin/phpcbf",
        "check": ["@phpcs", "@test"]
    }
}
```

### 実行

```bash
composer check
```

`composer check` は `phpcs`（静的解析）と `phpunit`（テスト）を順番に実行します。phpcs で違反が見つかった場合、テストは実行されません。

---

## 各言語の品質ツール比較

| 用途 | PHP | Ruby | Java | TypeScript | Python |
|------|-----|------|------|-----------|--------|
| 静的解析 | PHP_CodeSniffer | RuboCop | Checkstyle + PMD | ESLint | Ruff |
| フォーマッター | phpcbf | RuboCop | Checkstyle | Prettier | Ruff |
| カバレッジ | phpunit --coverage | SimpleCov | JaCoCo | @vitest/coverage-v8 | pytest-cov |
| 複雑度チェック | phpcs Generic.Metrics | RuboCop Metrics | PMD | ESLint complexity | Ruff McCabe |
| 一括実行 | `composer check` | `rake check` | `./gradlew check` | `npm run lint && npm test` | `ruff check && pytest` |

**PHP の特徴**: PSR-12 という公式のコーディング規約があり、PHP_CodeSniffer で自動チェック・自動修正が可能です。

---

## まとめ

- PHP 8.x + PHPUnit 11 + Composer で TDD 環境を構築した
- Red-Green-Refactor サイクルを厳守してパターンを実装する
- PHP 8.x の型宣言、Constructor Promotion、match 式を積極活用する
- PHP_CodeSniffer で PSR-12 準拠をチェックし、`composer check` で一括実行する
- 次章から、最初のパターン「Template Method」を TDD で実装する
