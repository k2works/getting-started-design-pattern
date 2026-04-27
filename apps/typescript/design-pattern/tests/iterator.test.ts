import { Account, Portfolio } from '../src/iterator';

describe('Iterator パターン', () => {
  it('Account の compareTo は残高の差を返す', () => {
    const a = new Account('Alice', 1000);
    const b = new Account('Bob', 2000);
    expect(a.compareTo(b)).toBeLessThan(0);
    expect(b.compareTo(a)).toBeGreaterThan(0);
  });

  it('Portfolio は for...of でイテレートできる', () => {
    const portfolio = new Portfolio();
    portfolio.addAccount(new Account('Alice', 1000));
    portfolio.addAccount(new Account('Bob', 2000));

    const names: string[] = [];
    for (const account of portfolio) {
      names.push(account.name);
    }
    expect(names).toEqual(['Alice', 'Bob']);
  });

  it('Portfolio はスプレッド構文で展開できる', () => {
    const portfolio = new Portfolio();
    portfolio.addAccount(new Account('Alice', 1000));
    portfolio.addAccount(new Account('Bob', 2000));

    const accounts = [...portfolio];
    expect(accounts).toHaveLength(2);
  });

  it('Portfolio の合計残高を計算できる', () => {
    const portfolio = new Portfolio();
    portfolio.addAccount(new Account('Alice', 1000));
    portfolio.addAccount(new Account('Bob', 2000));
    portfolio.addAccount(new Account('Carol', 3000));

    expect(portfolio.getTotalBalance()).toBe(6000);
  });

  it('Portfolio を残高順でソートできる', () => {
    const portfolio = new Portfolio();
    portfolio.addAccount(new Account('Rich', 5000));
    portfolio.addAccount(new Account('Poor', 100));
    portfolio.addAccount(new Account('Mid', 2000));

    const sorted = portfolio.sortByBalance();
    expect(sorted[0].name).toBe('Poor');
    expect(sorted[2].name).toBe('Rich');
  });

  it('Account の toString は名前と残高を含む', () => {
    const account = new Account('Alice', 1000);
    expect(account.toString()).toBe('Account(Alice, 1000)');
  });
});
