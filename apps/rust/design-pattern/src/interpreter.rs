//! Interpreter pattern
//!
//! A mini DSL for searching files in a directory.
//! Expression trees are built and evaluated against a filesystem path.

use std::fs;
use std::path::Path;

#[derive(Debug, Clone)]
pub enum Expression {
    All,
    FileName(String),
    Bigger(u64),
    And(Box<Expression>, Box<Expression>),
    Or(Box<Expression>, Box<Expression>),
    Not(Box<Expression>),
}

impl Expression {
    pub fn and(self, other: Expression) -> Expression {
        Expression::And(Box::new(self), Box::new(other))
    }

    pub fn or(self, other: Expression) -> Expression {
        Expression::Or(Box::new(self), Box::new(other))
    }

    #[allow(clippy::should_implement_trait)]
    pub fn not(self) -> Expression {
        Expression::Not(Box::new(self))
    }
}

pub fn evaluate(expr: &Expression, dir: &Path) -> Vec<String> {
    let entries = match fs::read_dir(dir) {
        Ok(entries) => entries,
        Err(_) => return Vec::new(),
    };

    let mut results = Vec::new();

    for entry in entries.flatten() {
        let path = entry.path();
        if path.is_file() && matches_expr(expr, &path)
            && let Some(name) = path.file_name() {
                results.push(name.to_string_lossy().to_string());
            }
    }

    results.sort();
    results
}

fn matches_expr(expr: &Expression, path: &Path) -> bool {
    match expr {
        Expression::All => true,
        Expression::FileName(pattern) => {
            path.file_name()
                .map(|n| n.to_string_lossy().contains(pattern.as_str()))
                .unwrap_or(false)
        }
        Expression::Bigger(size) => {
            fs::metadata(path)
                .map(|m| m.len() > *size)
                .unwrap_or(false)
        }
        Expression::And(left, right) => {
            matches_expr(left, path) && matches_expr(right, path)
        }
        Expression::Or(left, right) => {
            matches_expr(left, path) || matches_expr(right, path)
        }
        Expression::Not(inner) => !matches_expr(inner, path),
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;

    fn setup_temp_dir() -> tempfile::TempDir {
        let dir = tempfile::tempdir().expect("Failed to create temp dir");
        fs::write(dir.path().join("small.txt"), "hi").unwrap();
        fs::write(dir.path().join("big.txt"), "a".repeat(200)).unwrap();
        fs::write(dir.path().join("notes.md"), "some notes").unwrap();
        fs::write(dir.path().join("data.txt"), "a".repeat(100)).unwrap();
        dir
    }

    #[test]
    fn all_matches_everything() {
        let dir = setup_temp_dir();
        let results = evaluate(&Expression::All, dir.path());
        assert_eq!(results.len(), 4);
    }

    #[test]
    fn filename_filters_by_name() {
        let dir = setup_temp_dir();
        let expr = Expression::FileName("notes".to_string());
        let results = evaluate(&expr, dir.path());
        assert_eq!(results, vec!["notes.md"]);
    }

    #[test]
    fn bigger_filters_by_size() {
        let dir = setup_temp_dir();
        let expr = Expression::Bigger(150);
        let results = evaluate(&expr, dir.path());
        assert_eq!(results, vec!["big.txt"]);
    }

    #[test]
    fn and_combines_two_expressions() {
        let dir = setup_temp_dir();
        let expr = Expression::FileName(".txt".to_string())
            .and(Expression::Bigger(50));
        let results = evaluate(&expr, dir.path());
        assert_eq!(results, vec!["big.txt", "data.txt"]);
    }

    #[test]
    fn not_inverts_expression() {
        let dir = setup_temp_dir();
        let expr = Expression::FileName(".txt".to_string()).not();
        let results = evaluate(&expr, dir.path());
        assert_eq!(results, vec!["notes.md"]);
    }

    #[test]
    fn or_matches_either_expression() {
        let dir = setup_temp_dir();
        let expr = Expression::FileName("small".to_string())
            .or(Expression::FileName("notes".to_string()));
        let results = evaluate(&expr, dir.path());
        assert_eq!(results, vec!["notes.md", "small.txt"]);
    }
}
