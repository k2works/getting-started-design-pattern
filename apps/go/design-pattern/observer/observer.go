// Package observer demonstrates the Observer pattern in Go.
// Observers are callback functions stored in a slice.
package observer

import "fmt"

// Observer is a callback function that receives the employee after a change.
type Observer func(e *Employee)

// Employee is the subject that notifies observers when salary changes.
type Employee struct {
	Name      string
	Title     string
	Salary    float64
	observers []Observer
}

// NewEmployee creates a new Employee.
func NewEmployee(name, title string, salary float64) *Employee {
	return &Employee{
		Name:   name,
		Title:  title,
		Salary: salary,
	}
}

// AddObserver registers an observer.
func (e *Employee) AddObserver(o Observer) {
	e.observers = append(e.observers, o)
}

// RemoveObserver removes the last added observer.
func (e *Employee) RemoveObserver() {
	if len(e.observers) > 0 {
		e.observers = e.observers[:len(e.observers)-1]
	}
}

// SetSalary changes the salary and notifies all observers.
func (e *Employee) SetSalary(newSalary float64) {
	e.Salary = newSalary
	e.notifyObservers()
}

func (e *Employee) notifyObservers() {
	for _, o := range e.observers {
		o(e)
	}
}

// ObserverCount returns the number of registered observers.
func (e *Employee) ObserverCount() int {
	return len(e.observers)
}

// String returns a human-readable representation.
func (e *Employee) String() string {
	return fmt.Sprintf("%s (%s): %.0f", e.Name, e.Title, e.Salary)
}
