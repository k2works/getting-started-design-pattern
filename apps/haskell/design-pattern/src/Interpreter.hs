-- | Interpreter パターン
-- ADT で AST を定義し、再帰的に評価する。
-- Haskell の ADT とパターンマッチは Interpreter パターンと完璧に合致する。
module Interpreter
  ( Expr(..)
  , eval
  , display
  , simplify
  , BoolExpr(..)
  , evalBool
  , displayBool
  ) where

-- | 算術式の AST
data Expr
  = Lit Double           -- ^ リテラル
  | Add Expr Expr        -- ^ 加算
  | Sub Expr Expr        -- ^ 減算
  | Mul Expr Expr        -- ^ 乗算
  | Div Expr Expr        -- ^ 除算
  | Neg Expr             -- ^ 符号反転
  | Var String           -- ^ 変数（未評価）
  deriving (Show, Eq)

-- | 式を評価する（変数は 0 として扱う）
eval :: [(String, Double)] -> Expr -> Double
eval _   (Lit n)     = n
eval env (Add a b)   = eval env a + eval env b
eval env (Sub a b)   = eval env a - eval env b
eval env (Mul a b)   = eval env a * eval env b
eval env (Div a b)   = let bv = eval env b
                       in if bv == 0 then 0 else eval env a / bv
eval env (Neg a)     = negate (eval env a)
eval env (Var name)  = case lookup name env of
                         Just v  -> v
                         Nothing -> 0

-- | 式を文字列で表示
display :: Expr -> String
display (Lit n)   = show n
display (Add a b) = "(" ++ display a ++ " + " ++ display b ++ ")"
display (Sub a b) = "(" ++ display a ++ " - " ++ display b ++ ")"
display (Mul a b) = "(" ++ display a ++ " * " ++ display b ++ ")"
display (Div a b) = "(" ++ display a ++ " / " ++ display b ++ ")"
display (Neg a)   = "(-" ++ display a ++ ")"
display (Var name) = name

-- | 式を単純化する
simplify :: Expr -> Expr
simplify (Add a (Lit 0)) = simplify a
simplify (Add (Lit 0) b) = simplify b
simplify (Mul _ (Lit 0)) = Lit 0
simplify (Mul (Lit 0) _) = Lit 0
simplify (Mul a (Lit 1)) = simplify a
simplify (Mul (Lit 1) b) = simplify b
simplify (Neg (Neg a))   = simplify a
simplify (Add a b)       = Add (simplify a) (simplify b)
simplify (Sub a b)       = Sub (simplify a) (simplify b)
simplify (Mul a b)       = Mul (simplify a) (simplify b)
simplify (Div a b)       = Div (simplify a) (simplify b)
simplify (Neg a)         = Neg (simplify a)
simplify other           = other

-- | ブール式の AST
data BoolExpr
  = BoolLit Bool
  | And BoolExpr BoolExpr
  | Or  BoolExpr BoolExpr
  | Not BoolExpr
  deriving (Show, Eq)

-- | ブール式を評価
evalBool :: BoolExpr -> Bool
evalBool (BoolLit b) = b
evalBool (And a b)   = evalBool a && evalBool b
evalBool (Or a b)    = evalBool a || evalBool b
evalBool (Not a)     = not (evalBool a)

-- | ブール式を表示
displayBool :: BoolExpr -> String
displayBool (BoolLit True)  = "true"
displayBool (BoolLit False) = "false"
displayBool (And a b)       = "(" ++ displayBool a ++ " AND " ++ displayBool b ++ ")"
displayBool (Or a b)        = "(" ++ displayBool a ++ " OR " ++ displayBool b ++ ")"
displayBool (Not a)         = "NOT(" ++ displayBool a ++ ")"
