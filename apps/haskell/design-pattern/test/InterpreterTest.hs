module InterpreterTest (tests) where

import Test.HUnit
import Interpreter

tests :: Test
tests = TestLabel "Interpreter" $ TestList
  [ testLiteral
  , testAddition
  , testComplex
  , testVariable
  , testDivByZero
  , testDisplay
  , testSimplify
  , testBoolExpr
  ]

testLiteral :: Test
testLiteral = TestCase $
  assertEqual "リテラル" 42.0 (eval [] (Lit 42.0))

testAddition :: Test
testAddition = TestCase $
  assertEqual "加算" 7.0 (eval [] (Add (Lit 3.0) (Lit 4.0)))

testComplex :: Test
testComplex = TestCase $ do
  -- (2 + 3) * 4 = 20
  let expr = Mul (Add (Lit 2.0) (Lit 3.0)) (Lit 4.0)
  assertEqual "複合式" 20.0 (eval [] expr)

testVariable :: Test
testVariable = TestCase $ do
  let expr = Add (Var "x") (Lit 10.0)
      env  = [("x", 5.0)]
  assertEqual "変数あり" 15.0 (eval env expr)
  assertEqual "変数なし" 10.0 (eval [] expr)

testDivByZero :: Test
testDivByZero = TestCase $
  assertEqual "ゼロ除算" 0.0 (eval [] (Div (Lit 10.0) (Lit 0.0)))

testDisplay :: Test
testDisplay = TestCase $ do
  let expr = Add (Lit 1.0) (Mul (Lit 2.0) (Lit 3.0))
  assertEqual "表示" "(1.0 + (2.0 * 3.0))" (display expr)

testSimplify :: Test
testSimplify = TestCase $ do
  -- x + 0 => x
  let expr1 = Add (Var "x") (Lit 0)
  assertEqual "x + 0 の単純化" (Var "x") (simplify expr1)
  -- 1 * x => x
  let expr2 = Mul (Lit 1) (Var "x")
  assertEqual "1 * x の単純化" (Var "x") (simplify expr2)
  -- 0 * x => 0
  let expr3 = Mul (Lit 0) (Var "x")
  assertEqual "0 * x の単純化" (Lit 0) (simplify expr3)

testBoolExpr :: Test
testBoolExpr = TestCase $ do
  let expr = And (BoolLit True) (Or (BoolLit False) (BoolLit True))
  assertEqual "ブール式" True (evalBool expr)
  assertEqual "表示" "(true AND (false OR true))" (displayBool expr)
  assertEqual "NOT" False (evalBool (Not (BoolLit True)))
