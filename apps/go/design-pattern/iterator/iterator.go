// Package iterator demonstrates the Iterator pattern in Go.
// Go's range-based iteration and methods on slices make this pattern
// straightforward without a separate iterator object.
package iterator

import "fmt"

// Account represents a bank account.
type Account struct {
	Name    string
	Balance float64
}

// String returns a human-readable representation.
func (a Account) String() string {
	return fmt.Sprintf("%s: %.0f", a.Name, a.Balance)
}

// Portfolio holds a collection of accounts.
type Portfolio struct {
	Accounts []Account
}

// NewPortfolio creates a new empty portfolio.
func NewPortfolio() *Portfolio {
	return &Portfolio{}
}

// Add appends an account to the portfolio.
func (p *Portfolio) Add(account Account) {
	p.Accounts = append(p.Accounts, account)
}

// TotalBalance returns the sum of all account balances.
func (p *Portfolio) TotalBalance() float64 {
	total := 0.0
	for _, a := range p.Accounts {
		total += a.Balance
	}
	return total
}

// Count returns the number of accounts.
func (p *Portfolio) Count() int {
	return len(p.Accounts)
}

// Any returns true if any account satisfies the predicate.
func (p *Portfolio) Any(pred func(Account) bool) bool {
	for _, a := range p.Accounts {
		if pred(a) {
			return true
		}
	}
	return false
}

// All returns true if all accounts satisfy the predicate.
func (p *Portfolio) All(pred func(Account) bool) bool {
	for _, a := range p.Accounts {
		if !pred(a) {
			return false
		}
	}
	return true
}

// Filter returns a new portfolio with accounts matching the predicate.
func (p *Portfolio) Filter(pred func(Account) bool) *Portfolio {
	result := NewPortfolio()
	for _, a := range p.Accounts {
		if pred(a) {
			result.Add(a)
		}
	}
	return result
}
