-- | Decorator パターン
-- 関数合成 (.) で振る舞いを動的に追加する。
-- Haskell では関数合成こそが自然なデコレータ。
module Decorator
  ( Writer
  , baseWriter
  , withTimestamp
  , withLineNumber
  , withChecksum
  , decorated
  , applyDecorators
  ) where

-- | Writer: 行リストを受け取り、装飾された行リストを返す
type Writer = [String] -> [String]

-- | 基本の Writer: そのまま返す
baseWriter :: Writer
baseWriter = id

-- | タイムスタンプを付与するデコレータ
withTimestamp :: String -> Writer -> Writer
withTimestamp ts base = map (\l -> "[" ++ ts ++ "] " ++ l) . base

-- | 行番号を付与するデコレータ
withLineNumber :: Writer -> Writer
withLineNumber base = zipWith (\n l -> show n ++ ": " ++ l) [1 :: Int ..] . base

-- | チェックサム（文字数）を末尾に追加するデコレータ
withChecksum :: Writer -> Writer
withChecksum base = \ls ->
  let result = base ls
      total  = sum (map length result)
  in result ++ ["[checksum: " ++ show total ++ "]"]

-- | 複数のデコレータを適用した Writer
decorated :: Writer
decorated = withChecksum . withLineNumber . withTimestamp "2024-01-01" $ baseWriter

-- | デコレータのリストを順に適用
applyDecorators :: [Writer -> Writer] -> Writer -> Writer
applyDecorators decorators base = foldr ($) base decorators
