# 第 6 章: Observer

## はじめに

従業員の給与が変更されたとき、給与計算システムと税務システムの両方に通知したいとします。しかし、Employee クラスが Payroll や TaxMan を直接知っていると、密結合が生じます。

**Observer パターン**は、オブジェクトの状態変化を、依存するオブジェクト群に自動通知するパターンです。

---

## パターンの構造

```plantuml
@startuml
title Observer パターン

class Employee {
  - name : String
  - _salary : Number
  - _title : String
  - observers : Array
  + addObserver(observer)
  + removeObserver(observer)
  - notifyObservers(change)
  + salary : Number <<get/set>>
  + title : String <<get/set>>
}

interface Observer {
  + update(employee, change)
}

class Payroll {
  - notifications : Array
  + update(employee, change)
}

class TaxMan {
  - notifications : Array
  + update(employee, change)
}

Employee --> "*" Observer : notifies
Observer <|.. Payroll
Observer <|.. TaxMan
@enduml
```

**登場人物**:

- **Subject（Employee）**: 状態を持ち、オブザーバーに通知する
- **Observer（Payroll / TaxMan）**: 通知を受け取り反応する

---

## TDD で作る

### Red: テストを書く

```javascript
import { describe, it, expect } from '@jest/globals';
import { Employee, Payroll, TaxMan } from '../src/observer.js';

describe('Observer パターン', () => {
  it('salary 変更で Payroll に通知が届く', () => {
    const employee = new Employee('田中', 'エンジニア', 500000);
    const payroll = new Payroll();
    employee.addObserver(payroll);

    employee.salary = 600000;

    expect(payroll.notifications).toHaveLength(1);
    expect(payroll.notifications[0]).toContain('500000');
    expect(payroll.notifications[0]).toContain('600000');
  });

  it('オブザーバーを削除すると通知されなくなる', () => {
    const employee = new Employee('高橋', 'デザイナー', 450000);
    const payroll = new Payroll();
    employee.addObserver(payroll);
    employee.removeObserver(payroll);

    employee.salary = 500000;
    expect(payroll.notifications).toHaveLength(0);
  });
});
```

### Green: 実装する

```javascript
export class Employee {
  constructor(name, title, salary) {
    this.name = name;
    this._title = title;
    this._salary = salary;
    this.observers = [];
  }

  addObserver(observer) { this.observers.push(observer); }
  removeObserver(observer) {
    this.observers = this.observers.filter((o) => o !== observer);
  }

  notifyObservers(change) {
    for (const observer of this.observers) {
      observer.update(this, change);
    }
  }

  get salary() { return this._salary; }
  set salary(newSalary) {
    const old = this._salary;
    this._salary = newSalary;
    this.notifyObservers({ property: 'salary', old, new: newSalary });
  }

  get title() { return this._title; }
  set title(newTitle) {
    const old = this._title;
    this._title = newTitle;
    this.notifyObservers({ property: 'title', old, new: newTitle });
  }
}
```

`title` プロパティにも `get`/`set` アクセサを定義し、役職変更時にもオブザーバーへ通知が走るようにしています。

#### TaxMan オブザーバー

`Payroll` と同様に、`TaxMan` は税務通知を担当するオブザーバーです。

```javascript
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
```

#### title 変更通知と複数オブザーバーのテスト

```javascript
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
```

### Refactor: 振り返り

- JavaScript の `get` / `set` アクセサを使い、プロパティ代入 `employee.salary = 600000` や `employee.title = 'シニアエンジニア'` の裏でオブザーバー通知が走る設計にしました。
- `salary` と `title` の両方がオブザーバー通知の対象になっています。変更情報オブジェクトの `property` フィールドで、どのプロパティが変更されたかをオブザーバーが識別できます。
- Observer は `update(employee, change)` メソッドを持つ任意のオブジェクトです（Duck Typing）。`Payroll` は給与計算用、`TaxMan` は税務通知用と、責務が分離されています。

---

## Ruby / Java / Python との比較

| 観点 | Ruby | Java | Python | JavaScript |
|------|------|------|--------|------------|
| 通知トリガー | メソッド呼び出し | メソッド呼び出し | property デコレータ | `get`/`set` アクセサ |
| Observer 契約 | Duck Typing | `Observer` インターフェース | Duck Typing | Duck Typing |
| 標準ライブラリ | `Observable` (deprecated) | `java.util.Observer` (deprecated) | なし | `EventTarget` / `EventEmitter` |
| 変更情報 | Hash | イベントオブジェクト | dict | プレーンオブジェクト |

**JavaScript の特徴**: `get`/`set` アクセサにより、プロパティ代入で自動通知を実現できます。Node.js の `EventEmitter` を使う方法もありますが、パターンの本質を学ぶためシンプルに実装しました。

---

## まとめ

| 観点 | 内容 |
|------|------|
| **意図** | オブジェクトの状態変化を依存オブジェクトに自動通知する |
| **適用場面** | 1 つの変化が複数のオブジェクトに影響する場合 |
| **メリット** | Subject と Observer の疎結合。Observer の動的な追加・削除 |
| **注意点** | 通知の順序に依存しないこと。循環通知に注意 |
| **関連パターン** | Mediator（通知の集約）、Strategy（1 対 1 の委譲） |
