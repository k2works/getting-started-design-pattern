/**
 * Proxy パターン
 *
 * 対象オブジェクトへのアクセスを制御する代理オブジェクトを提供する。
 * TypeScript の Proxy<T> を活用して型安全に実装する。
 */

export interface BankAccount {
  deposit(amount: number): void;
  withdraw(amount: number): void;
  readonly balance: number;
}

export class RealBankAccount implements BankAccount {
  private _balance: number;

  constructor(balance: number = 0) {
    this._balance = balance;
  }

  deposit(amount: number): void {
    this._balance += amount;
  }

  withdraw(amount: number): void {
    if (amount > this._balance) {
      throw new Error('Insufficient funds');
    }
    this._balance -= amount;
  }

  get balance(): number {
    return this._balance;
  }
}

export function createProtectionProxy(
  account: BankAccount,
  isOwner: boolean
): BankAccount {
  return new Proxy(account, {
    get(target, prop, receiver) {
      if (prop === 'withdraw' && !isOwner) {
        return () => {
          throw new Error('Access denied: only the owner can withdraw');
        };
      }
      return Reflect.get(target, prop, receiver);
    },
  });
}

export function createVirtualProxy(
  factory: () => BankAccount
): BankAccount {
  let realAccount: BankAccount | null = null;

  const ensureInitialized = (): BankAccount => {
    if (realAccount === null) {
      realAccount = factory();
    }
    return realAccount;
  };

  return new Proxy({} as BankAccount, {
    get(_target, prop, _receiver) {
      const real = ensureInitialized();
      const value = Reflect.get(real, prop, real);
      if (typeof value === 'function') {
        return value.bind(real);
      }
      return value;
    },
  });
}
