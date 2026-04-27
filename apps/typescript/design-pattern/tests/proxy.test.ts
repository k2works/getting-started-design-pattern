import {
  RealBankAccount,
  createProtectionProxy,
  createVirtualProxy,
} from '../src/proxy';

describe('Proxy パターン', () => {
  describe('RealBankAccount', () => {
    it('入金すると残高が増える', () => {
      const account = new RealBankAccount(100);
      account.deposit(50);
      expect(account.balance).toBe(150);
    });

    it('残高不足の出金はエラーを投げる', () => {
      const account = new RealBankAccount(100);
      expect(() => account.withdraw(200)).toThrow('Insufficient funds');
    });
  });

  describe('Protection Proxy', () => {
    it('オーナーは出金できる', () => {
      const real = new RealBankAccount(100);
      const proxy = createProtectionProxy(real, true);
      proxy.withdraw(50);
      expect(proxy.balance).toBe(50);
    });

    it('オーナーでなければ出金はエラーになる', () => {
      const real = new RealBankAccount(100);
      const proxy = createProtectionProxy(real, false);
      expect(() => proxy.withdraw(50)).toThrow('Access denied');
    });

    it('オーナーでなくても入金と残高確認はできる', () => {
      const real = new RealBankAccount(100);
      const proxy = createProtectionProxy(real, false);
      proxy.deposit(50);
      expect(proxy.balance).toBe(150);
    });
  });

  describe('Virtual Proxy', () => {
    it('初回アクセスまで実体を生成しない', () => {
      let created = false;
      const proxy = createVirtualProxy(() => {
        created = true;
        return new RealBankAccount(100);
      });

      expect(created).toBe(false);
      expect(proxy.balance).toBe(100);
      expect(created).toBe(true);
    });

    it('生成後は通常通り操作できる', () => {
      const proxy = createVirtualProxy(() => new RealBankAccount(200));
      proxy.deposit(100);
      expect(proxy.balance).toBe(300);
    });
  });
});
