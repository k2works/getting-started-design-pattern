import { describe, it, expect } from '@jest/globals';
import { BankAccount, protectionProxy, virtualProxy } from '../src/proxy.js';

describe('Proxy パターン', () => {
  describe('BankAccount', () => {
    it('入金・出金ができる', () => {
      const account = new BankAccount('田中', 1000);
      account.deposit(500);
      expect(account.balance).toBe(1500);

      account.withdraw(300);
      expect(account.balance).toBe(1200);
    });

    it('残高不足で出金すると例外が発生する', () => {
      const account = new BankAccount('田中', 100);
      expect(() => account.withdraw(200)).toThrow('残高不足');
    });
  });

  describe('Protection Proxy', () => {
    it('所有者は操作できる', () => {
      const account = new BankAccount('田中', 1000);
      const proxy = protectionProxy(account, '田中');

      proxy.deposit(500);
      expect(proxy.balance).toBe(1500);
    });

    it('他人は操作できない', () => {
      const account = new BankAccount('田中', 1000);
      const proxy = protectionProxy(account, '鈴木');

      expect(() => proxy.deposit(500)).toThrow('鈴木 は 田中 のアカウントを操作できません');
    });

    it('他人でも残高は確認できる', () => {
      const account = new BankAccount('田中', 1000);
      const proxy = protectionProxy(account, '鈴木');

      expect(proxy.balance).toBe(1000);
    });
  });

  describe('Virtual Proxy', () => {
    it('アクセスされるまでインスタンスが生成されない', () => {
      let created = false;
      const proxy = virtualProxy(() => {
        created = true;
        return new BankAccount('仮想', 5000);
      });

      expect(created).toBe(false);
      expect(proxy.balance).toBe(5000);
      expect(created).toBe(true);
    });

    it('一度生成されたインスタンスが再利用される', () => {
      let callCount = 0;
      const proxy = virtualProxy(() => {
        callCount++;
        return new BankAccount('仮想', 1000);
      });

      proxy.deposit(100);
      proxy.deposit(200);

      expect(callCount).toBe(1);
      expect(proxy.balance).toBe(1300);
    });
  });
});
