# 第 12 章：Factory — 判別共用体とファクトリ関数

## はじめに

Factory パターンは、オブジェクトの生成を専門の関数に委ねるパターンです。F# では、判別共用体でプロダクトの型を表現し、ファクトリ関数でインスタンスを生成します。

## パターンの構造

```plantuml
@startuml
title Factory（F# 版）

class "Animal" as A <<discriminated union>> {
  + Dog(name)
  + Cat(name)
  + Duck(name)
  + Frog(name)
}

class "Plant" as P <<discriminated union>> {
  + Algae(name)
  + Tree(name, height)
  + Flower(name, color)
}

class "Habitat" as H <<discriminated union>> {
  + Land
  + Water
  + Air
}

class <<module>> "Factory" as F {
  + createAnimal(type, name): Result
  + createAnimalByHabitat(habitat, name)
  + animalSound(animal)
  + plantDescription(plant)
}

F --> A : creates
F --> P : creates
F --> H : uses
A --> H : has habitat
@enduml
```

## TDD で作る

### Red: 失敗するテストを書く

```fsharp
[<Fact>]
let ``文字列から Dog を生成できる`` () =
    let result = createAnimal "dog" "ポチ"
    match result with
    | Ok(Dog name) -> Assert.Equal("ポチ", name)
    | _ -> Assert.Fail("Dog が期待される")
```

### Green: テストを通す最小のコードを書く

```fsharp
type Animal =
    | Dog of name: string
    | Cat of name: string
    | Duck of name: string
    | Frog of name: string

let createAnimal (animalType: string) (name: string) =
    match animalType.ToLower() with
    | "dog" -> Ok(Dog name)
    | "cat" -> Ok(Cat name)
    | unknown -> Error(sprintf "不明な動物タイプ: %s" unknown)
```

### Refactor

`Result` 型を使うことで、不正な入力に対するエラーハンドリングが型安全に行えます。

## OOP 版（C#）との比較

### C# 版

```csharp
abstract class Animal { public abstract string Sound(); }
class Dog : Animal { public override string Sound() => "ワンワン"; }
class AnimalFactory {
    public static Animal Create(string type, string name) => type switch {
        "dog" => new Dog(name),
        _ => throw new ArgumentException()
    };
}
```

### F# 版の優位性

- 判別共用体で全ケースが 1 箇所に定義される
- パターンマッチングの網羅性チェック
- `Result` 型でエラーを例外ではなく値として扱う

## まとめ

- Factory は判別共用体のコンストラクタとファクトリ関数で実現される
- パターンマッチングにより新しい型の追加漏れがコンパイル時に検出される
- `Result` 型で失敗を安全に表現できる
