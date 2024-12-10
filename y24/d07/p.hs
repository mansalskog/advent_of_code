import Data.List.Extra (splitOn)

data Test = Test Int [Int] deriving Show

parseTest :: String -> Test
parseTest txt = Test (read tv) (map read $ words vs)
    where
        [tv,vs] = splitOn ": " txt

allValues :: [Int] -> [Int]
allValues (x:y:[]) = [x+y, x*y]
allValues (x:y:xs) = 

main = do
    ls <- fmap lines $ readFile "test"
    let tests = map parseTest ls
    print tests
