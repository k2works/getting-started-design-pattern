module TemplateMethod
  ( ReportFormat (..)
  , generateReport
  , htmlFormat
  , plainTextFormat
  ) where

data ReportFormat = ReportFormat
  { outputStart :: String -> String
  , outputLine :: String -> String
  , outputEnd :: String -> String
  }

generateReport :: ReportFormat -> String -> [String] -> String
generateReport format title body =
  outputStart format title
    ++ concatMap (outputLine format) body
    ++ outputEnd format title

htmlFormat :: ReportFormat
htmlFormat =
  ReportFormat
    { outputStart = \title -> "<html>\n<head><title>" ++ title ++ "</title></head>\n<body>\n"
    , outputLine = \line -> "<p>" ++ line ++ "</p>\n"
    , outputEnd = \_ -> "</body>\n</html>\n"
    }

plainTextFormat :: ReportFormat
plainTextFormat =
  ReportFormat
    { outputStart = \title -> "**** " ++ title ++ " ****\n\n"
    , outputLine = \line -> line ++ "\n"
    , outputEnd = \_ -> ""
    }
