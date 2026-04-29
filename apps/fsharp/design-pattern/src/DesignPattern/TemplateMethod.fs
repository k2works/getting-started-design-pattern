namespace DesignPattern.TemplateMethod

/// Template Method パターン
/// F# では高階関数とレコード型で表現する。
/// 抽象クラスの代わりに、関数フィールドを持つレコード型を使う。
module TemplateMethod =

    /// レポートの出力形式を定義するレコード型
    type ReportFormat =
        { OutputStart: string -> string
          OutputHead: string -> string
          OutputBody: string list -> string list
          OutputEnd: string -> string }

    /// レポートを生成するテンプレートメソッド
    let generateReport (format: ReportFormat) (title: string) (items: string list) : string list =
        let startLine = format.OutputStart title
        let headLine = format.OutputHead title
        let bodyLines = format.OutputBody items
        let endLine = format.OutputEnd title
        [ startLine; headLine ] @ bodyLines @ [ endLine ]

    /// HTML フォーマット
    let htmlFormat: ReportFormat =
        { OutputStart = fun _ -> "<html>"
          OutputHead = fun title -> sprintf "  <head><title>%s</title></head>" title
          OutputBody = fun items -> items |> List.map (fun item -> sprintf "  <body>%s</body>" item)
          OutputEnd = fun _ -> "</html>" }

    /// プレーンテキストフォーマット
    let plainTextFormat: ReportFormat =
        { OutputStart = fun _ -> "***** Start *****"
          OutputHead = fun title -> title
          OutputBody = fun items -> items |> List.map id
          OutputEnd = fun _ -> "***** End *****" }
