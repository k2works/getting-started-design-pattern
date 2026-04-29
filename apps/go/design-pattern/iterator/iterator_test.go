package iterator

import "testing"

func newSamplePortfolio() *Portfolio {
	p := NewPortfolio()
	p.Add(Account{Name: "普通預金", Balance: 100000})
	p.Add(Account{Name: "定期預金", Balance: 500000})
	p.Add(Account{Name: "投資信託", Balance: 300000})
	return p
}

func TestTotalBalance(t *testing.T) {
	p := newSamplePortfolio()
	expected := 900000.0
	if p.TotalBalance() != expected {
		t.Errorf("期待値 %f, 実際 %f", expected, p.TotalBalance())
	}
}

func TestCount(t *testing.T) {
	p := newSamplePortfolio()
	if p.Count() != 3 {
		t.Errorf("期待値 3, 実際 %d", p.Count())
	}
}

func TestAny(t *testing.T) {
	p := newSamplePortfolio()
	hasLargeBalance := p.Any(func(a Account) bool {
		return a.Balance >= 500000
	})
	if !hasLargeBalance {
		t.Error("50 万以上の口座が存在するはず")
	}
}

func TestAnyFalse(t *testing.T) {
	p := newSamplePortfolio()
	hasMillion := p.Any(func(a Account) bool {
		return a.Balance >= 1000000
	})
	if hasMillion {
		t.Error("100 万以上の口座は存在しないはず")
	}
}

func TestAll(t *testing.T) {
	p := newSamplePortfolio()
	allPositive := p.All(func(a Account) bool {
		return a.Balance > 0
	})
	if !allPositive {
		t.Error("すべての口座が正の残高を持つはず")
	}
}

func TestFilter(t *testing.T) {
	p := newSamplePortfolio()
	large := p.Filter(func(a Account) bool {
		return a.Balance >= 300000
	})
	if large.Count() != 2 {
		t.Errorf("期待値 2, 実際 %d", large.Count())
	}
}

func TestEmptyPortfolio(t *testing.T) {
	p := NewPortfolio()
	if p.TotalBalance() != 0 {
		t.Error("空のポートフォリオの合計は 0 であるべき")
	}
	if p.Count() != 0 {
		t.Error("空のポートフォリオの件数は 0 であるべき")
	}
}

func TestAccountString(t *testing.T) {
	a := Account{Name: "普通預金", Balance: 100000}
	expected := "普通預金: 100000"
	if a.String() != expected {
		t.Errorf("期待値 %q, 実際 %q", expected, a.String())
	}
}
