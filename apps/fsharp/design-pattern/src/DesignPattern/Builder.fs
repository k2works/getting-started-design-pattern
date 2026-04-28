namespace DesignPattern.Builder

/// Builder パターン
/// F# ではコンピュテーション式やパイプライン（|>）で表現する。
module Builder =

    // --- パイプライン Builder ---

    /// コンピュータの構成
    type Computer =
        { Cpu: string
          Ram: int
          Storage: string
          Gpu: string option
          Os: string option }

    /// デフォルトのコンピュータ構成
    let defaultComputer: Computer =
        { Cpu = "Unknown"
          Ram = 0
          Storage = "None"
          Gpu = None
          Os = None }

    /// パイプラインで使えるビルダー関数群
    let withCpu cpu computer = { computer with Cpu = cpu }
    let withRam ram computer = { computer with Ram = ram }
    let withStorage storage computer = { computer with Storage = storage }
    let withGpu gpu computer = { computer with Gpu = Some gpu }
    let withOs os computer = { computer with Os = Some os }

    /// コンピュータの説明を生成する
    let describe (computer: Computer) : string =
        let gpu = computer.Gpu |> Option.defaultValue "なし"
        let os = computer.Os |> Option.defaultValue "なし"
        sprintf "CPU: %s, RAM: %dGB, Storage: %s, GPU: %s, OS: %s" computer.Cpu computer.Ram computer.Storage gpu os

    // --- コンピュテーション式 Builder ---

    type ComputerBuilder() =
        member _.Yield(_) = defaultComputer

        [<CustomOperation("cpu")>]
        member _.Cpu(computer, cpu) = { computer with Cpu = cpu }

        [<CustomOperation("ram")>]
        member _.Ram(computer, ram) = { computer with Ram = ram }

        [<CustomOperation("storage")>]
        member _.Storage(computer, storage) = { computer with Storage = storage }

        [<CustomOperation("gpu")>]
        member _.Gpu(computer, gpu) = { computer with Gpu = Some gpu }

        [<CustomOperation("os")>]
        member _.Os(computer, os) = { computer with Os = Some os }

    /// コンピュテーション式のインスタンス
    let computer = ComputerBuilder()
