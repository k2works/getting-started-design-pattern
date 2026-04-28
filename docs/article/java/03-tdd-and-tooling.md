# 第 3 章: 開発環境と TDD 基盤

## はじめに

本章では、デザインパターンを TDD で実装するための Java 開発環境をセットアップします。

---

## 開発環境

### Java バージョン

本シリーズでは **JDK 21**（LTS）を使用します。

```bash
# Nix 環境の起動
nix-shell ops/nix/environments/java/shell.nix

# バージョン確認
java --version
javac --version
```

### プロジェクト構成

```
apps/java/design-pattern/
├── build.gradle
├── settings.gradle
├── gradlew / gradlew.bat
└── src/
    ├── main/java/pattern/
    │   ├── templatemethod/
    │   ├── strategy/
    │   └── ...
    └── test/java/pattern/
        ├── templatemethod/
        ├── strategy/
        └── ...
```

### ビルドツール: Gradle

```groovy
// build.gradle（抜粋）
plugins {
    id 'java'
    id 'jacoco'
}

dependencies {
    testImplementation platform('org.junit:junit-bom:5.11.4')
    testImplementation 'org.junit.jupiter:junit-jupiter'
}

test {
    useJUnitPlatform()
}
```

### セットアップ

```bash
cd apps/java/design-pattern
./gradlew test
```

---

## テスティングフレームワーク: JUnit 5

### テストの書き方

```java
package pattern.templatemethod;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class TemplateMethodTest {
    @Test
    void htmlReportOutput() {
        Report report = new HtmlReport();
        String result = report.outputReport();
        assertTrue(result.contains("<html>"));
    }
}
```

### 主要なアサーション

| メソッド | 用途 |
|---------|------|
| `assertEquals(expected, actual)` | 値の等価性 |
| `assertTrue(condition)` | 真であること |
| `assertThrows(Exception.class, () -> ...)` | 例外が投げられること |
| `assertSame(obj1, obj2)` | 同一オブジェクト（Singleton 検証） |

### テスト実行

```bash
# 全テスト実行
./gradlew test

# カバレッジレポート生成
./gradlew jacocoTestReport
# build/reports/jacoco/test/html/index.html で確認
```

---

## TDD サイクル

Ruby 版と同じ Red-Green-Refactor サイクルで進めます。

1. **Red**: パターンの期待動作を JUnit 5 で書く（コンパイルエラー含む）
2. **Green**: テストを通す最小限の実装を書く
3. **Refactor**: パターンの構造に沿ってリファクタリングする

### Ruby 版との違い

| 観点 | Ruby（minitest） | Java（JUnit 5） |
|------|----------------|-----------------|
| テスト発見 | ファイル名規約 `*_test.rb` | アノテーション `@Test` |
| アサーション | `assert_equal` | `assertEquals` |
| 例外テスト | `assert_raises` | `assertThrows` |
| カバレッジ | simplecov | JaCoCo |
| 実行 | `bundle exec rake test` | `./gradlew test` |

---

## 静的コード解析: Checkstyle

### Checkstyle とは

Checkstyle は Java のソースコードが規約に準拠しているかをチェックする静的解析ツールです。Google Java Style や Sun Code Conventions といった標準スタイルをベースに、プロジェクト固有のルールをカスタマイズできます。

### build.gradle への追加

```groovy
// build.gradle（Checkstyle プラグインの追加）
plugins {
    id 'java'
    id 'jacoco'
    id 'checkstyle'
}

checkstyle {
    toolVersion = '10.21.4'
    configFile = file("${rootDir}/config/checkstyle/checkstyle.xml")
    maxWarnings = 0
}
```

### checkstyle.xml の設定

```xml
<!-- config/checkstyle/checkstyle.xml（抜粋） -->
<module name="Checker">
    <module name="LineLength">
        <property name="max" value="200"/>
    </module>
    <module name="TreeWalker">
        <module name="AvoidStarImport"/>
        <module name="UnusedImports"/>
        <module name="MethodLength">
            <property name="max" value="30"/>
        </module>
        <module name="CyclomaticComplexity">
            <property name="max" value="7"/>
        </module>
    </module>
</module>
```

### 主要なルールの解説

| ルール | 設定 | 説明 |
|--------|------|------|
| `LineLength` | Max: 200 | 1 行の最大文字数 |
| `AvoidStarImport` | - | `import *` の禁止（個別 import を推奨） |
| `UnusedImports` | - | 未使用 import の検出 |
| `MethodLength` | Max: 30 | メソッドの最大行数 |
| `CyclomaticComplexity` | Max: 7 | 循環的複雑度の上限 |

### Checkstyle の実行

```bash
# Checkstyle のみ実行
./gradlew checkstyleMain checkstyleTest

# レポートは build/reports/checkstyle/ に出力される
```

---

## コード複雑度のチェック

### 循環的複雑度（Cyclomatic Complexity）

循環的複雑度とは、コードがどれぐらい複雑であるかをメソッド単位で数値にして表す指標です。本プロジェクトでは **7 以下** に制限しています。

| 複雑度の範囲 | 意味 |
|-------------|------|
| 1〜10 | 低複雑度: 管理しやすく、問題なし |
| 11〜20 | 中程度の複雑度: リファクタリングを検討 |
| 21〜50 | 高複雑度: リファクタリングが強く推奨される |
| 51 以上 | 非常に高い複雑度: コードを分割する必要がある |

---

## 品質チェックの一括実行

Gradle の `check` タスクは、Checkstyle プラグインを追加すると自動的に `checkstyleMain` + `checkstyleTest` + `test` を実行します。

```bash
# 静的解析 + テスト + カバレッジを一括実行
./gradlew check
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

## まとめ

- JDK 21 + Gradle + JUnit 5 + JaCoCo の環境を構築した
- パッケージは `pattern.{パターン名}` で名前空間を分離する
- TDD の Red-Green-Refactor サイクルでパターンを段階的に実装する
- カバレッジ目標は行・ブランチとも 80% 以上
- Checkstyle で静的解析・コード複雑度（循環的複雑度 7 以下）を自動チェックする
- `./gradlew check` で静的解析 + テスト + カバレッジを一括実行できる
- 次章からは、この環境を使って最初のパターン **Template Method** を実装する
