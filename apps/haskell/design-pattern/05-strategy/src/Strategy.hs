module Strategy
  ( Formatter
  , Report (..)
  , formatReport
  , htmlFormatter
  , plainTextFormatter
  , markdownFormatter
  ) where

data Report = Report
  { reportTitle :: String
  , reportBody :: [String]
  }

type Formatter = String -> [String] -> String

formatReport :: Formatter -> Report -> String
formatReport formatter report =
  formatter (reportTitle report) (reportBody report)

renderLines :: (String -> String) -> [String] -> String
renderLines renderLine = concatMap renderLine

htmlFormatter :: Formatter
htmlFormatter title body =
  "<html>\n<head><title>" ++ title ++ "</title></head>\n<body>\n"
    ++ renderLines (\line -> "<p>" ++ line ++ "</p>\n") body
    ++ "</body>\n</html>\n"

plainTextFormatter :: Formatter
plainTextFormatter title body =
  "**** " ++ title ++ " ****\n\n"
    ++ renderLines (\line -> line ++ "\n") body

markdownFormatter :: Formatter
markdownFormatter title body =
  "# " ++ title ++ "\n\n"
    ++ renderLines (\line -> "- " ++ line ++ "\n") body
