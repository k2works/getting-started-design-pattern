// Iterator パターン
// コレクションの内部構造を公開せずに要素を順番にアクセスする

export class Account {
  constructor(name, balance) {
    this.name = name;
    this.balance = balance;
  }

  toString() {
    return `${this.name}: ${this.balance}`;
  }
}

export class Portfolio {
  constructor() {
    this.accounts = [];
  }

  addAccount(account) {
    this.accounts.push(account);
  }

  get totalBalance() {
    let total = 0;
    for (const account of this) {
      total += account.balance;
    }
    return total;
  }

  get length() {
    return this.accounts.length;
  }

  // Symbol.iterator で for-of をサポート
  [Symbol.iterator]() {
    let index = 0;
    const accounts = this.accounts;
    return {
      next() {
        if (index < accounts.length) {
          return { value: accounts[index++], done: false };
        }
        return { done: true };
      },
    };
  }
}

// ジェネレータ版のイテレータ
export class FilteredPortfolio {
  constructor(portfolio, predicate) {
    this.portfolio = portfolio;
    this.predicate = predicate;
  }

  *[Symbol.iterator]() {
    for (const account of this.portfolio) {
      if (this.predicate(account)) {
        yield account;
      }
    }
  }
}
