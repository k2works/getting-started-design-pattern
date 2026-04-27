# 第 15 章: Builder

## はじめに

コンピュータを構築する際、ディスプレイ、マザーボード、メモリ、ドライブなど多くの構成要素があります。コンストラクタの引数が増えると管理が困難です。

**Builder パターン**は、複雑なオブジェクトの構築過程をカプセル化し、同じ構築プロセスで異なる構成のオブジェクトを生成するパターンです。

---

## パターンの構造

```plantuml
@startuml
title Builder パターン

class Computer {
  - display : String
  - motherboard : Motherboard
  - drives : Array<Drive>
  - memory : Number
  + toString() : String
}

class Motherboard {
  - model : String
}

class Drive {
  - type : String
  - size : Number
  + toString() : String
}

class ComputerBuilder {
  - _computer : Computer
  + setDisplay(display) : this
  + setMotherboard(model) : this
  + addDrive(type, size) : this
  + setMemory(sizeGb) : this
  + build() : Computer
}

class DesktopBuilder {
}

class LaptopBuilder {
}

Computer *-- Motherboard
Computer *-- "*" Drive
ComputerBuilder --> Computer : builds
ComputerBuilder <|-- DesktopBuilder
ComputerBuilder <|-- LaptopBuilder

note right of ComputerBuilder::setDisplay
  return this で
  メソッドチェーン
end note
@enduml
```

**登場人物**:

- **Product（Computer）**: 構築される複雑なオブジェクト
- **Builder（ComputerBuilder）**: 構築のステップを定義する
- **ConcreteBuilder（DesktopBuilder / LaptopBuilder）**: 事前構成された Builder

---

## TDD で作る

### Red: テストを書く

```javascript
import { describe, it, expect } from '@jest/globals';
import { ComputerBuilder, DesktopBuilder, LaptopBuilder } from '../src/builder.js';

describe('Builder パターン', () => {
  it('ComputerBuilder でメソッドチェーンを使って構築できる', () => {
    const computer = new ComputerBuilder()
      .setDisplay('24-inch')
      .setMotherboard('Z790')
      .setMemory(16)
      .addDrive('ssd', 512)
      .build();

    expect(computer.display).toBe('24-inch');
    expect(computer.motherboard.model).toBe('Z790');
    expect(computer.memory).toBe(16);
  });

  it('マザーボードなしで build すると例外が発生する', () => {
    expect(() => {
      new ComputerBuilder().setMemory(16).build();
    }).toThrow('マザーボードは必須です');
  });
});
```

### Green: 実装する

```javascript
export class ComputerBuilder {
  constructor() { this._computer = new Computer(); }

  setDisplay(display) {
    this._computer.display = display;
    return this;  // メソッドチェーンの鍵
  }

  setMotherboard(model) {
    this._computer.motherboard = new Motherboard(model);
    return this;
  }

  addDrive(type, size) {
    this._computer.drives.push(new Drive(type, size));
    return this;
  }

  setMemory(sizeGb) {
    this._computer.memory = sizeGb;
    return this;
  }

  build() {
    if (!this._computer.motherboard) throw new Error('マザーボードは必須です');
    if (!this._computer.memory) throw new Error('メモリは必須です');
    return this._computer;
  }
}
```

### Refactor: 振り返り

- 各メソッドが `return this` を返すことで、メソッドチェーン（Fluent Interface）が実現できます。
- `build()` でバリデーションを行い、不完全な構築を防ぎます。
- `DesktopBuilder` / `LaptopBuilder` は事前構成された Builder で、よく使う構成を簡単に作れます。

---

## Ruby / Java / Python との比較

| 観点 | Ruby | Java | Python | JavaScript |
|------|------|------|--------|------------|
| メソッドチェーン | `tap` / `self` 返し | `return this` | `return self` | **`return this`** |
| バリデーション | `build` 時 | `build` 時 | `build` 時 | `build` 時 |
| 動的構築 | `method_missing` | 型安全な Builder | kwargs | メソッドチェーン |
| 不変オブジェクト | `freeze` | final フィールド | `@dataclass(frozen)` | `Object.freeze` |

**JavaScript の特徴**: `return this` によるメソッドチェーンは JavaScript で広く使われるイディオムです（jQuery, Express, Sequelize 等）。

---

## まとめ

| 観点 | 内容 |
|------|------|
| **意図** | 複雑なオブジェクトの構築過程をカプセル化する |
| **適用場面** | コンストラクタの引数が多い場合。構成のバリエーションがある場合 |
| **メリット** | 構築ステップの明確化。バリデーション付きの段階的構築 |
| **注意点** | Builder 自体が複雑になりすぎないこと |
| **関連パターン** | Factory（生成の委譲）、Composite（複雑な構造の構築） |
