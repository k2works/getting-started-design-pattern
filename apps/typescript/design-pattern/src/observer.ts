/**
 * Observer パターン
 *
 * オブジェクトの状態変化を、依存オブジェクトに自動通知する。
 */

export interface Observer {
  update(employee: Employee): void;
}

export class Employee {
  private name: string;
  private title: string;
  private salary: number;
  private observers: Observer[] = [];

  constructor(name: string, title: string, salary: number) {
    this.name = name;
    this.title = title;
    this.salary = salary;
  }

  getName(): string {
    return this.name;
  }

  getTitle(): string {
    return this.title;
  }

  getSalary(): number {
    return this.salary;
  }

  addObserver(observer: Observer): void {
    this.observers.push(observer);
  }

  removeObserver(observer: Observer): void {
    this.observers = this.observers.filter((o) => o !== observer);
  }

  setTitle(title: string): void {
    this.title = title;
    this.notifyObservers();
  }

  setSalary(salary: number): void {
    this.salary = salary;
    this.notifyObservers();
  }

  private notifyObservers(): void {
    for (const observer of this.observers) {
      observer.update(this);
    }
  }
}

export class Payroll implements Observer {
  private lastChange = '';

  update(employee: Employee): void {
    this.lastChange = `Payroll: Cut check for ${employee.getName()} at ${employee.getSalary()}`;
  }

  getLastChange(): string {
    return this.lastChange;
  }
}

export class TaxMan implements Observer {
  private lastChange = '';

  update(employee: Employee): void {
    this.lastChange = `TaxMan: Send new tax bill for ${employee.getName()} at ${employee.getSalary()}`;
  }

  getLastChange(): string {
    return this.lastChange;
  }
}
