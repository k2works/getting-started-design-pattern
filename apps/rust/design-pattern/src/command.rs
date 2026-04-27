/// Command pattern
///
/// Encapsulates operations as objects that can be executed and undone.
/// Uses the filesystem for create/delete demonstrations in tests.

use std::fs;
use std::path::{Path, PathBuf};

pub trait Command {
    fn execute(&mut self);
    fn undo(&mut self);
    fn description(&self) -> String;
}

pub struct CreateFileCommand {
    path: PathBuf,
    content: String,
}

impl CreateFileCommand {
    pub fn new(path: &Path, content: &str) -> Self {
        Self {
            path: path.to_path_buf(),
            content: content.to_string(),
        }
    }
}

impl Command for CreateFileCommand {
    fn execute(&mut self) {
        fs::write(&self.path, &self.content).expect("Failed to create file");
    }

    fn undo(&mut self) {
        if self.path.exists() {
            fs::remove_file(&self.path).expect("Failed to remove file");
        }
    }

    fn description(&self) -> String {
        format!("Create file: {}", self.path.display())
    }
}

pub struct DeleteFileCommand {
    path: PathBuf,
    backup: Option<String>,
}

impl DeleteFileCommand {
    pub fn new(path: &Path) -> Self {
        Self {
            path: path.to_path_buf(),
            backup: None,
        }
    }
}

impl Command for DeleteFileCommand {
    fn execute(&mut self) {
        if self.path.exists() {
            self.backup = Some(fs::read_to_string(&self.path).expect("Failed to read file"));
            fs::remove_file(&self.path).expect("Failed to delete file");
        }
    }

    fn undo(&mut self) {
        if let Some(ref content) = self.backup {
            fs::write(&self.path, content).expect("Failed to restore file");
        }
    }

    fn description(&self) -> String {
        format!("Delete file: {}", self.path.display())
    }
}

pub struct CompositeCommand {
    commands: Vec<Box<dyn Command>>,
    description: String,
}

impl CompositeCommand {
    pub fn new(description: &str) -> Self {
        Self {
            commands: Vec::new(),
            description: description.to_string(),
        }
    }

    pub fn add(&mut self, command: Box<dyn Command>) {
        self.commands.push(command);
    }
}

impl Command for CompositeCommand {
    fn execute(&mut self) {
        for cmd in &mut self.commands {
            cmd.execute();
        }
    }

    fn undo(&mut self) {
        for cmd in self.commands.iter_mut().rev() {
            cmd.undo();
        }
    }

    fn description(&self) -> String {
        self.description.clone()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::env;

    fn temp_path(name: &str) -> PathBuf {
        env::temp_dir().join(format!("dp_cmd_test_{}", name))
    }

    #[test]
    fn create_file_command_creates_and_undoes() {
        let path = temp_path("create_test.txt");
        let mut cmd = CreateFileCommand::new(&path, "hello");

        cmd.execute();
        assert!(path.exists());
        assert_eq!(fs::read_to_string(&path).unwrap(), "hello");

        cmd.undo();
        assert!(!path.exists());
    }

    #[test]
    fn delete_file_command_deletes_and_restores() {
        let path = temp_path("delete_test.txt");
        fs::write(&path, "original content").unwrap();

        let mut cmd = DeleteFileCommand::new(&path);
        cmd.execute();
        assert!(!path.exists());

        cmd.undo();
        assert!(path.exists());
        assert_eq!(fs::read_to_string(&path).unwrap(), "original content");

        // cleanup
        fs::remove_file(&path).ok();
    }

    #[test]
    fn composite_command_executes_all() {
        let path1 = temp_path("comp1.txt");
        let path2 = temp_path("comp2.txt");

        let mut composite = CompositeCommand::new("Create two files");
        composite.add(Box::new(CreateFileCommand::new(&path1, "file1")));
        composite.add(Box::new(CreateFileCommand::new(&path2, "file2")));

        composite.execute();
        assert!(path1.exists());
        assert!(path2.exists());

        composite.undo();
        assert!(!path1.exists());
        assert!(!path2.exists());
    }

    #[test]
    fn command_description() {
        let path = temp_path("desc.txt");
        let cmd = CreateFileCommand::new(&path, "test");
        assert!(cmd.description().contains("Create file"));
    }

    #[test]
    fn composite_command_description() {
        let composite = CompositeCommand::new("Batch operation");
        assert_eq!(composite.description(), "Batch operation");
    }
}
