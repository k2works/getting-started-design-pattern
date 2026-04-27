import { describe, it, expect } from '@jest/globals';
import { Account, Portfolio, FilteredPortfolio } from '../src/iterator.js';

describe('Iterator パターン', () => {
  it('Portfolio を for-of でイテレートできる', () => {
    const portfolio = new Portfolio();
    portfolio.addAccount(new Account('普通預金', 100000));
    portfolio.addAccount(new Account('定期預金', 500000));

    const names = [];
    for (const account of portfolio) {
      names.push(account.name);
    }

    expect(names).toEqual(['普通預金', '定期預金']);
  });

  it('Portfolio の totalBalance が全口座の合計を返す', () => {
    const portfolio = new Portfolio();
    portfolio.addAccount(new Account('A', 100));
    portfolio.addAccount(new Account('B', 200));
    portfolio.addAccount(new Account('C', 300));

    expect(portfolio.totalBalance).toBe(600);
  });

  it('Portfolio をスプレッド構文で配列に変換できる', () => {
    const portfolio = new Portfolio();
    portfolio.addAccount(new Account('X', 1000));
    portfolio.addAccount(new Account('Y', 2000));

    const accounts = [...portfolio];
    expect(accounts).toHaveLength(2);
    expect(accounts[0].name).toBe('X');
  });

  it('空の Portfolio をイテレートしても問題ない', () => {
    const portfolio = new Portfolio();
    const accounts = [...portfolio];
    expect(accounts).toEqual([]);
    expect(portfolio.totalBalance).toBe(0);
  });

  it('FilteredPortfolio で条件に合う口座だけイテレートする', () => {
    const portfolio = new Portfolio();
    portfolio.addAccount(new Account('少額', 100));
    portfolio.addAccount(new Account('大口', 1000000));
    portfolio.addAccount(new Account('中額', 50000));

    const rich = new FilteredPortfolio(portfolio, (a) => a.balance >= 50000);
    const result = [...rich];

    expect(result).toHaveLength(2);
    expect(result[0].name).toBe('大口');
    expect(result[1].name).toBe('中額');
  });

  it('Account の toString が名前と残高を返す', () => {
    const account = new Account('普通預金', 123456);
    expect(account.toString()).toBe('普通預金: 123456');
  });
});
