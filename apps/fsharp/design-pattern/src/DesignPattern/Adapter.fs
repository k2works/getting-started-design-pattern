namespace DesignPattern.Adapter

/// Adapter パターン
/// F# ではレコード型とアダプター関数で表現する。
/// クラスの継承やインターフェースの実装は不要。
module Adapter =

    /// 統一されたレンダラーのインターフェース（レコード型）
    type Renderer = { Render: string -> string }

    /// 旧式の HTML レンダラー（適応されるべき対象）
    type LegacyHtmlRenderer = { RenderHtml: string -> string }

    let createLegacyHtmlRenderer () : LegacyHtmlRenderer =
        { RenderHtml = fun content -> sprintf "<html><body>%s</body></html>" content }

    /// 旧式の JSON レンダラー（適応されるべき対象）
    type LegacyJsonRenderer = { RenderJson: string -> string }

    let createLegacyJsonRenderer () : LegacyJsonRenderer =
        { RenderJson = fun content -> sprintf """{"content": "%s"}""" content }

    /// LegacyHtmlRenderer を Renderer に適応するアダプター関数
    let adaptHtmlRenderer (legacy: LegacyHtmlRenderer) : Renderer = { Render = legacy.RenderHtml }

    /// LegacyJsonRenderer を Renderer に適応するアダプター関数
    let adaptJsonRenderer (legacy: LegacyJsonRenderer) : Renderer = { Render = legacy.RenderJson }

    /// 統一されたインターフェースでレンダリングする
    let renderContent (renderer: Renderer) (content: string) : string = renderer.Render content
