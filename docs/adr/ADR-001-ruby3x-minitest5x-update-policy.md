# ADR-001: Ruby 3.x / minitest 5.x への一次資料の更新方針

## ステータス

承認

## コンテキスト

一次資料 `docs/reference/ruby-design-pattern/` は Ruby 2.x 時代に作成されたコードで、以下の問題がある。

- `require './xxx'` の相対パスが Ruby 3.x のデフォルト `$LOAD_PATH` で動かないケースがある
- minitest の spec スタイル（`must_equal`、`must_output`）は将来的に非推奨
- `frozen_string_literal` プラグマが未使用

## 決定

本シリーズの `apps/ruby/design-pattern/` に配置する実装コードは、以下の方針で一次資料を更新する。

1. **Ruby 3.3 互換**: `require_relative` を使用し、`frozen_string_literal: true` を全ファイルに付与する
2. **minitest assert スタイル**: spec スタイル（`must_equal` 等）ではなく、assert スタイル（`assert_equal` 等）を使用する
3. **モジュール名前空間**: パターン間でクラス名が衝突しないよう、各パターンを module で包む（例: `TemplateMethod::Report`、`Strategy::Report`）
4. **テスタビリティ**: ファイル I/O を伴うテストは `/tmp/` 配下の一時ファイルを使用し、`ensure` で後片付けする

## 影響

- 一次資料のコードと本シリーズのコードは 1:1 対応ではなく、Ruby 3.x 向けに近代化されている
- 読者が一次資料を参照する際は、本シリーズとの差異を認識する必要がある
- 後続 13 言語への翻訳元は本シリーズの Ruby コード（一次資料ではなく）とする
