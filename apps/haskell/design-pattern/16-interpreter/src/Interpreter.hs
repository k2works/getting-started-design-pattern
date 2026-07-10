module Interpreter
  ( BoolExpr (..)
  , Expr (..)
  , display
  , displayBool
  , eval
  , evalBool
  , simplify
  ) where

data Expr
  = Lit Double
  | Add Expr Expr
  | Sub Expr Expr
  | Mul Expr Expr
  | Div Expr Expr
  | Neg Expr
  | Var String
  deriving (Eq, Show)

eval :: [(String, Double)] -> Expr -> Double
eval _ (Lit number) = number
eval env (Add left right) = eval env left + eval env right
eval env (Sub left right) = eval env left - eval env right
eval env (Mul left right) = eval env left * eval env right
eval env (Div left right) =
  let divisor = eval env right
   in if divisor == 0
        then 0
        else eval env left / divisor
eval env (Neg expr) = negate (eval env expr)
eval env (Var name) =
  case lookup name env of
    Just value -> value
    Nothing -> 0

display :: Expr -> String
display (Lit number) = show number
display (Add left right) = "(" ++ display left ++ " + " ++ display right ++ ")"
display (Sub left right) = "(" ++ display left ++ " - " ++ display right ++ ")"
display (Mul left right) = "(" ++ display left ++ " * " ++ display right ++ ")"
display (Div left right) = "(" ++ display left ++ " / " ++ display right ++ ")"
display (Neg expr) = "-(" ++ display expr ++ ")"
display (Var name) = name

simplify :: Expr -> Expr
simplify (Add left right) =
  case (simplify left, simplify right) of
    (expr, Lit 0.0) -> expr
    (Lit 0.0, expr) -> expr
    (left', right') -> Add left' right'
simplify (Sub left right) =
  Sub (simplify left) (simplify right)
simplify (Mul left right) =
  case (simplify left, simplify right) of
    (_, Lit 0.0) -> Lit 0.0
    (Lit 0.0, _) -> Lit 0.0
    (expr, Lit 1.0) -> expr
    (Lit 1.0, expr) -> expr
    (left', right') -> Mul left' right'
simplify (Div left right) =
  Div (simplify left) (simplify right)
simplify (Neg expr) =
  case simplify expr of
    Neg inner -> simplify inner
    simplified -> Neg simplified
simplify expr = expr

data BoolExpr
  = BoolLit Bool
  | And BoolExpr BoolExpr
  | Or BoolExpr BoolExpr
  | Not BoolExpr
  deriving (Eq, Show)

evalBool :: BoolExpr -> Bool
evalBool (BoolLit value) = value
evalBool (And left right) = evalBool left && evalBool right
evalBool (Or left right) = evalBool left || evalBool right
evalBool (Not expr) = not (evalBool expr)

displayBool :: BoolExpr -> String
displayBool (BoolLit True) = "true"
displayBool (BoolLit False) = "false"
displayBool (And left right) = "(" ++ displayBool left ++ " AND " ++ displayBool right ++ ")"
displayBool (Or left right) = "(" ++ displayBool left ++ " OR " ++ displayBool right ++ ")"
displayBool (Not expr) = "NOT(" ++ displayBool expr ++ ")"
