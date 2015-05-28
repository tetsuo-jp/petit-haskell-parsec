-- |An interpreter of programming language petit
module Main where
import Prelude hiding (iterate)
import Text.ParserCombinators.Parsec
import Control.Applicative hiding ((<|>))

main = do  s <- getContents
           case parse prog "stdin" s of
             Left err -> putStr "Error: " >> print err
             Right tau -> print (execute tau (\_ -> undefined) 'X')

-- 構文
-- |Variables
type Var  = Char
-- |Expressions
data Exp  = Zero | EVar Var | Succ Exp deriving Show
-- |Statements
data Pro  = Var := Exp    -- ^Assignment
          | Pro `Seq` Pro -- ^Sequence
          | For Exp Pro   -- ^Repetition
            deriving Show

-- 意味領域
-- |Natural numbers
type N  = Int
-- |State
type S  = Var -> N
-- |Transformation of states
type C  = S -> S

-- 意味関数
-- |Evaluation of expressions
eval :: Exp -> S -> N
eval Zero sigma           = 0
eval (EVar xi) sigma      = sigma xi
eval (Succ epsilon) sigma = eval epsilon sigma + 1

-- |Execution of statements
execute :: Pro -> C
execute (xi := epsilon) sigma    = update (xi,eval epsilon sigma) sigma
execute (tau0 `Seq` tau1) sigma  = execute tau1 (execute tau0 sigma)
execute (For epsilon tau) sigma  = iterate (execute tau, eval epsilon sigma) sigma

-- |Update of states
update (xi,nu) sigma eta  | eta == xi  = nu
                          | otherwise  = sigma eta

-- |Application of theta n times
iterate (theta,nu) = foldl1 (.) $ replicate nu theta

-- 構文解析器
-- |Parser for expressions
expr :: Parser Exp
expr =  (char '0' *> return Zero  <|>
         EVar <$> upper           <|>
         Succ <$> (string "suc" *> spaces *> expr))
            <* spaces

-- |Parser for statements
prog, aprog :: Parser Pro
aprog =  ((:=) <$> upper <* spaces <* string ":=" <* spaces <*> expr <|>
          For <$> (string "for" <* spaces *> expr) <*
            string "times" <* spaces <* string "do" <* spaces <*>
            prog <* string "end")
                  <* spaces
prog = spaces *> (foldl1 Seq <$> aprog `sepBy` (string ";" <* spaces))
