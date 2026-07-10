module InterpreterTest (tests) where

import Interpreter
  ( BoolExpr (..)
  , Expr (..)
  , display
  , displayBool
  , eval
  , evalBool
  , simplify
  )
import Test.HUnit

tests :: Test
tests =
    TestLabel "InterpreterTest" $
    TestList
      [ TestLabel "testArithmeticEval" testArithmeticEval
      , TestLabel "testVariables" testVariables
      , TestLabel "testDivisionByZero" testDivisionByZero
      , TestLabel "testDisplay" testDisplay
      , TestLabel "testSimplify" testSimplify
      , TestLabel "testBoolInterpreter" testBoolInterpreter
      , TestLabel "testDisplayBool" testDisplayBool
      ]

testArithmeticEval :: Test
testArithmeticEval = TestCase $ do
  let expr = Mul (Add (Lit 2.0) (Lit 3.0)) (Lit 4.0)
  assertEqual "複合式" 20.0 (eval [] expr)
  assertEqual "負数" (-5.0) (eval [] (Neg (Lit 5.0)))
  assertEqual "減算" 7.0 (eval [] (Sub (Lit 10.0) (Lit 3.0)))

testVariables :: Test
testVariables = TestCase $ do
  let expr = Add (Var "x") (Mul (Var "y") (Lit 3.0))
      env = [("x", 10.0), ("y", 5.0)]
  assertEqual "環境から変数を解決する" 25.0 (eval env expr)
  assertEqual "未定義変数は 0" 0.0 (eval [] (Var "z"))

testDivisionByZero :: Test
testDivisionByZero = TestCase $ do
  assertEqual "通常の除算" 5.0 (eval [] (Div (Lit 10.0) (Lit 2.0)))
  assertEqual "ゼロ除算は 0" 0.0 (eval [] (Div (Lit 10.0) (Lit 0.0)))

testDisplay :: Test
testDisplay = TestCase $ do
  assertEqual "式表示" "((2.0 + 3.0) * x)" (display (Mul (Add (Lit 2.0) (Lit 3.0)) (Var "x")))
  assertEqual "負数表示" "-(x)" (display (Neg (Var "x")))

testSimplify :: Test
testSimplify = TestCase $ do
  assertEqual "x + 0 = x" (Var "x") (simplify (Add (Var "x") (Lit 0.0)))
  assertEqual "0 + x = x" (Var "x") (simplify (Add (Lit 0.0) (Var "x")))
  assertEqual "x * 0 = 0" (Lit 0.0) (simplify (Mul (Var "x") (Lit 0.0)))
  assertEqual "x * 1 = x" (Var "x") (simplify (Mul (Var "x") (Lit 1.0)))
  assertEqual "--x = x" (Var "x") (simplify (Neg (Neg (Var "x"))))

testBoolInterpreter :: Test
testBoolInterpreter = TestCase $ do
  let expr = And (BoolLit True) (Or (BoolLit False) (Not (BoolLit False)))
  assertEqual "ブール式評価" True (evalBool expr)
  assertEqual "否定" False (evalBool (Not (BoolLit True)))

testDisplayBool :: Test
testDisplayBool = TestCase $ do
  let expr = And (BoolLit True) (Or (BoolLit False) (Not (BoolLit True)))
  assertEqual "ブール式表示" "(true AND (false OR NOT(true)))" (displayBool expr)
