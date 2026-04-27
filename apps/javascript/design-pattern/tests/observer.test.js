import { describe, it, expect } from '@jest/globals';
import { Employee, Payroll, TaxMan } from '../src/observer.js';

describe('Observer パターン', () => {
  it('salary 変更で Payroll に通知が届く', () => {
    const employee = new Employee('田中', 'エンジニア', 500000);
    const payroll = new Payroll();
    employee.addObserver(payroll);

    employee.salary = 600000;

    expect(payroll.notifications).toHaveLength(1);
    expect(payroll.notifications[0]).toContain('田中');
    expect(payroll.notifications[0]).toContain('500000');
    expect(payroll.notifications[0]).toContain('600000');
  });

  it('title 変更で TaxMan に通知が届く', () => {
    const employee = new Employee('鈴木', 'エンジニア', 400000);
    const taxMan = new TaxMan();
    employee.addObserver(taxMan);

    employee.title = 'シニアエンジニア';

    expect(taxMan.notifications).toHaveLength(1);
    expect(taxMan.notifications[0]).toContain('鈴木');
    expect(taxMan.notifications[0]).toContain('シニアエンジニア');
  });

  it('複数のオブザーバーに同時通知する', () => {
    const employee = new Employee('佐藤', 'マネージャー', 700000);
    const payroll = new Payroll();
    const taxMan = new TaxMan();
    employee.addObserver(payroll);
    employee.addObserver(taxMan);

    employee.salary = 800000;

    expect(payroll.notifications).toHaveLength(1);
    expect(taxMan.notifications).toHaveLength(1);
  });

  it('オブザーバーを削除すると通知されなくなる', () => {
    const employee = new Employee('高橋', 'デザイナー', 450000);
    const payroll = new Payroll();
    employee.addObserver(payroll);
    employee.removeObserver(payroll);

    employee.salary = 500000;

    expect(payroll.notifications).toHaveLength(0);
  });

  it('複数回の変更で複数の通知が蓄積する', () => {
    const employee = new Employee('渡辺', 'PM', 600000);
    const payroll = new Payroll();
    employee.addObserver(payroll);

    employee.salary = 650000;
    employee.salary = 700000;

    expect(payroll.notifications).toHaveLength(2);
  });
});
