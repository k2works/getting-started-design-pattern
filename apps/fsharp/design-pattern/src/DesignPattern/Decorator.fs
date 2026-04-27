namespace DesignPattern.Decorator

/// Decorator パターン
/// F# では関数合成（>>）でデコレーターチェーンを表現する。
/// クラスのラッピングの代わりに、関数のパイプラインを使う。
module Decorator =

    /// Writer の型エイリアス：文字列を受け取り文字列を返す関数
    type Writer = string -> string

    /// 基本の Writer
    let baseWriter : Writer =
        fun text -> text

    /// 行番号を追加するデコレーター
    let withLineNumbers : Writer -> Writer =
        fun writer text ->
            let lines = (writer text).Split('\n')
            lines
            |> Array.mapi (fun i line -> sprintf "%d: %s" (i + 1) line)
            |> String.concat "\n"

    /// タイムスタンプを追加するデコレーター
    let withTimestamp (timestamp: string) : Writer -> Writer =
        fun writer text ->
            sprintf "[%s] %s" timestamp (writer text)

    /// チェックサム（文字数）を追加するデコレーター
    let withChecksum : Writer -> Writer =
        fun writer text ->
            let result = writer text
            sprintf "%s [checksum: %d]" result result.Length

    /// 大文字に変換するデコレーター
    let withUpperCase : Writer -> Writer =
        fun writer text ->
            (writer text).ToUpper()

    /// 括弧で囲むデコレーター
    let withBrackets : Writer -> Writer =
        fun writer text ->
            sprintf "[ %s ]" (writer text)

    /// 複数のデコレーターを合成する
    let compose (decorators: (Writer -> Writer) list) (writer: Writer) : Writer =
        decorators |> List.fold (fun w decorator -> decorator w) writer
