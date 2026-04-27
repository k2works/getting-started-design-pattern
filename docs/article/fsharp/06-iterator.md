# 第 6 章：Iterator — シーケンス式と遅延評価

## はじめに

Iterator パターンは、コレクションの内部構造を公開せずに要素を順番にアクセスする方法を提供します。F# では、`seq { }` 式と `Seq` モジュールにより、このパターンが言語に組み込まれています。

## パターンの構造

```plantuml
@startuml
title Iterator（F# 版）

class <<module>> "Iterator" as I {
  + rangeSequence(start, stop)
  + fibonacci
  + depthFirst(tree)
  + breadthFirst(tree)
  + filterMap(predicate, mapper, source)
}

class "Tree~T~" as T <<discriminated union>> {
  + Leaf(T)
  + Node(T, Tree~T~ list)
}

class <<module>> "Seq" as S {
  + filter()
  + map()
  + take()
}

I --> T : traverses
I --> S : uses
@enduml
```

## TDD で作る

### Red: 失敗するテストを書く

```fsharp
[<Fact>]
let ``fibonacci で最初の10個のフィボナッチ数を取得できる`` () =
    let result = fibonacci |> Seq.take 10 |> Seq.toList
    Assert.Equal<int list>([ 0; 1; 1; 2; 3; 5; 8; 13; 21; 34 ], result)
```

### Green: テストを通す最小のコードを書く

```fsharp
let fibonacci =
    let rec fib a b =
        seq {
            yield a
            yield! fib b (a + b)
        }
    fib 0 1
```

### Refactor

`yield!` による再帰的なシーケンス生成は、F# の強力なイディオムです。遅延評価により、無限シーケンスを安全に扱えます。

## OOP 版（C#）との比較

### C# 版

```csharp
class FibonacciIterator : IEnumerator<int> {
    private int current, next;
    public bool MoveNext() { /* ... */ }
    public int Current => current;
}
```

### F# 版の優位性

- `seq { }` 式で宣言的にシーケンスを定義
- `yield` と `yield!` で直感的な要素生成
- 遅延評価がデフォルト
- `Seq` モジュールの豊富な関数で変換・フィルタリング

## まとめ

- Iterator パターンは F# の `seq { }` 式で完全に代替される
- 遅延評価により、無限シーケンスも安全に扱える
- `Seq.filter`, `Seq.map` などの高階関数で宣言的にデータを処理できる
