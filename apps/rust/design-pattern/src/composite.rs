/// Composite pattern
///
/// A Task can be either a Leaf (simple task) or a Composite
/// (containing sub-tasks). Both share a uniform interface.

#[derive(Debug, Clone)]
pub enum Task {
    Leaf {
        name: String,
        duration: f64,
    },
    Composite {
        name: String,
        children: Vec<Task>,
    },
}

impl Task {
    pub fn new_leaf(name: &str, duration: f64) -> Self {
        Task::Leaf {
            name: name.to_string(),
            duration,
        }
    }

    pub fn new_composite(name: &str, children: Vec<Task>) -> Self {
        Task::Composite {
            name: name.to_string(),
            children,
        }
    }

    pub fn name(&self) -> &str {
        match self {
            Task::Leaf { name, .. } => name,
            Task::Composite { name, .. } => name,
        }
    }

    pub fn get_time_required(&self) -> f64 {
        match self {
            Task::Leaf { duration, .. } => *duration,
            Task::Composite { children, .. } => {
                children.iter().map(|c| c.get_time_required()).sum()
            }
        }
    }

    pub fn total_basic_tasks(&self) -> usize {
        match self {
            Task::Leaf { .. } => 1,
            Task::Composite { children, .. } => {
                children.iter().map(|c| c.total_basic_tasks()).sum()
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn leaf_task_returns_its_duration() {
        let task = Task::new_leaf("Code review", 2.0);
        assert_eq!(task.get_time_required(), 2.0);
    }

    #[test]
    fn leaf_task_counts_as_one_basic_task() {
        let task = Task::new_leaf("Code review", 2.0);
        assert_eq!(task.total_basic_tasks(), 1);
    }

    #[test]
    fn composite_sums_durations() {
        let composite = Task::new_composite(
            "Sprint",
            vec![
                Task::new_leaf("Design", 3.0),
                Task::new_leaf("Implement", 5.0),
                Task::new_leaf("Test", 2.0),
            ],
        );
        assert_eq!(composite.get_time_required(), 10.0);
    }

    #[test]
    fn composite_counts_all_basic_tasks() {
        let composite = Task::new_composite(
            "Sprint",
            vec![
                Task::new_leaf("Design", 3.0),
                Task::new_leaf("Implement", 5.0),
            ],
        );
        assert_eq!(composite.total_basic_tasks(), 2);
    }

    #[test]
    fn nested_composite_works_recursively() {
        let inner = Task::new_composite(
            "Backend",
            vec![
                Task::new_leaf("API", 4.0),
                Task::new_leaf("DB", 3.0),
            ],
        );
        let outer = Task::new_composite(
            "Project",
            vec![
                inner,
                Task::new_leaf("Frontend", 6.0),
            ],
        );
        assert_eq!(outer.get_time_required(), 13.0);
        assert_eq!(outer.total_basic_tasks(), 3);
    }
}
