/// Builder pattern
///
/// ComputerBuilder constructs a Computer step by step with method chaining.
/// build() validates and returns Result<Computer, String>.

#[derive(Debug, Clone, PartialEq)]
pub struct Drive {
    pub drive_type: String,
    pub size_gb: u64,
}

impl Drive {
    pub fn new(drive_type: &str, size_gb: u64) -> Self {
        Self {
            drive_type: drive_type.to_string(),
            size_gb,
        }
    }
}

#[derive(Debug, Clone, PartialEq)]
pub struct Motherboard {
    pub model: String,
    pub cpu: String,
    pub memory_gb: u64,
}

impl Motherboard {
    pub fn new(model: &str, cpu: &str, memory_gb: u64) -> Self {
        Self {
            model: model.to_string(),
            cpu: cpu.to_string(),
            memory_gb,
        }
    }
}

#[derive(Debug, Clone)]
pub struct Computer {
    pub display: String,
    pub motherboard: Motherboard,
    pub drives: Vec<Drive>,
}

pub struct ComputerBuilder {
    display: Option<String>,
    motherboard: Option<Motherboard>,
    drives: Vec<Drive>,
}

impl ComputerBuilder {
    pub fn new() -> Self {
        Self {
            display: None,
            motherboard: None,
            drives: Vec::new(),
        }
    }

    pub fn display(mut self, display: &str) -> Self {
        self.display = Some(display.to_string());
        self
    }

    pub fn motherboard(mut self, model: &str, cpu: &str, memory_gb: u64) -> Self {
        self.motherboard = Some(Motherboard::new(model, cpu, memory_gb));
        self
    }

    pub fn add_drive(mut self, drive_type: &str, size_gb: u64) -> Self {
        self.drives.push(Drive::new(drive_type, size_gb));
        self
    }

    pub fn build(self) -> Result<Computer, String> {
        let display = self
            .display
            .ok_or_else(|| "Display is required".to_string())?;
        let motherboard = self
            .motherboard
            .ok_or_else(|| "Motherboard is required".to_string())?;

        Ok(Computer {
            display,
            motherboard,
            drives: self.drives,
        })
    }
}

impl Default for ComputerBuilder {
    fn default() -> Self {
        Self::new()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn build_complete_computer() {
        let computer = ComputerBuilder::new()
            .display("27 inch")
            .motherboard("ASUS ROG", "i9-13900K", 64)
            .add_drive("SSD", 1000)
            .build()
            .unwrap();

        assert_eq!(computer.display, "27 inch");
        assert_eq!(computer.motherboard.cpu, "i9-13900K");
        assert_eq!(computer.drives.len(), 1);
    }

    #[test]
    fn build_fails_without_display() {
        let result = ComputerBuilder::new()
            .motherboard("Basic", "i5", 16)
            .build();

        assert!(result.is_err());
        assert_eq!(result.unwrap_err(), "Display is required");
    }

    #[test]
    fn build_fails_without_motherboard() {
        let result = ComputerBuilder::new()
            .display("24 inch")
            .build();

        assert!(result.is_err());
        assert_eq!(result.unwrap_err(), "Motherboard is required");
    }

    #[test]
    fn multiple_drives() {
        let computer = ComputerBuilder::new()
            .display("32 inch")
            .motherboard("Gigabyte", "Ryzen 9", 128)
            .add_drive("SSD", 500)
            .add_drive("HDD", 2000)
            .build()
            .unwrap();

        assert_eq!(computer.drives.len(), 2);
        assert_eq!(computer.drives[0].drive_type, "SSD");
        assert_eq!(computer.drives[1].size_gb, 2000);
    }

    #[test]
    fn computer_without_drives_is_valid() {
        let computer = ComputerBuilder::new()
            .display("15 inch")
            .motherboard("MSI", "i7", 32)
            .build()
            .unwrap();

        assert!(computer.drives.is_empty());
    }
}
