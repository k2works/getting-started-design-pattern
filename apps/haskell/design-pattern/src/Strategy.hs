-- | Strategy パターン
-- 高階関数でアルゴリズムを差し替える。
-- Haskell では関数が第一級値なので、Strategy は自然な設計。
module Strategy
  ( Formatter
  , Report(..)
  , formatReport
  , htmlFormatter
  , plainTextFormatter
  , markdownFormatter
  ) where

-- | フォーマット戦略: タイトルと行リストを受け取り文字列を返す関数
type Formatter = String -> [String] -> String

-- | レポートデータ
data Report = Report
  { reportTitle :: String
  , reportBody  :: [String]
  } deriving (Show, Eq)

-- | レポートをフォーマットする（戦略を注入）
formatReport :: Formatter -> Report -> String
formatReport fmt r = fmt (reportTitle r) (reportBody r)

-- | HTML 戦略
htmlFormatter :: Formatter
htmlFormatter title body =
  "<html><head><title>" ++ title ++ "</title></head><body>\n"
  ++ concatMap (\l -> "  <p>" ++ l ++ "</p>\n") body
  ++ "</body></html>\n"

-- | プレーンテキスト戦略
plainTextFormatter :: Formatter
plainTextFormatter title body =
  "***** " ++ title ++ " *****\n"
  ++ concatMap (\l -> l ++ "\n") body

-- | Markdown 戦略
markdownFormatter :: Formatter
markdownFormatter title body =
  "# " ++ title ++ "\n\n"
  ++ concatMap (\l -> "- " ++ l ++ "\n") body
