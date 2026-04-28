# 第 6 章：Observer

## はじめに

Observer パターンは、あるオブジェクトの状態変化を、登録された複数のオブジェクトに自動的に通知するパターンです。Rust ではクロージャのベクタで Observer リストを管理します。

## パターンの構造

```plantuml
@startuml
class Employee {
  +name: String
  -salary: i64
  -observers: Vec<Box<dyn FnMut>>
  +add_observer(observer)
  +set_salary(new_salary: i64)
  -notify_observers()
}

note right of Employee::observers
  クロージャベースの Observer
  FnMut で状態の更新も可能
end note
@enduml
```

## TDD で作る

### Red

```rust
#[test]
fn observer_is_notified_on_salary_change() {
    let log = Rc::new(RefCell::new(Vec::new()));
    let log_clone = Rc::clone(&log);

    let mut emp = Employee::new("Bob", 40_000);
    emp.add_observer(move |name, salary| {
        log_clone.borrow_mut().push(format!("{}: {}", name, salary));
    });

    emp.set_salary(45_000);
    assert_eq!(log.borrow()[0], "Bob: 45000");
}
```

### Green

```rust
type Observer = Box<dyn FnMut(&str, i64)>;

pub struct Employee {
    name: String,
    salary: i64,
    observers: Vec<Observer>,
}

impl Employee {
    pub fn new(name: &str, salary: i64) -> Self {
        Self {
            name: name.to_string(),
            salary,
            observers: Vec::new(),
        }
    }

    pub fn add_observer<F>(&mut self, observer: F)
    where
        F: FnMut(&str, i64) + 'static,
    {
        self.observers.push(Box::new(observer));
    }

    pub fn set_salary(&mut self, salary: i64) {
        self.salary = salary;
        self.notify_observers();
    }

    fn notify_observers(&mut self) {
        for observer in &mut self.observers {
            observer(&self.name, self.salary);
        }
    }
}
```

クロージャに `FnMut` を使うことで、通知先が内部ログやカウンタを更新するケースも自然に扱えます。

### Refactor

テスト内では `Rc<RefCell<>>` を使って Observer の状態を共有しますが、実装側は `FnMut` クロージャを受け取るだけのシンプルな設計です。

## 他言語比較

| 言語 | Observer の実現方法 |
|------|-------------------|
| Java | `Observer` インターフェース / イベントリスナー |
| Python | コールバック関数のリスト |
| Ruby | ブロック / Observable モジュール |
| **Rust** | **`Vec<Box<dyn FnMut>>` クロージャリスト** |

## まとめ

Rust の Observer パターンは、`FnMut` クロージャをベクタに格納することで実現します。所有権の制約により、Observer 側の状態共有には `Rc<RefCell<>>` が必要になりますが、これは Observer パターンの複雑さを型システムが明示してくれていると言えます。
