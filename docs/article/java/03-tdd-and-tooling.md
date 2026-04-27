# 第 3 章: 開発環境と TDD 基盤

## はじめに

本章では、デザインパターンを TDD で実装するための Java 開発環境をセットアップします。

---

## 開発環境

### Java バージョン

本シリーズでは **JDK 17**（LTS）を使用します。

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

## まとめ

- JDK 17 + Gradle + JUnit 5 + JaCoCo の環境を構築した
- パッケージは `pattern.{パターン名}` で名前空間を分離する
- TDD の Red-Green-Refactor サイクルでパターンを段階的に実装する
- カバレッジ目標は行・ブランチとも 80% 以上
- 次章からは、この環境を使って最初のパターン **Template Method** を実装する
