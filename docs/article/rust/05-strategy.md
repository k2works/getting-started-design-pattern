# 第 5 章：Strategy

## はじめに

Strategy パターンは、アルゴリズムをカプセル化し、実行時に差し替え可能にするパターンです。Rust ではクロージャと `Box<dyn Fn>` で軽量に実現できます。

## パターンの構造

```plantuml
@startuml
class Report {
  +title: String
  +lines: Vec<String>
  +formatter: Box<dyn Fn>
  +output_report(): String
  +set_formatter(formatter)
}

class Formatters <<module>> {
  +html_formatter(): Box<dyn Fn>
  +plain_text_formatter(): Box<dyn Fn>
}

Report --> Formatters : uses
@enduml
```

## TDD で作る

### Red

```rust
#[test]
fn can_swap_formatter_at_runtime() {
    let mut report = Report::new("Test", sample_lines(), html_formatter());
    assert!(report.output_report().contains("<html>"));

    report.set_formatter(plain_text_formatter());
    assert!(!report.output_report().contains("<html>"));
}
```

### Green

```rust
pub struct Report {
    pub title: String,
    pub lines: Vec<String>,
    pub formatter: Box<dyn Fn(&str, &[String]) -> String>,
}

impl Report {
    pub fn new(
        title: &str,
        lines: Vec<String>,
        formatter: Box<dyn Fn(&str, &[String]) -> String>,
    ) -> Self {
        Self {
            title: title.to_string(),
            lines,
            formatter,
        }
    }

    pub fn set_formatter(
        &mut self,
        formatter: Box<dyn Fn(&str, &[String]) -> String>,
    ) {
        self.formatter = formatter;
    }

    pub fn output_report(&self) -> String {
        (self.formatter)(&self.title, &self.lines)
    }
}

pub fn html_formatter() -> Box<dyn Fn(&str, &[String]) -> String> {
    Box::new(|title, lines| {
        let body = lines
            .iter()
            .map(|line| format!("  <p>{}</p>", line))
            .collect::<Vec<_>>()
            .join("\n");
        format!("<html>\n  <h1>{}</h1>\n{}\n</html>", title, body)
    })
}

pub fn plain_text_formatter() -> Box<dyn Fn(&str, &[String]) -> String> {
    Box::new(|title, lines| format!("{}\n{}", title, lines.join("\n")))
}
```

`Report` は戦略を保持するだけで、整形ロジック自体はクロージャに完全に委譲します。

### Refactor

クロージャを使うことで、Strategy インターフェースのためだけにトレイトを定義する必要がなくなります。

## 他言語比較

| 言語 | Strategy の実現方法 |
|------|-------------------|
| Java | `interface` + 実装クラス |
| Python | 関数をオブジェクトとして渡す |
| Ruby | ブロック / Proc |
| **Rust** | **クロージャ + `Box<dyn Fn>`** |

## まとめ

Rust のクロージャは Strategy パターンの最も自然な表現です。`Box<dyn Fn>` でヒープに配置すれば、実行時の差し替えも容易です。トレイトベースのアプローチも可能ですが、単純なアルゴリズム切り替えにはクロージャが最適です。
