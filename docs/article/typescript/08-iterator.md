# 第 8 章 Iterator ― 要素を順番に取り出す

## はじめに

Iterator パターンは、コレクションの内部構造を公開せずに、要素を順番に取り出す方法を提供するパターンです。TypeScript では `Iterable` プロトコルと `Symbol.iterator` を使って、言語レベルでイテレーションをサポートします。

## パターンの構造

```plantuml
@startuml
class Account {
  + name: string
  + balance: number
  + compareTo(other: Account): number
  + toString(): string
}

class Portfolio {
  - accounts: Account[]
  + addAccount(account: Account): void
  + getLength(): number
  + getTotalBalance(): number
  + sortByBalance(): Account[]
  + [Symbol.iterator](): Iterator<Account>
}

interface "Iterable<Account>" as Iterable {
  + [Symbol.iterator](): Iterator<Account>
}

Portfolio ..|> Iterable
Portfolio o-- Account
@enduml
```

## TDD で作る

### Red: for...of でイテレートするテスト

```typescript
it('Portfolio は for...of でイテレートできる', () => {
  const portfolio = new Portfolio();
  portfolio.addAccount(new Account('Alice', 1000));
  portfolio.addAccount(new Account('Bob', 2000));
  const names: string[] = [];
  for (const account of portfolio) {
    names.push(account.name);
  }
  expect(names).toEqual(['Alice', 'Bob']);
});
```

### Green: Symbol.iterator の実装

```typescript
[Symbol.iterator](): Iterator<Account> {
  let index = 0;
  const accounts = this.accounts;
  return {
    next(): IteratorResult<Account> {
      if (index < accounts.length) {
        return { value: accounts[index++], done: false };
      }
      return { value: undefined as unknown as Account, done: true };
    },
  };
}
```

### compareTo() と sortByBalance()

`Account` クラスは `compareTo()` メソッドを持ち、残高の差を返すことで比較を可能にします。

```typescript
compareTo(other: Account): number {
  return this.balance - other.balance;
}
```

戻り値が負なら `this` の方が残高が少なく、正なら `this` の方が多いことを意味します。この比較関数は `Portfolio.sortByBalance()` で使われ、残高の昇順にソートされたコピーを返します。

```typescript
sortByBalance(): Account[] {
  return [...this.accounts].sort((a, b) => a.compareTo(b));
}
```

スプレッド構文 `[...this.accounts]` で元の配列のコピーを作成してからソートするため、`Portfolio` 内部の順序は変更されません。`compareTo()` を `Account` クラスに定義することで、ソートのロジックをコレクション側ではなくドメインオブジェクト側に持たせている点が Comparable パターンの利点です。

### Refactor

- `Iterable<Account>` インターフェースを実装し、`for...of` とスプレッド構文の両方をサポート
- `compareTo` で Comparable パターンも実装し、ソートを可能に

## JavaScript との比較

| 観点 | JavaScript | TypeScript |
|:---|:---|:---|
| Iterable プロトコル | `Symbol.iterator` | `implements Iterable<T>` で型安全に |
| Iterator の戻り値型 | 任意 | `IteratorResult<T>` で型付き |
| ジェネリクス | なし | `Iterable<Account>` で要素型を固定 |

## まとめ

| 項目 | 内容 |
|:---|:---|
| 意図 | コレクションの内部構造を隠蔽し、統一的な走査手段を提供する |
| 変わらないもの | 走査プロトコル（`Symbol.iterator`） |
| 変わるもの | コレクションの内部構造 |
| TypeScript の利点 | `Iterable<T>` で型安全なイテレーション、`for...of` やスプレッド構文と統合 |
| 注意点 | 無限イテレータを作る場合は `done: true` の条件に注意 |
