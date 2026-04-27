package observer

import "testing"

func TestSetSalaryNotifiesObserver(t *testing.T) {
	emp := NewEmployee("田中", "エンジニア", 500000)
	var notified bool
	emp.AddObserver(func(e *Employee) {
		notified = true
	})

	emp.SetSalary(600000)

	if !notified {
		t.Error("Observer が通知されなかった")
	}
}

func TestObserverReceivesUpdatedSalary(t *testing.T) {
	emp := NewEmployee("田中", "エンジニア", 500000)
	var received float64
	emp.AddObserver(func(e *Employee) {
		received = e.Salary
	})

	emp.SetSalary(600000)

	if received != 600000 {
		t.Errorf("期待値 600000, 実際 %f", received)
	}
}

func TestMultipleObservers(t *testing.T) {
	emp := NewEmployee("田中", "エンジニア", 500000)
	count := 0
	emp.AddObserver(func(e *Employee) { count++ })
	emp.AddObserver(func(e *Employee) { count++ })

	emp.SetSalary(600000)

	if count != 2 {
		t.Errorf("2 つの Observer が通知されるべき、実際 %d", count)
	}
}

func TestRemoveObserver(t *testing.T) {
	emp := NewEmployee("田中", "エンジニア", 500000)
	count := 0
	emp.AddObserver(func(e *Employee) { count++ })
	emp.AddObserver(func(e *Employee) { count++ })
	emp.RemoveObserver()

	emp.SetSalary(600000)

	if count != 1 {
		t.Errorf("1 つの Observer だけ通知されるべき、実際 %d", count)
	}
}

func TestObserverCount(t *testing.T) {
	emp := NewEmployee("田中", "エンジニア", 500000)
	emp.AddObserver(func(e *Employee) {})
	emp.AddObserver(func(e *Employee) {})

	if emp.ObserverCount() != 2 {
		t.Errorf("期待値 2, 実際 %d", emp.ObserverCount())
	}
}

func TestNoObserversDoesNotPanic(t *testing.T) {
	emp := NewEmployee("田中", "エンジニア", 500000)
	emp.SetSalary(600000) // should not panic

	if emp.Salary != 600000 {
		t.Errorf("期待値 600000, 実際 %f", emp.Salary)
	}
}

func TestString(t *testing.T) {
	emp := NewEmployee("田中", "エンジニア", 500000)
	expected := "田中 (エンジニア): 500000"
	if emp.String() != expected {
		t.Errorf("期待値 %q, 実際 %q", expected, emp.String())
	}
}
