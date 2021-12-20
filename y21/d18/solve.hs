import Data.Char (isDigit)
import System.Environment (getArgs)

data Pair = PN Int | PP Pair Pair

instance Show Pair where
    show (PN n) = show n
    show (PP l r) = "[" ++ show l ++ "," ++ show r ++ "]"

readPair :: String -> (Pair, String)
readPair ('[':rst) = let
        (l, ',':rst') = readPair rst
        (r, ']':rst'') = readPair rst'
    in (PP l r, rst'')
readPair rst = let
        (n, rst') = break (not . isDigit) rst
    in (PN (read n), rst')

split :: Pair -> Pair
split (PN n)
    | n >= 10 = let half = fromIntegral n / 2.0
        in PP (PN $ floor half) (PN $ ceiling half)
    | otherwise = error $ "cannot split " ++ show n

atDepth :: Int -> Pair -> Maybe Pair
atDepth 0 (PP l r) = Just (PP l r)
atDepth d (PN _) = Nothing
atDepth d (PP l r) = case atDepth (d - 1) l of
    Just p -> Just p
    Nothing -> atDepth (d - 1) r

main = do
    args <- getArgs
    ls <- fmap lines $ readFile (head args)
    let ps = map (fst . readPair) ls
    putStr . unlines . map show $ ps
    putStr . unlines . map show $ map (atDepth 4) ps


-- main = (fmap lines getContents) >>= (\ls -> print ls)
