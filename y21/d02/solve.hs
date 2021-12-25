import System.Environment (getArgs)
import Control.Monad (liftM)
import Debug.Trace (trace)

type Part = (String,Int) -> (Int,Int,Int) -> (Int,Int,Int)

part1 :: Part
part1 ("forward",x) (h,d,a) = (h+x,d,a)
part1 ("down",x) (h,d,a) = (h, d + x, a)
part1 ("up",x) (h,d,a) = (h, d - x, a)

part2 :: Part
part2 ("forward",x) (h,d,a) = (h+x,d+a*x,a)
part2 ("down",x) (h,d,a) = (h,d,a+x)
part2 ("up",x) (h,d,a) = (h,d,a-x)

parse :: String -> [(String,Int)]
parse = map (fmap read . break (== ' ')) . lines

solve :: Part -> [(String,Int)] -> Int
solve f = (\(h,d,_) -> h * d) . foldl (flip f) (0,0,0)

main = do
    ls <- fmap parse $ fmap head getArgs >>= readFile
    print $ solve part1 ls
    print $ solve part2 ls

