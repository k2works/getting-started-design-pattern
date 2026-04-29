// Package proxy demonstrates the Proxy pattern in Go.
// We use interfaces and struct wrapping for protection and virtual proxies.
package proxy

import (
	"errors"
	"fmt"
)

// BankAccount is the subject interface.
type BankAccount interface {
	Deposit(amount int) error
	Withdraw(amount int) error
	Balance() int
}

// RealBankAccount is the real subject.
type RealBankAccount struct {
	balance int
}

// NewRealBankAccount creates a bank account with the given initial balance.
func NewRealBankAccount(balance int) *RealBankAccount {
	return &RealBankAccount{balance: balance}
}

func (r *RealBankAccount) Deposit(amount int) error {
	if amount <= 0 {
		return errors.New("入金額は正の数である必要があります")
	}
	r.balance += amount
	return nil
}

func (r *RealBankAccount) Withdraw(amount int) error {
	if amount <= 0 {
		return errors.New("出金額は正の数である必要があります")
	}
	if amount > r.balance {
		return errors.New("残高不足")
	}
	r.balance -= amount
	return nil
}

func (r *RealBankAccount) Balance() int {
	return r.balance
}

// ProtectionProxy controls access to a BankAccount based on an owner.
type ProtectionProxy struct {
	account BankAccount
	owner   string
}

// NewProtectionProxy creates a protection proxy.
func NewProtectionProxy(account BankAccount, owner string) *ProtectionProxy {
	return &ProtectionProxy{account: account, owner: owner}
}

func (p *ProtectionProxy) Deposit(amount int) error {
	return p.account.Deposit(amount)
}

func (p *ProtectionProxy) Withdraw(amount int) error {
	return p.account.Withdraw(amount)
}

func (p *ProtectionProxy) Balance() int {
	return p.account.Balance()
}

// WithdrawAs attempts withdrawal with authorization check.
func (p *ProtectionProxy) WithdrawAs(user string, amount int) error {
	if user != p.owner {
		return fmt.Errorf("アクセス拒否: %s は口座所有者ではありません", user)
	}
	return p.account.Withdraw(amount)
}

// VirtualProxy delays creation of the real account until first use.
type VirtualProxy struct {
	balance int
	account *RealBankAccount
}

// NewVirtualProxy creates a virtual proxy with the given initial balance.
func NewVirtualProxy(balance int) *VirtualProxy {
	return &VirtualProxy{balance: balance}
}

func (v *VirtualProxy) ensureAccount() {
	if v.account == nil {
		v.account = NewRealBankAccount(v.balance)
	}
}

func (v *VirtualProxy) Deposit(amount int) error {
	v.ensureAccount()
	return v.account.Deposit(amount)
}

func (v *VirtualProxy) Withdraw(amount int) error {
	v.ensureAccount()
	return v.account.Withdraw(amount)
}

func (v *VirtualProxy) Balance() int {
	v.ensureAccount()
	return v.account.Balance()
}

// IsInitialized returns true if the real account has been created.
func (v *VirtualProxy) IsInitialized() bool {
	return v.account != nil
}
