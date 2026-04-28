# 第 6 章 Observer ― 状態変化を通知する

## はじめに

Observer パターンは、オブジェクトの状態が変化したとき、それに依存する複数のオブジェクトに自動的に通知を送るパターンです。イベント駆動プログラミングの基盤となるパターンであり、疎結合な設計を実現します。

## パターンの構造

```plantuml
@startuml
interface Observer {
  + update(employee: Employee): void
}

class Employee {
  - name: string
  - title: string
  - salary: number
  - observers: Observer[]
  + addObserver(o: Observer): void
  + removeObserver(o: Observer): void
  + setSalary(salary: number): void
  + setTitle(title: string): void
  - notifyObservers(): void
}

class Payroll {
  - lastChange: string
  + update(employee: Employee): void
  + getLastChange(): string
}

class TaxMan {
  - lastChange: string
  + update(employee: Employee): void
  + getLastChange(): string
}

Employee --> Observer : notifies
Observer <|.. Payroll
Observer <|.. TaxMan
@enduml
```

## TDD で作る

### Red: Observer への通知テスト

```typescript
it('給与変更時に Payroll に通知される', () => {
  const employee = new Employee('Alice', 'Engineer', 50000);
  const payroll = new Payroll();
  employee.addObserver(payroll);
  employee.setSalary(60000);
  expect(payroll.getLastChange()).toContain('60000');
});
```

### Green: 最小限の実装

```typescript
interface Observer {
  update(employee: Employee): void;
}

class Employee {
  private observers: Observer[] = [];

  constructor(
    private name: string,
    private title: string,
    private salary: number
  ) {}

  addObserver(observer: Observer): void {
    this.observers.push(observer);
  }

  setSalary(salary: number): void {
    this.salary = salary;
    this.notifyObservers();
  }

  private notifyObservers(): void {
    this.observers.forEach(observer => observer.update(this));
  }

  getSalary(): number {
    return this.salary;
  }
}

class Payroll implements Observer {
  private lastChange = '';

  update(employee: Employee): void {
    this.lastChange = `給与変更: ${employee.getSalary()}`;
  }

  getLastChange(): string {
    return this.lastChange;
  }
}
```

まずは給与変更通知だけに絞り、`Observer` 契約と通知経路を通します。

### Refactor

- `interface Observer` で通知プロトコルを型安全に定義
- `removeObserver()` で配列の `filter()` を使い、参照一致で削除
- `notifyObservers()` を `private` にして内部実装を隠蔽

## JavaScript との比較

| 観点 | JavaScript | TypeScript |
|:---|:---|:---|
| Observer の定義 | 暗黙的（`update` メソッドを期待） | `interface Observer` で契約を明示 |
| 型安全性 | なし | `update(employee: Employee)` で引数型を強制 |
| イベントシステム | `EventEmitter` (Node.js) | `interface` ベースで独自実装 |

## まとめ

| 項目 | 内容 |
|:---|:---|
| 意図 | オブジェクト間の一対多の依存関係を定義し、状態変化を自動通知する |
| 変わらないもの | 通知メカニズム（`addObserver` / `notifyObservers`） |
| 変わるもの | オブザーバーの数と種類 |
| TypeScript の利点 | `interface Observer` で通知プロトコルを型安全に定義 |
| 注意点 | メモリリーク（Observer の解除忘れ）に注意 |
