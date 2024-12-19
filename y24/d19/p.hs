import Data.List.Split (splitOn)
import Data.List.Extra (notNull)

prefix :: String -> String -> Bool
prefix p = (p ==) . take (length p)

match :: [String] -> String -> Bool
match _ "" = True
match pat str = notNull ms
	where
		ps = filter (`prefix` str) pat
		ms = filter (\p -> match pat (drop (length p) str)) ps

count :: [String] -> String -> Int
count _ "" = 1
count pat str = sum ms
	where
		ps = filter (`prefix` str) pat
		ms = filter (/= 0) $ map (\p -> count pat (drop (length p) str)) ps

boolToInt :: Bool -> Int
boolToInt False = 0
boolToInt True = 1

main = do
	ls <- fmap lines getContents
	let pat = splitOn ", " (ls !! 0)
	let strs = drop 2 ls 
	-- print pat
	-- print strs
	print . sum . map boolToInt $ map (match pat) strs
	print $ count pat (strs !! 0)
	-- print . sum $ map (count pat) strs
