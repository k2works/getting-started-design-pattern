# 第 2 章 Ruby から TypeScript へ

## はじめに

本書の元となった『Ruby によるデザインパターン』では、Ruby のダックタイピングと動的型付けを活かしたパターン実装が紹介されています。本章では、Ruby のアプローチを TypeScript に移植する際の考え方と、型システムがもたらす利点を整理します。

## Ruby と TypeScript の比較

### 型システム

```ruby
# Ruby: ダックタイピング
class Duck
  def speak
    "Quack!"
  end
end

class Person
  def speak
    "Hello!"
  end
end

# どちらも speak を持っていれば使える
def make_it_speak(thing)
  thing.speak
end
```

```typescript
// TypeScript: interface による構造的型付け
interface Speakable {
  speak(): string;
}

class Duck implements Speakable {
  speak(): string {
    return 'Quack!';
  }
}

class Person implements Speakable {
  speak(): string {
    return 'Hello!';
  }
}

function makeItSpeak(thing: Speakable): string {
  return thing.speak();
}
```

TypeScript の構造的型付け（structural typing）は、Ruby のダックタイピングに近い考え方です。ただし、コンパイル時に型チェックが行われる点が異なります。

### ブロックとコールバック

```ruby
# Ruby: ブロック
[1, 2, 3].each { |n| puts n }

# Ruby: Proc
formatter = Proc.new { |text| "<p>#{text}</p>" }
```

```typescript
// TypeScript: アロー関数と型付きコールバック
[1, 2, 3].forEach((n) => console.log(n));

// 型付きの関数型
type Formatter = (text: string) => string;
const formatter: Formatter = (text) => `<p>${text}</p>`;
```

Ruby のブロックや Proc は、TypeScript では型付きの関数型（`type` や `interface`）で表現します。

### Mixin

```ruby
# Ruby: Mixin
module Enumerable
  def map(&block)
    # ...
  end
end

class Portfolio
  include Enumerable
end
```

```typescript
// TypeScript: interface と Iterable プロトコル
class Portfolio implements Iterable<Account> {
  [Symbol.iterator](): Iterator<Account> {
    // ...
  }
}
```

Ruby の Mixin は、TypeScript では interface の実装や、Iterable プロトコルの実装で代替します。

## パターン実装における主な違い

| 観点 | Ruby | TypeScript |
|:---|:---|:---|
| インターフェースの定義 | 暗黙的（ダックタイピング） | 明示的（`interface`） |
| 抽象クラス | 慣例的（`raise NotImplementedError`） | `abstract class` + `abstract method` |
| アクセス制御 | `private`, `protected`（実行時） | `private`, `protected`（コンパイル時） |
| ブロック/クロージャ | ブロック、Proc、Lambda | アロー関数、関数型 |
| Mixin | `include`, `extend` | interface の多重実装 |
| メタプログラミング | `method_missing`, `define_method` | Proxy、Decorator（制限的） |
| Singleton | `Singleton` モジュール | `private constructor` + 静的メソッド |

## TypeScript の強み

1. **コンパイル時の型チェック** ― パターンの契約違反を実行前に検出
2. **IDE サポート** ― 補完、リファクタリング、ナビゲーション
3. **Generics** ― 型安全な汎用コンポーネント
4. **Union Types** ― 状態の網羅性チェック（exhaustive check）

## TypeScript の制約

1. **メタプログラミングの制限** ― Ruby の `method_missing` のような動的手法は限定的
2. **型消去** ― 実行時には型情報が消えるため、実行時の型チェックには Type Guard が必要
3. **構造的型付け** ― 名前ベースではなく構造ベースなので、意図しない型の互換性が生じることがある

## まとめ

Ruby の柔軟性と TypeScript の型安全性は、異なるアプローチでデザインパターンを実現します。TypeScript では、Ruby で暗黙的だった設計の意図を `interface` や `abstract class` で明示的にコードに残せます。この明示性が、大規模なコードベースでの保守性を高めます。
