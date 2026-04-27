/// Observer pattern
///
/// Employee notifies registered observers when salary changes.
/// Observers are stored as boxed closures.

pub struct Employee {
    pub name: String,
    salary: i64,
    observers: Vec<Box<dyn FnMut(&str, i64)>>,
}

impl Employee {
    pub fn new(name: &str, salary: i64) -> Self {
        Self {
            name: name.to_string(),
            salary,
            observers: Vec::new(),
        }
    }

    pub fn salary(&self) -> i64 {
        self.salary
    }

    pub fn add_observer<F: FnMut(&str, i64) + 'static>(&mut self, observer: F) {
        self.observers.push(Box::new(observer));
    }

    pub fn set_salary(&mut self, new_salary: i64) {
        self.salary = new_salary;
        self.notify_observers();
    }

    fn notify_observers(&mut self) {
        let name = self.name.clone();
        let salary = self.salary;
        for observer in &mut self.observers {
            observer(&name, salary);
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::cell::RefCell;
    use std::rc::Rc;

    #[test]
    fn initial_salary() {
        let emp = Employee::new("Alice", 50_000);
        assert_eq!(emp.salary(), 50_000);
    }

    #[test]
    fn set_salary_updates_value() {
        let mut emp = Employee::new("Alice", 50_000);
        emp.set_salary(60_000);
        assert_eq!(emp.salary(), 60_000);
    }

    #[test]
    fn observer_is_notified_on_salary_change() {
        let log: Rc<RefCell<Vec<String>>> = Rc::new(RefCell::new(Vec::new()));
        let log_clone = Rc::clone(&log);

        let mut emp = Employee::new("Bob", 40_000);
        emp.add_observer(move |name, salary| {
            log_clone.borrow_mut().push(format!("{}: {}", name, salary));
        });

        emp.set_salary(45_000);
        emp.set_salary(50_000);

        let entries = log.borrow();
        assert_eq!(entries.len(), 2);
        assert_eq!(entries[0], "Bob: 45000");
        assert_eq!(entries[1], "Bob: 50000");
    }

    #[test]
    fn multiple_observers_all_notified() {
        let count1: Rc<RefCell<u32>> = Rc::new(RefCell::new(0));
        let count2: Rc<RefCell<u32>> = Rc::new(RefCell::new(0));
        let c1 = Rc::clone(&count1);
        let c2 = Rc::clone(&count2);

        let mut emp = Employee::new("Carol", 30_000);
        emp.add_observer(move |_, _| *c1.borrow_mut() += 1);
        emp.add_observer(move |_, _| *c2.borrow_mut() += 1);

        emp.set_salary(35_000);

        assert_eq!(*count1.borrow(), 1);
        assert_eq!(*count2.borrow(), 1);
    }
}
