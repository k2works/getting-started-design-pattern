//! Decorator pattern
//!
//! Wraps a Writer to add numbering or timestamps to each line.

pub trait Writer {
    fn write_line(&mut self, line: &str);
    fn output(&self) -> String;
}

pub struct SimpleWriter {
    lines: Vec<String>,
}

impl SimpleWriter {
    pub fn new() -> Self {
        Self { lines: Vec::new() }
    }
}

impl Default for SimpleWriter {
    fn default() -> Self {
        Self::new()
    }
}

impl Writer for SimpleWriter {
    fn write_line(&mut self, line: &str) {
        self.lines.push(line.to_string());
    }

    fn output(&self) -> String {
        self.lines.join("\n")
    }
}

pub struct NumberingWriter {
    inner: Box<dyn Writer>,
    line_number: usize,
}

impl NumberingWriter {
    pub fn new(inner: Box<dyn Writer>) -> Self {
        Self {
            inner,
            line_number: 0,
        }
    }
}

impl Writer for NumberingWriter {
    fn write_line(&mut self, line: &str) {
        self.line_number += 1;
        let numbered = format!("{}: {}", self.line_number, line);
        self.inner.write_line(&numbered);
    }

    fn output(&self) -> String {
        self.inner.output()
    }
}

pub struct TimeStampingWriter {
    inner: Box<dyn Writer>,
    timestamp: String,
}

impl TimeStampingWriter {
    pub fn new(inner: Box<dyn Writer>, timestamp: &str) -> Self {
        Self {
            inner,
            timestamp: timestamp.to_string(),
        }
    }
}

impl Writer for TimeStampingWriter {
    fn write_line(&mut self, line: &str) {
        let stamped = format!("[{}] {}", self.timestamp, line);
        self.inner.write_line(&stamped);
    }

    fn output(&self) -> String {
        self.inner.output()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn simple_writer_stores_lines() {
        let mut w = SimpleWriter::new();
        w.write_line("hello");
        w.write_line("world");
        assert_eq!(w.output(), "hello\nworld");
    }

    #[test]
    fn numbering_writer_adds_line_numbers() {
        let mut w = NumberingWriter::new(Box::new(SimpleWriter::new()));
        w.write_line("first");
        w.write_line("second");
        assert_eq!(w.output(), "1: first\n2: second");
    }

    #[test]
    fn timestamping_writer_adds_timestamps() {
        let mut w = TimeStampingWriter::new(
            Box::new(SimpleWriter::new()),
            "2026-01-01",
        );
        w.write_line("entry");
        assert_eq!(w.output(), "[2026-01-01] entry");
    }

    #[test]
    fn decorators_can_be_stacked() {
        let simple = Box::new(SimpleWriter::new());
        let numbered = Box::new(NumberingWriter::new(simple));
        let mut stamped = TimeStampingWriter::new(numbered, "09:00");

        stamped.write_line("hello");
        stamped.write_line("world");
        assert_eq!(stamped.output(), "1: [09:00] hello\n2: [09:00] world");
    }

    #[test]
    fn reverse_stacking_order() {
        let simple = Box::new(SimpleWriter::new());
        let stamped = Box::new(TimeStampingWriter::new(simple, "10:00"));
        let mut numbered = NumberingWriter::new(stamped);

        numbered.write_line("alpha");
        assert_eq!(numbered.output(), "[10:00] 1: alpha");
    }
}
