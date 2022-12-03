import Data.Set (Set, intersection, fromList, elemAt)
import Data.List (elemIndex)
import Data.Maybe (fromJust)

chunksOf :: Int -> [a] -> [[a]]
chunksOf n l
    | null l = []
    | length l < n = [l]
    | otherwise = (take n l) : (chunksOf n (drop n l))

priority :: Char -> Int
priority = (1+) . fromJust . flip elemIndex "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

common :: Ord a => ([a],[a]) -> a
common (x,y) = elemAt 0 $ intersection (fromList x) (fromList y)

main = do
    ls <- fmap lines getContents
    let cs = map (\l -> common $ splitAt (length l `div` 2) l) ls
    print . sum . map priority $ cs
    let rs = chunksOf 3 . map fromList $ ls :: [[Set Char]]
    let bs = map (\[x,y,z] -> elemAt 0 $ intersection x (intersection y z)) rs
    print . sum . map priority $ bs
