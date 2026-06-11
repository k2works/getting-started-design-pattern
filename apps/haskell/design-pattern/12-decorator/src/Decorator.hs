module Decorator
  ( Writer
  , applyDecorators
  , baseWriter
  , decorated
  , withChecksum
  , withLineNumber
  , withTimestamp
  ) where

type Writer = [String] -> [String]

baseWriter :: Writer
baseWriter = id

withTimestamp :: String -> Writer -> Writer
withTimestamp timestamp base =
  map (\line -> "[" ++ timestamp ++ "] " ++ line) . base

withLineNumber :: Writer -> Writer
withLineNumber base =
  zipWith (\number line -> show number ++ ": " ++ line) [1 :: Int ..] . base

withChecksum :: Writer -> Writer
withChecksum base lines0 =
  let rendered = base lines0
      checksum = sum (map length rendered)
   in rendered ++ ["[checksum:" ++ show checksum ++ "]"]

applyDecorators :: [Writer -> Writer] -> Writer -> Writer
applyDecorators decorators base = foldr ($) base decorators

decorated :: Writer
decorated = withChecksum . withLineNumber . withTimestamp "2024-01-01" $ baseWriter
