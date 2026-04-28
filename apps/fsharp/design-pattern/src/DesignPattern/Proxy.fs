namespace DesignPattern.Proxy

/// Proxy パターン
/// F# では Lazy<T> で仮想プロキシ、関数ラッパーで保護プロキシを表現する。
module Proxy =

    // --- 仮想プロキシ（遅延初期化） ---

    /// 重い計算結果を遅延評価で保持する仮想プロキシ
    type VirtualProxy<'T> =
        { Value: Lazy<'T>; Description: string }

    /// 仮想プロキシを作成する
    let createVirtualProxy (description: string) (factory: unit -> 'T) : VirtualProxy<'T> =
        { Value = lazy (factory ())
          Description = description }

    /// 仮想プロキシから値を取得する（初回アクセス時に生成）
    let getValue (proxy: VirtualProxy<'T>) : 'T = proxy.Value.Value

    /// 仮想プロキシが生成済みかどうかを確認する
    let isValueCreated (proxy: VirtualProxy<'T>) : bool = proxy.Value.IsValueCreated

    // --- 保護プロキシ（アクセス制御） ---

    /// ロール
    type Role =
        | Admin
        | User
        | Guest

    /// 保護プロキシ：ロールに基づいてアクセスを制御する
    let protectionProxy
        (requiredRole: Role)
        (action: string -> Result<string, string>)
        (role: Role)
        (input: string)
        : Result<string, string> =
        let roleLevel =
            function
            | Admin -> 3
            | User -> 2
            | Guest -> 1

        if roleLevel role >= roleLevel requiredRole then
            action input
        else
            Error(sprintf "アクセス拒否: %A 権限が必要です" requiredRole)

    // --- ログプロキシ ---

    /// 関数呼び出しをログに記録するプロキシ
    let loggingProxy (log: string list ref) (name: string) (f: 'T -> 'U) (input: 'T) : 'U =
        log.Value <- log.Value @ [ sprintf "%s が呼び出されました" name ]
        let result = f input
        log.Value <- log.Value @ [ sprintf "%s が完了しました" name ]
        result
