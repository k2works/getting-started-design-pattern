namespace DesignPattern.Strategy

/// Strategy パターン
/// F# では関数が第一級値なので、インターフェースは不要。
/// 戦略を関数として渡すだけで実現できる。
module Strategy =

    /// フォーマット戦略の型エイリアス
    type FormatStrategy = string -> string

    /// レポートのコンテキスト
    type Report = { Title: string; Items: string list }

    /// レポートを指定された戦略でフォーマットする
    let formatReport (strategy: FormatStrategy) (report: Report) : string =
        let header = strategy report.Title
        let body = report.Items |> List.map strategy |> String.concat "\n"
        sprintf "%s\n%s" header body

    /// HTML 戦略
    let htmlStrategy: FormatStrategy = fun text -> sprintf "<p>%s</p>" text

    /// プレーンテキスト戦略
    let plainTextStrategy: FormatStrategy = fun text -> sprintf "** %s **" text

    /// Markdown 戦略
    let markdownStrategy: FormatStrategy = fun text -> sprintf "- %s" text
