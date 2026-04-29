# Phase 2 ふりかえり（IT-6〜10: C# / F# / PHP / Go / Rust）

## サマリー

| IT | 言語 | SP | テスト | 特徴 |
|----|------|-----|--------|------|
| 6 | C# | 13 | 84 | LINQ, event/delegate, Lazy<T>, record |
| 7 | F# | 16 | 75 | 判別共用体, 高階関数, パイプライン, CE |
| 8 | PHP | 13 | 81 | SplObjectStorage, IteratorAggregate, Traits |
| 9 | Go | 13 | ~90 | 構造的型付け, struct 埋め込み, sync.Once |
| 10 | Rust | 13 | 61 | 所有権, トレイト, 列挙型, OnceLock |
| **合計** | | **68** | **~391** | |

## KPT

### Keep
- 1 エージェント 1 言語で全ファイル一括作成が安定
- .gitignore を事前に用意（C# の bin/obj 問題から学習）
- 各言語の特性を活かしたイディオムを採用

### Problem
- F# の記事ファイル名が標準と異なる（02 が template-method）
- F# の PlantUML で判別共用体の `|` がエラー（修正済み）
- Phase 2 のふりかえり・報告書を個別に作成せず一括にした

### Try
- Phase 3 では関数型言語の「パターンが不要になる」視点を統一的に表現
- 統合解説（IT-15）で 14 言語の横断比較を充実させる
