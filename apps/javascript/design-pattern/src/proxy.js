// Proxy パターン
// 別のオブジェクトへのアクセスを制御する代理オブジェクト

export class BankAccount {
  constructor(owner, balance = 0) {
    this.owner = owner;
    this._balance = balance;
  }

  deposit(amount) {
    this._balance += amount;
  }

  withdraw(amount) {
    if (amount > this._balance) {
      throw new Error('残高不足');
    }
    this._balance -= amount;
  }

  get balance() {
    return this._balance;
  }
}

// Protection Proxy: ES6 Proxy API でアクセス制御
export function protectionProxy(account, currentUser) {
  return new Proxy(account, {
    get(target, prop, receiver) {
      if (prop === 'balance') {
        return target.balance;
      }
      if (typeof target[prop] === 'function') {
        if (currentUser !== target.owner) {
          throw new Error(`${currentUser} は ${target.owner} のアカウントを操作できません`);
        }
        return target[prop].bind(target);
      }
      return Reflect.get(target, prop, receiver);
    },
  });
}

// Virtual Proxy: 遅延初期化
export function virtualProxy(factory) {
  let instance = null;

  return new Proxy({}, {
    get(_target, prop, _receiver) {
      if (instance === null) {
        instance = factory();
      }
      const value = instance[prop];
      if (typeof value === 'function') {
        return value.bind(instance);
      }
      return value;
    },
  });
}
