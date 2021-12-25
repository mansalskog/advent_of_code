import Data.List (minimumBy, maximumBy)
import Data.Function (on)
import Debug.Trace (trace)

newtype Board = Board [[(Int,Bool)]]

instance Show Board where
    show (Board b) = unlines $ ["Board("] ++ (map row b) ++ [")"] where
        row = unwords . map sqr
        sqr (num, False) = show num
        sqr (_, True) = "X"

splitWhen :: (a -> Bool) -> [a] -> [[a]]
splitWhen _ [] = []
splitWhen f lst = case break f lst of
    (fst, brk:rst) -> [fst] ++ splitWhen f rst
    (fst, []) -> [fst]

mark :: Int -> Board -> Board
mark num (Board b) = Board $ map (map sqr) b where
    sqr (num', marked)
        | num == num' = (num', True)
        | otherwise = (num', marked)

bingoRow :: Board -> Bool
bingoRow (Board b) = any (all snd) b

bingoCol :: Board -> Bool
bingoCol (Board b) = any col [0..length b - 1] where
    col c = all (\r -> snd $ (b !! r) !! c) [0..length b - 1]

bingoSteps :: [Int] -> Int -> Board -> (Int, Int)
bingoSteps [] _ _ = error "never bingo"
bingoSteps (n:ns) steps b = let
        b' = mark n b
    in if bingoRow b' || bingoCol b'
        then (steps, n * sumUnmarked b')
        else bingoSteps ns (steps + 1) b'

sumUnmarked :: Board -> Int
sumUnmarked (Board b) = sum . map (sum . map sqr) $ b
    where sqr (num, marked) = if marked then 0 else num

main = do
    ls <- fmap lines getContents
    let nums = map read . splitWhen (== ',') $ ls !! 0 :: [Int]
    let boards = map (Board . map (map (\s -> (read s, False)) . words)) . splitWhen (== "") $ drop 2 ls :: [Board]
    let scores = map (bingoSteps nums 0) boards
    print . snd $ minimumBy (on compare fst) scores
    print . snd $ maximumBy (on compare fst) scores
