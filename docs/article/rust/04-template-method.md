# 第 4 章：Template Method

## はじめに

Template Method パターンは、アルゴリズムの骨格を親クラスで定義し、具体的なステップをサブクラスに委譲するパターンです。Rust ではトレイトのデフォルト実装でこれを実現します。

## パターンの構造

```plantuml
@startuml
interface ReportFormatter {
  +title(): &str
  +lines(): &[String]
  +output_start(): String
  +output_line(line: &str): String
  +output_end(): String
  +output_report(): String
}

note right of ReportFormatter::output_report
  テンプレートメソッド（デフォルト実装）
  output_start() → title → output_line() × N → output_end()
end note

class HtmlReport {
  +title: String
  +lines: Vec<String>
}

class PlainTextReport {
  +title: String
  +lines: Vec<String>
}

ReportFormatter <|.. HtmlReport
ReportFormatter <|.. PlainTextReport
@enduml
```

## TDD で作る

### Red: テストを書く

```rust
#[test]
fn html_report_contains_html_tags() {
    let report = HtmlReport::new("Monthly Report", sample_lines());
    let output = report.output_report();
    assert!(output.contains("<html>"));
    assert!(output.contains("</html>"));
}
```

### Green: 最小限の実装

```rust
pub trait ReportFormatter {
    fn title(&self) -> &str;
    fn lines(&self) -> &[String];
    fn output_start(&self) -> String;
    fn output_line(&self, line: &str) -> String;
    fn output_end(&self) -> String;

    // テンプレートメソッド
    fn output_report(&self) -> String {
        let mut result = self.output_start();
        result.push_str(&format!("  {}\n", self.title()));
        for line in self.lines() {
            result.push_str(&self.output_line(line));
        }
        result.push_str(&self.output_end());
        result
    }
}

pub struct HtmlReport {
    title: String,
    lines: Vec<String>,
}

impl HtmlReport {
    pub fn new(title: &str, lines: Vec<String>) -> Self {
        Self {
            title: title.to_string(),
            lines,
        }
    }
}

impl ReportFormatter for HtmlReport {
    fn title(&self) -> &str { &self.title }
    fn lines(&self) -> &[String] { &self.lines }
    fn output_start(&self) -> String { "<html>\n".to_string() }
    fn output_line(&self, line: &str) -> String { format!("  <p>{}</p>\n", line) }
    fn output_end(&self) -> String { "</html>\n".to_string() }
}

pub struct PlainTextReport {
    title: String,
    lines: Vec<String>,
}

impl PlainTextReport {
    pub fn new(title: &str, lines: Vec<String>) -> Self {
        Self {
            title: title.to_string(),
            lines,
        }
    }
}

impl ReportFormatter for PlainTextReport {
    fn title(&self) -> &str { &self.title }
    fn lines(&self) -> &[String] { &self.lines }
    fn output_start(&self) -> String { String::new() }
    fn output_line(&self, line: &str) -> String { format!("{}\n", line) }
    fn output_end(&self) -> String { String::new() }
}
```

`output_report()` は共通の骨格を保持したまま、出力開始・各行の整形・出力終了だけを実装側に委ねます。

### Refactor

`output_report()` がテンプレートメソッドとして、抽象的なステップ（`output_start`, `output_line`, `output_end`）を呼び出す構造が明確です。

## 他言語比較

| 言語 | テンプレートメソッドの実現方法 |
|------|---------------------------|
| Java | 抽象クラス + 抽象メソッド |
| Python | ABC + `@abstractmethod` |
| Ruby | メソッド内で未定義メソッドを呼ぶ |
| **Rust** | **トレイト + デフォルト実装** |

Rust では「継承」が存在しないため、トレイトのデフォルト実装がテンプレートメソッドの自然な表現になります。

## まとめ

Template Method パターンは、Rust のトレイトのデフォルト実装と完璧にマッチします。アルゴリズムの骨格をデフォルト実装で定義し、変動するステップを必須メソッドとして宣言することで、型安全なテンプレートメソッドが実現できます。
