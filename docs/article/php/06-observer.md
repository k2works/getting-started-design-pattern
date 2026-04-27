# 第 6 章: Observer

## は���めに

従業員の給与が変更されたとき、給与システムと税務署の両方に通知する必要があります。しかし Employee クラスが Payroll や TaxMan を直接知っていると密結合になります。

**Observer パターン**は、オブジェクトの状態変化を、依存オブジェクトに自動的に通知する仕組みを提供します。

---

## パターンの構造

```plantuml
@startuml
title Observer パターン

interface Observer {
  + update(Employee) : void
}

class Employee {
  - name : string
  - title : string
  - salary : float
  - observers : SplObjectStorage
  + addObserver(Observer) : void
  + removeObserver(Observer) : void
  + setSalary(float) : void
  - notifyObservers() : void
}

class Payroll {
  - log : array
  + update(Employee) : void
  + getLog() : array
}

class TaxMan {
  - log : array
  + update(Employee) : void
  + getLog() : array
}

Employee --> Observer : notifies
Observer <|.. Payroll
Observer <|.. TaxMan
@enduml
```

**登場人物**:

- **Subject（Employee）**: 状態を保持し、Observer のリストを管理する
- **Observer（Observer interface）**: 通知を受けるインターフェース
- **ConcreteObserver（Payroll / TaxMan）**: 通知に応じた処理を実装する

---

## TDD で作る

### Red: ���ストを書く

```php
public function testPayrollIsNotifiedOnSalaryChange(): void
{
    $employee = new Employee('田中', 'エンジニア', 500000);
    $payroll = new Payroll();
    $employee->addObserver($payroll);

    $employee->setSalary(600000);

    $this->assertCount(1, $payroll->getLog());
    $this->assertStringContainsString('田中', $payroll->getLog()[0]);
}
```

### Green: 実装する

```php
class Employee
{
    private \SplObjectStorage $observers;

    public function __construct(
        private string $name,
        private string $title,
        private float $salary
    ) {
        $this->observers = new \SplObjectStorage();
    }

    public function setSalary(float $salary): void
    {
        $this->salary = $salary;
        $this->notifyObservers();
    }

    public function addObserver(Observer $observer): void
    {
        $this->observers->offsetSet($observer);
    }

    private function notifyObservers(): void
    {
        foreach ($this->observers as $observer) {
            $observer->update($this);
        }
    }
}
```

### Refactor: 振り返り

- `SplObjectStorage` はオブジェクトをキーとするコレクションで、同一 Observer の重複登録を自然に防ぎます
- `foreach` で直接イテレーションできるため、Observer の走査がシンプルです

---

## PHP らしい実装

### SplObjectStorage

PHP 標準の `SplObjectStorage` は Observer 管理に最適です。配列とは異なり、オブジェクトの同一性（identity）で管理するため、`===` 比較が自動的に行われます。

### PHP 8.5 対応

PHP 8.5 では `attach()` / `detach()` が非推奨になりました。代わりに `offsetSet()` / `offsetUnset()` を使用し���す。

---

## 他言語との比較

| 言語 | Observer の管理 |
|------|---------------|
| PHP | `SplObjectStorage` + `offsetSet()` |
| Ruby | 配列 + `<<` / `delete` |
| Java | `ArrayList<Observer>` |
| Python | `set` / `list` |
| JavaScript | `Set` / `Array` |

---

## まと��

| 観点 | 内容 |
|------|------|
| **意図** | オブジェクトの状態変化を依存オブジェクトに自動通知する |
| **適用場面** | イベント駆動の通知、MVC のモデル → ビュー更新 |
| **メリット** | Subject と Observer の疎結合、Observer の動的追加・削除 |
| **注意点** | 通知の順序保証がない、循環参照に注意 |
| **関連パターン** | Mediator（通知の中心を設ける）、Event Dispatcher |
