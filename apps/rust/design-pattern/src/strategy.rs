//! Strategy pattern
//!
//! Encapsulates formatting algorithms as closures,
//! allowing them to be swapped at runtime.

/// Type alias for the formatter closure.
pub type Formatter = Box<dyn Fn(&str, &[String]) -> String>;

pub struct Report {
    pub title: String,
    pub lines: Vec<String>,
    pub formatter: Formatter,
}

impl Report {
    pub fn new(
        title: &str,
        lines: Vec<String>,
        formatter: Formatter,
    ) -> Self {
        Self {
            title: title.to_string(),
            lines,
            formatter,
        }
    }

    pub fn output_report(&self) -> String {
        (self.formatter)(&self.title, &self.lines)
    }

    pub fn set_formatter(&mut self, formatter: Formatter) {
        self.formatter = formatter;
    }
}

pub fn html_formatter() -> Formatter {
    Box::new(|title, lines| {
        let mut result = String::from("<html>\n<body>\n");
        result.push_str(&format!("  <h1>{}</h1>\n", title));
        for line in lines {
            result.push_str(&format!("  <p>{}</p>\n", line));
        }
        result.push_str("</body>\n</html>\n");
        result
    })
}

pub fn plain_text_formatter() -> Formatter {
    Box::new(|title, lines| {
        let mut result = format!("=== {} ===\n", title);
        for line in lines {
            result.push_str(&format!("  {}\n", line));
        }
        result
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    fn sample_lines() -> Vec<String> {
        vec!["First line".to_string(), "Second line".to_string()]
    }

    #[test]
    fn html_formatter_produces_html() {
        let report = Report::new("Test", sample_lines(), html_formatter());
        let output = report.output_report();
        assert!(output.contains("<html>"));
        assert!(output.contains("<p>First line</p>"));
    }

    #[test]
    fn plain_text_formatter_produces_text() {
        let report = Report::new("Test", sample_lines(), plain_text_formatter());
        let output = report.output_report();
        assert!(output.contains("=== Test ==="));
        assert!(output.contains("First line"));
    }

    #[test]
    fn can_swap_formatter_at_runtime() {
        let mut report = Report::new("Test", sample_lines(), html_formatter());
        assert!(report.output_report().contains("<html>"));

        report.set_formatter(plain_text_formatter());
        let output = report.output_report();
        assert!(!output.contains("<html>"));
        assert!(output.contains("=== Test ==="));
    }

    #[test]
    fn custom_closure_as_strategy() {
        let custom = Box::new(|title: &str, lines: &[String]| {
            format!("[{}] {} items", title, lines.len())
        });
        let report = Report::new("Custom", sample_lines(), custom);
        assert_eq!(report.output_report(), "[Custom] 2 items");
    }
}
