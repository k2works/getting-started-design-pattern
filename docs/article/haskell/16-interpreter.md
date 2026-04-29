# 第 16 章: Interpreter

## はじめに

算術式やブール式を解析し、評価したいとします。式は変数を含むことができ、環境（変数束縛）に基づいて評価されます。

**Interpreter パターン**は、言語の文法を定義し、その文法に従って文を解釈するパターンです。

---

## パターンの構造

```plantuml
@startuml
title Interpreter パターン（Haskell 版）

class Expr {
  <<ADT>>
}

class Lit {
  + Double
}

class Add {
  + Expr
  + Expr
}

class Sub {
  + Expr
  + Expr
}

class Mul {
  + Expr
  + Expr
}

class Div {
  + Expr
  + Expr
}

class Neg {
  + Expr
}

class Var {
  + String
}

Expr <|-- Lit
Expr <|-- Add
Expr <|-- Sub
Expr <|-- Mul
Expr <|-- Div
Expr <|-- Neg
Expr <|-- Var

class "eval" <<function>> {
  + [(String, Double)] -> Expr -> Double
}

class "display" <<function>> {
  + Expr -> String
}

class "simplify" <<function>> {
  + Expr -> Expr
}

"eval" --> Expr
"display" --> Expr
"simplify" --> Expr
@enduml
```

---

## Haskell イディオム: ADT + パターンマッチ

Haskell の ADT とパターンマッチは Interpreter パターンと完璧に合致します。AST を ADT で定義し、パターンマッチで再帰的に評価します。

```haskell
data Expr
  = Lit Double
  | Add Expr Expr
  | Sub Expr Expr
  | Mul Expr Expr
  | Div Expr Expr
  | Neg Expr
  | Var String

eval :: [(String, Double)] -> Expr -> Double
eval _   (Lit n)     = n
eval env (Add a b)   = eval env a + eval env b
eval env (Var name)  = case lookup name env of
                         Just v  -> v
                         Nothing -> 0
```

---

## TDD で作る

### Red

```haskell
testComplex :: Test
testComplex = TestCase $ do
  let expr = Mul (Add (Lit 2.0) (Lit 3.0)) (Lit 4.0)
  assertEqual "複合式" 20.0 (eval [] expr)
```

### Green

```haskell
eval :: [(String, Double)] -> Expr -> Double
eval _   (Lit n)     = n
eval env (Add a b)   = eval env a + eval env b
eval env (Sub a b)   = eval env a - eval env b
eval env (Mul a b)   = eval env a * eval env b
eval env (Div a b)   = eval env a / eval env b
eval env (Neg a)     = negate (eval env a)
eval env (Var name)  = case lookup name env of
  Just v  -> v
  Nothing -> 0

display :: Expr -> String
display (Lit n)     = show n
display (Add a b)   = "(" ++ display a ++ " + " ++ display b ++ ")"
display (Sub a b)   = "(" ++ display a ++ " - " ++ display b ++ ")"
display (Mul a b)   = "(" ++ display a ++ " * " ++ display b ++ ")"
display (Div a b)   = "(" ++ display a ++ " / " ++ display b ++ ")"
display (Neg a)     = "-(" ++ display a ++ ")"
display (Var name)  = name
```

まずは評価と表示をそろえ、AST の各コンストラクタに対する再帰処理を一通り実装します。

### Refactor: 式の単純化

`simplify` は代数的な恒等規則を適用して式を単純化します。実装ではすべての規則を網羅しています。

```haskell
simplify :: Expr -> Expr
simplify (Add a (Lit 0)) = simplify a    -- x + 0 = x
simplify (Add (Lit 0) b) = simplify b    -- 0 + x = x
simplify (Mul _ (Lit 0)) = Lit 0          -- x * 0 = 0
simplify (Mul (Lit 0) _) = Lit 0          -- 0 * x = 0
simplify (Mul a (Lit 1)) = simplify a    -- x * 1 = x
simplify (Mul (Lit 1) b) = simplify b    -- 1 * x = x
simplify (Neg (Neg a))   = simplify a    -- --x = x
-- その他の式は再帰的に部分式を単純化
simplify (Add a b) = Add (simplify a) (simplify b)
simplify (Sub a b) = Sub (simplify a) (simplify b)
simplify (Mul a b) = Mul (simplify a) (simplify b)
simplify (Div a b) = Div (simplify a) (simplify b)
simplify (Neg a)   = Neg (simplify a)
simplify other     = other  -- Lit, Var はそのまま
```

## Var: 変数の取り扱い

`Var` コンストラクタは変数を表します。`eval` は環境（変数名と値のペアリスト）を受け取り、変数を解決します。環境に存在しない変数は `0` として評価されます。

```haskell
eval env (Var name) = case lookup name env of
                        Just v  -> v
                        Nothing -> 0
```

```haskell
-- 使用例
let expr = Add (Var "x") (Mul (Var "y") (Lit 3.0))
    env  = [("x", 10.0), ("y", 5.0)]
-- eval env expr == 25.0（10 + 5 * 3）

-- 未定義の変数は 0
-- eval [] (Var "z") == 0.0
```

`display` での変数は変数名をそのまま表示します。

```haskell
display (Var name) = name
-- display (Add (Var "x") (Lit 1.0)) == "(x + 1.0)"
```

## ゼロ除算の取り扱い

`Div` の評価時、除数が 0 の場合はエラーを発生させず `0` を返します。これにより安全な評価が保証されます。

```haskell
eval env (Div a b) = let bv = eval env b
                     in if bv == 0 then 0 else eval env a / bv
```

```haskell
-- 使用例
-- eval [] (Div (Lit 10.0) (Lit 0.0)) == 0.0
-- eval [] (Div (Lit 10.0) (Lit 2.0)) == 5.0
```

---

## ブール式インタプリタ

同じアプローチでブール式も実装できます。

```haskell
data BoolExpr
  = BoolLit Bool
  | And BoolExpr BoolExpr
  | Or  BoolExpr BoolExpr
  | Not BoolExpr

evalBool :: BoolExpr -> Bool
evalBool (BoolLit b) = b
evalBool (And a b)   = evalBool a && evalBool b
```

### displayBool: ブール式の表示

`displayBool` はブール式を人間が読める形式で表示します。

```haskell
displayBool :: BoolExpr -> String
displayBool (BoolLit True)  = "true"
displayBool (BoolLit False) = "false"
displayBool (And a b) = "(" ++ displayBool a ++ " AND " ++ displayBool b ++ ")"
displayBool (Or a b)  = "(" ++ displayBool a ++ " OR " ++ displayBool b ++ ")"
displayBool (Not a)   = "NOT(" ++ displayBool a ++ ")"
```

```haskell
-- 使用例
let expr = And (BoolLit True) (Or (BoolLit False) (Not (BoolLit True)))
-- displayBool expr == "(true AND (false OR NOT(true)))"
```

---

## まとめ

| 観点 | OOP | Haskell |
|------|-----|---------|
| AST 表現 | クラス階層 | ADT |
| 評価 | accept/visit | パターンマッチ |
| 拡張 | 新しいクラス | 新しいコンストラクタ |
| 型安全性 | キャスト | コンパイル時チェック |

Haskell は Interpreter パターンの実装に最も適した言語の一つです。ADT が AST の定義を、パターンマッチが評価ロジックを、型システムが正しさの検証を、それぞれ担当します。これは Haskell のコンパイラ自身も同じ手法で構築されています。
