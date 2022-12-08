import Data.List (findIndex)

visible :: [[Char]] -> Int -> Int -> Bool
visible ls x y = (all (< h) . take (x) $ (ls !! y))
        || (all (< h) . drop (x + 1) $ (ls !! y))
        || (all (< h) . map (\y' -> (ls !! y') !! x) $ [0..(y - 1)])
        || (all (< h) . map (\y' -> (ls !! y') !! x) $ [(y + 1)..(length ls - 1)])
    where h = (ls !! y) !! x

main = do
    ls <- fmap lines getContents
    let h = length ls
    let w = length (ls !! 1)
    let is = [(x,y) | y <- [0..(h - 1)], x <- [0..(w - 1)]]
    print . sum . map (\b -> if b then 1 else 0) . map (\(x,y) -> visible ls x y) $ is
