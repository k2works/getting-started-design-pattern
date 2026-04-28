# 第 9 章：Composite

## はじめに

Composite パターンは、個々のオブジェクトとオブジェクトの集合を同一視して扱うパターンです。Rust では列挙型（enum）で木構造を自然に表現できます。

## パターンの構造

```plantuml
@startuml
class Task {
  +name(): &str
  +get_time_required(): f64
  +total_basic_tasks(): usize
}

class Leaf {
  +name: String
  +duration: f64
}

class Composite {
  +name: String
  +children: Vec<Task>
}

Task <|-- Leaf
Task <|-- Composite
Composite "1" o--> "*" Task
@enduml
```

## TDD で作る

### Red

```rust
#[test]
fn nested_composite_works_recursively() {
    let inner = Task::new_composite("Backend", vec![
        Task::new_leaf("API", 4.0),
        Task::new_leaf("DB", 3.0),
    ]);
    let outer = Task::new_composite("Project", vec![inner, Task::new_leaf("Frontend", 6.0)]);
    assert_eq!(outer.get_time_required(), 13.0);
    assert_eq!(outer.total_basic_tasks(), 3);
}
```

### Green

```rust
pub enum Task {
    Leaf { name: String, duration: f64 },
    Composite { name: String, children: Vec<Task> },
}

impl Task {
    pub fn new_leaf(name: &str, duration: f64) -> Self {
        Self::Leaf {
            name: name.to_string(),
            duration,
        }
    }

    pub fn new_composite(name: &str, children: Vec<Task>) -> Self {
        Self::Composite {
            name: name.to_string(),
            children,
        }
    }

    pub fn get_time_required(&self) -> f64 {
        match self {
            Task::Leaf { duration, .. } => *duration,
            Task::Composite { children, .. } => {
                children.iter().map(|child| child.get_time_required()).sum()
            }
        }
    }

    pub fn total_basic_tasks(&self) -> usize {
        match self {
            Task::Leaf { .. } => 1,
            Task::Composite { children, .. } => {
                children.iter().map(|child| child.total_basic_tasks()).sum()
            }
        }
    }
}
```

`Leaf` と `Composite` の分岐は `match` に集約されるため、クライアント側に型判定を漏らしません。

### Refactor

列挙型を使うことで、「Leaf か Composite か」の判定がパターンマッチで網羅的に行われ、新しいバリアントを追加した際にコンパイラが未処理のケースを指摘してくれます。

## 他言語比較

| 言語 | Composite の実現方法 |
|------|-------------------|
| Java | 抽象クラス + 継承 |
| Python | 基底クラス + サブクラス |
| Ruby | ダックタイピング |
| **Rust** | **列挙型 + パターンマッチ** |

## まとめ

Rust の列挙型は Composite パターンの最適な表現です。ヒープ割り当てが `Vec` 内で管理され、再帰的な構造も安全に扱えます。パターンマッチによる網羅性チェックは、バグの早期発見に貢献します。
