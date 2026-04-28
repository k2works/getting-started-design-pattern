//! Singleton pattern
//!
//! Uses std::sync::OnceLock to provide a globally shared Logger instance.

use std::sync::{Mutex, OnceLock};

pub struct Logger {
    messages: Mutex<Vec<String>>,
}

impl Logger {
    fn new() -> Self {
        Self {
            messages: Mutex::new(Vec::new()),
        }
    }

    pub fn log(&self, message: &str) {
        self.messages
            .lock()
            .expect("Logger mutex poisoned")
            .push(message.to_string());
    }

    pub fn messages(&self) -> Vec<String> {
        self.messages
            .lock()
            .expect("Logger mutex poisoned")
            .clone()
    }

    pub fn clear(&self) {
        self.messages
            .lock()
            .expect("Logger mutex poisoned")
            .clear();
    }
}

static INSTANCE: OnceLock<Logger> = OnceLock::new();

pub fn get_instance() -> &'static Logger {
    INSTANCE.get_or_init(Logger::new)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn singleton_returns_same_instance() {
        let logger1 = get_instance();
        let logger2 = get_instance();
        assert!(std::ptr::eq(logger1, logger2));
    }

    #[test]
    fn logger_stores_messages() {
        let logger = get_instance();
        logger.clear();
        logger.log("test message");
        let msgs = logger.messages();
        assert!(msgs.contains(&"test message".to_string()));
    }

    #[test]
    fn logger_clear_removes_all_messages() {
        let logger = get_instance();
        logger.log("to be cleared");
        logger.clear();
        assert!(logger.messages().is_empty());
    }
}
