/// Template Method pattern
///
/// Defines the skeleton of an algorithm in a trait method,
/// deferring some steps to implementors.

pub trait ReportFormatter {
    fn title(&self) -> &str;
    fn lines(&self) -> &[String];

    fn output_start(&self) -> String;
    fn output_line(&self, line: &str) -> String;
    fn output_end(&self) -> String;

    /// Template method: calls the abstract steps in order.
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
    pub title: String,
    pub lines: Vec<String>,
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
    fn title(&self) -> &str {
        &self.title
    }

    fn lines(&self) -> &[String] {
        &self.lines
    }

    fn output_start(&self) -> String {
        "<html>\n<body>\n".to_string()
    }

    fn output_line(&self, line: &str) -> String {
        format!("  <p>{}</p>\n", line)
    }

    fn output_end(&self) -> String {
        "</body>\n</html>\n".to_string()
    }
}

pub struct PlainTextReport {
    pub title: String,
    pub lines: Vec<String>,
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
    fn title(&self) -> &str {
        &self.title
    }

    fn lines(&self) -> &[String] {
        &self.lines
    }

    fn output_start(&self) -> String {
        "=====\n".to_string()
    }

    fn output_line(&self, line: &str) -> String {
        format!("  {}\n", line)
    }

    fn output_end(&self) -> String {
        "=====\n".to_string()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn sample_lines() -> Vec<String> {
        vec![
            "Line one".to_string(),
            "Line two".to_string(),
        ]
    }

    #[test]
    fn html_report_contains_html_tags() {
        let report = HtmlReport::new("Monthly Report", sample_lines());
        let output = report.output_report();
        assert!(output.contains("<html>"));
        assert!(output.contains("</html>"));
    }

    #[test]
    fn html_report_wraps_lines_in_p_tags() {
        let report = HtmlReport::new("Monthly Report", sample_lines());
        let output = report.output_report();
        assert!(output.contains("<p>Line one</p>"));
        assert!(output.contains("<p>Line two</p>"));
    }

    #[test]
    fn plain_text_report_uses_separator() {
        let report = PlainTextReport::new("Monthly Report", sample_lines());
        let output = report.output_report();
        assert!(output.starts_with("=====\n"));
        assert!(output.ends_with("=====\n"));
    }

    #[test]
    fn plain_text_report_includes_title_and_lines() {
        let report = PlainTextReport::new("Monthly Report", sample_lines());
        let output = report.output_report();
        assert!(output.contains("Monthly Report"));
        assert!(output.contains("Line one"));
        assert!(output.contains("Line two"));
    }
}
