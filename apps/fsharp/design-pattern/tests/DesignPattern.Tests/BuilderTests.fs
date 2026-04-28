module DesignPattern.Tests.BuilderTests

open Xunit
open DesignPattern.Builder.Builder

[<Fact>]
let ``パイプラインでコンピュータを構築できる`` () =
    let pc =
        defaultComputer
        |> withCpu "Intel Core i9"
        |> withRam 32
        |> withStorage "1TB SSD"

    Assert.Equal("Intel Core i9", pc.Cpu)
    Assert.Equal(32, pc.Ram)
    Assert.Equal("1TB SSD", pc.Storage)
    Assert.Equal(None, pc.Gpu)

[<Fact>]
let ``オプション項目を設定できる`` () =
    let pc =
        defaultComputer
        |> withCpu "AMD Ryzen 9"
        |> withRam 64
        |> withStorage "2TB NVMe"
        |> withGpu "NVIDIA RTX 4090"
        |> withOs "Linux"

    Assert.Equal(Some "NVIDIA RTX 4090", pc.Gpu)
    Assert.Equal(Some "Linux", pc.Os)

[<Fact>]
let ``コンピュータの説明を生成できる`` () =
    let pc =
        defaultComputer
        |> withCpu "M3 Max"
        |> withRam 36
        |> withStorage "1TB SSD"
        |> withGpu "Apple GPU"
        |> withOs "macOS"

    let desc = describe pc
    Assert.Contains("M3 Max", desc)
    Assert.Contains("36GB", desc)
    Assert.Contains("Apple GPU", desc)

[<Fact>]
let ``コンピュテーション式でコンピュータを構築できる`` () =
    let pc =
        computer {
            cpu "Intel Core i7"
            ram 16
            storage "512GB SSD"
            gpu "RTX 3060"
            os "Windows 11"
        }

    Assert.Equal("Intel Core i7", pc.Cpu)
    Assert.Equal(16, pc.Ram)
    Assert.Equal(Some "RTX 3060", pc.Gpu)
    Assert.Equal(Some "Windows 11", pc.Os)

[<Fact>]
let ``デフォルト値が適用される`` () =
    let desc = describe defaultComputer
    Assert.Contains("Unknown", desc)
    Assert.Contains("0GB", desc)
    Assert.Contains("なし", desc)
