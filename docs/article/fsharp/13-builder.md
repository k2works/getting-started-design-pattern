# 第 13 章：Builder — コンピュテーション式とパイプライン

## はじめに

Builder パターンは、複雑なオブジェクトの生成プロセスを段階的に行います。F# では、パイプライン演算子（`|>`）またはコンピュテーション式で表現します。

## パターンの構造

```plantuml
@startuml
title Builder（F# 版）

class "Computer" as C {
  + Cpu: string
  + Ram: int
  + Storage: string
  + Gpu: string option
  + Os: string option
}

class <<module>> "Builder" as B {
  + defaultComputer: Computer
  + withCpu(cpu, computer)
  + withRam(ram, computer)
  + withStorage(storage, computer)
  + withGpu(gpu, computer)
  + withOs(os, computer)
  + describe(computer)
}

class "ComputerBuilder" as CB {
  + cpu(computer, value)
  + ram(computer, value)
  + storage(computer, value)
  + gpu(computer, value)
  + os(computer, value)
}

B --> C : builds
CB --> C : builds via CE
@enduml
```

## TDD で作る

### Red: パイプライン版のテスト

```fsharp
[<Fact>]
let ``パイプラインでコンピュータを構築できる`` () =
    let pc =
        defaultComputer
        |> withCpu "Intel Core i9"
        |> withRam 32
        |> withStorage "1TB SSD"
    Assert.Equal("Intel Core i9", pc.Cpu)
    Assert.Equal(32, pc.Ram)
```

### Green: パイプライン版の実装

```fsharp
let defaultComputer = { Cpu = "Unknown"; Ram = 0; Storage = "None"; Gpu = None; Os = None }
let withCpu cpu computer = { computer with Cpu = cpu }
let withRam ram computer = { computer with Ram = ram }
```

### Red: コンピュテーション式版のテスト

```fsharp
[<Fact>]
let ``コンピュテーション式でコンピュータを構築できる`` () =
    let pc = computer {
        cpu "Intel Core i7"
        ram 16
        storage "512GB SSD"
    }
    Assert.Equal("Intel Core i7", pc.Cpu)
```

### Green: コンピュテーション式の実装

```fsharp
type ComputerBuilder() =
    member _.Yield(_) = defaultComputer
    [<CustomOperation("cpu")>]
    member _.Cpu(computer, cpu) = { computer with Cpu = cpu }
```

## OOP 版（C#）との比較

### C# 版

```csharp
class ComputerBuilder {
    private Computer computer = new();
    public ComputerBuilder WithCpu(string cpu) { computer.Cpu = cpu; return this; }
    public Computer Build() => computer;
}
```

### F# 版の優位性

- パイプラインで自然なデータフロー
- `with` 式でイミュータブルな更新
- コンピュテーション式で DSL ライクな構文

## まとめ

- Builder はパイプライン演算子（`|>`）で直感的に表現できる
- コンピュテーション式でさらに DSL ライクな構文が実現できる
- どちらもイミュータブルなデータ更新に基づく
