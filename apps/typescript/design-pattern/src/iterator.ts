/**
 * Iterator パターン
 *
 * コレクションの内部構造を公開せずに、
 * 要素を順番に取り出す方法を提供する。
 */

export class Account {
  readonly name: string;
  readonly balance: number;

  constructor(name: string, balance: number) {
    this.name = name;
    this.balance = balance;
  }

  compareTo(other: Account): number {
    return this.balance - other.balance;
  }

  toString(): string {
    return `Account(${this.name}, ${this.balance})`;
  }
}

export class Portfolio implements Iterable<Account> {
  private accounts: Account[] = [];

  addAccount(account: Account): void {
    this.accounts.push(account);
  }

  getLength(): number {
    return this.accounts.length;
  }

  getTotalBalance(): number {
    return this.accounts.reduce((sum, a) => sum + a.balance, 0);
  }

  sortByBalance(): Account[] {
    return [...this.accounts].sort((a, b) => a.compareTo(b));
  }

  [Symbol.iterator](): Iterator<Account> {
    let index = 0;
    const accounts = this.accounts;
    return {
      next(): IteratorResult<Account> {
        if (index < accounts.length) {
          return { value: accounts[index++], done: false };
        }
        return { value: undefined as unknown as Account, done: true };
      },
    };
  }
}
