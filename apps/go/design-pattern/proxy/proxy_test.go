package proxy

import "testing"

func TestRealBankAccountDeposit(t *testing.T) {
	account := NewRealBankAccount(1000)
	if err := account.Deposit(500); err != nil {
		t.Fatalf("Deposit 失敗: %v", err)
	}
	if account.Balance() != 1500 {
		t.Errorf("期待値 1500, 実際 %d", account.Balance())
	}
}

func TestRealBankAccountWithdraw(t *testing.T) {
	account := NewRealBankAccount(1000)
	if err := account.Withdraw(300); err != nil {
		t.Fatalf("Withdraw 失敗: %v", err)
	}
	if account.Balance() != 700 {
		t.Errorf("期待値 700, 実際 %d", account.Balance())
	}
}

func TestRealBankAccountInsufficientFunds(t *testing.T) {
	account := NewRealBankAccount(100)
	err := account.Withdraw(200)
	if err == nil {
		t.Error("残高不足でエラーが返るべき")
	}
}

func TestProtectionProxyAllowsOwner(t *testing.T) {
	account := NewRealBankAccount(1000)
	proxy := NewProtectionProxy(account, "田中")

	if err := proxy.WithdrawAs("田中", 500); err != nil {
		t.Fatalf("所有者の出金が拒否された: %v", err)
	}
	if proxy.Balance() != 500 {
		t.Errorf("期待値 500, 実際 %d", proxy.Balance())
	}
}

func TestProtectionProxyBlocksNonOwner(t *testing.T) {
	account := NewRealBankAccount(1000)
	proxy := NewProtectionProxy(account, "田中")

	err := proxy.WithdrawAs("佐藤", 500)
	if err == nil {
		t.Error("非所有者の出金でエラーが返るべき")
	}
	if proxy.Balance() != 1000 {
		t.Errorf("残高が変わっていないべき: %d", proxy.Balance())
	}
}

func TestVirtualProxyDelaysCreation(t *testing.T) {
	vp := NewVirtualProxy(1000)
	if vp.IsInitialized() {
		t.Error("使用前に初期化されるべきではない")
	}
}

func TestVirtualProxyInitializesOnUse(t *testing.T) {
	vp := NewVirtualProxy(1000)
	_ = vp.Balance()
	if !vp.IsInitialized() {
		t.Error("使用後に初期化されるべき")
	}
}

func TestVirtualProxyDeposit(t *testing.T) {
	vp := NewVirtualProxy(1000)
	if err := vp.Deposit(500); err != nil {
		t.Fatalf("Deposit 失敗: %v", err)
	}
	if vp.Balance() != 1500 {
		t.Errorf("期待値 1500, 実際 %d", vp.Balance())
	}
}

func TestBankAccountInterface(t *testing.T) {
	// Compile-time interface satisfaction checks
	var _ BankAccount = &RealBankAccount{}
	var _ BankAccount = &ProtectionProxy{}
	var _ BankAccount = &VirtualProxy{}
}
