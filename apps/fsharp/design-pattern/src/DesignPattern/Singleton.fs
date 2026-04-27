namespace DesignPattern.Singleton

/// Singleton パターン
/// F# ではモジュールレベルの let 束縛が自然にシングルトンになる。
/// モジュール自体がシングルトンの役割を果たす。
module Singleton =

    /// アプリケーション設定（モジュールレベルの値はシングルトン）
    type AppConfig =
        { DatabaseUrl: string
          MaxConnections: int
          LogLevel: string }

    /// デフォルト設定（モジュールレベルで一度だけ初期化される）
    let defaultConfig : AppConfig =
        { DatabaseUrl = "localhost:5432"
          MaxConnections = 10
          LogLevel = "INFO" }

    /// 設定の変更（イミュータブルなので新しいインスタンスを返す）
    let withDatabaseUrl url config =
        { config with DatabaseUrl = url }

    let withMaxConnections count config =
        { config with MaxConnections = count }

    let withLogLevel level config =
        { config with LogLevel = level }

    // --- スレッドセーフなシングルトン（Lazy を使用） ---

    /// カウンター（Lazy でスレッドセーフに初期化）
    type Counter private () =
        static let instance = lazy (Counter())
        let mutable count = 0

        static member Instance = instance.Value

        member _.Increment() =
            count <- count + 1
            count

        member _.Value = count

        member _.Reset() =
            count <- 0
