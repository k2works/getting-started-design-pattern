// Observer パターン
// オブジェクトの状態変化を、依存するオブジェクト群に自動通知する

export class Employee {
  constructor(name, title, salary) {
    this.name = name;
    this._title = title;
    this._salary = salary;
    this.observers = [];
  }

  addObserver(observer) {
    this.observers.push(observer);
  }

  removeObserver(observer) {
    this.observers = this.observers.filter((o) => o !== observer);
  }

  notifyObservers(change) {
    for (const observer of this.observers) {
      observer.update(this, change);
    }
  }

  get salary() {
    return this._salary;
  }

  set salary(newSalary) {
    const old = this._salary;
    this._salary = newSalary;
    this.notifyObservers({ property: 'salary', old, new: newSalary });
  }

  get title() {
    return this._title;
  }

  set title(newTitle) {
    const old = this._title;
    this._title = newTitle;
    this.notifyObservers({ property: 'title', old, new: newTitle });
  }
}

export class Payroll {
  constructor() {
    this.notifications = [];
  }

  update(employee, change) {
    this.notifications.push(
      `${employee.name} の ${change.property} が ${change.old} から ${change.new} に変更されました`
    );
  }
}

export class TaxMan {
  constructor() {
    this.notifications = [];
  }

  update(employee, change) {
    this.notifications.push(
      `${employee.name} に新しい税金通知を送付: ${change.property} = ${change.new}`
    );
  }
}
