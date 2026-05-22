module Observer
  ( Event (..)
  , PureSubject (..)
  , notify
  , changeSalary
  ) where

data Event = SalaryChanged String Double Double

data PureSubject = PureSubject
  { psName :: String
  , psSalary :: Double
  , psLog :: [String]
  }

notify :: PureSubject -> String -> PureSubject
notify subject message =
  subject { psLog = psLog subject ++ [message] }

renderEvent :: Event -> String
renderEvent (SalaryChanged name oldSalary newSalary) =
  name
    ++ " の給与が "
    ++ show oldSalary
    ++ " から "
    ++ show newSalary
    ++ " に変更されました"

changeSalary :: Double -> PureSubject -> PureSubject
changeSalary newSalary subject =
  let event = SalaryChanged (psName subject) (psSalary subject) newSalary
   in notify (subject { psSalary = newSalary }) (renderEvent event)
