-- | Template Method パターン
-- レコードに関数フィールドを持たせ、アルゴリズムの骨格を固定しつつ
-- 各ステップを差し替え可能にする。
module TemplateMethod
  ( ReportFormat(..)
  , generateReport
  , htmlFormat
  , plainTextFormat
  ) where

-- | レポートの各ステップを関数で表現したレコード
data ReportFormat = ReportFormat
  { outputStart :: String -> String
  , outputLine  :: String -> String
  , outputEnd   :: String -> String
  }

-- | テンプレートメソッド: 骨格を固定し、各ステップを ReportFormat に委譲する
generateReport :: ReportFormat -> String -> [String] -> String
generateReport fmt title body =
  outputStart fmt title
  ++ concatMap (outputLine fmt) body
  ++ outputEnd fmt title

-- | HTML 形式
htmlFormat :: ReportFormat
htmlFormat = ReportFormat
  { outputStart = \t -> "<html><head><title>" ++ t ++ "</title></head><body>\n"
  , outputLine  = \l -> "  <p>" ++ l ++ "</p>\n"
  , outputEnd   = \_ -> "</body></html>\n"
  }

-- | プレーンテキスト形式
plainTextFormat :: ReportFormat
plainTextFormat = ReportFormat
  { outputStart = \t -> "***** " ++ t ++ " *****\n"
  , outputLine  = \l -> l ++ "\n"
  , outputEnd   = \_ -> ""
  }
