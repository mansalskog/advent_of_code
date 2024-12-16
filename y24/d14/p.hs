import Data.List.Extra (wordsBy)
import System.IO

data Robot = Robot Int Int Int Int deriving Show

parseRobot :: String -> Robot
parseRobot str = Robot x y dx dy
	where
		[pos, del] = words str
		[x, y] = map read . wordsBy (== ',') . drop 2 $ pos
		[dx, dy] = map read . wordsBy (== ',') . drop 2 $ del

simulateRobot :: (Int,Int) -> Int -> Robot -> Robot
simulateRobot (w,h) n (Robot x y dx dy) = Robot x' y' dx dy
	where
		x' = (x + n * dx) `mod` w
		y' = (y + n * dy) `mod` h

simulateStep :: (Int,Int) -> [Robot] -> [Robot]
simulateStep dim = map (simulateRobot dim 1)

inQuadrant :: (Int,Int) -> Int -> Robot -> Bool
inQuadrant (w,h) 0 (Robot x y _ _) = x < w `div` 2 && y < h `div` 2
inQuadrant (w,h) 1 (Robot x y _ _) = x > w `div` 2 && y < h `div` 2
inQuadrant (w,h) 2 (Robot x y _ _) = x < w `div` 2 && y > h `div` 2
inQuadrant (w,h) 3 (Robot x y _ _) = x > w `div` 2 && y > h `div` 2

countQuadrant :: (Int,Int) -> Int -> [Robot] -> Int
countQuadrant dim q = length . filter (inQuadrant dim q)

simulate :: (Int,Int) -> Int -> [Robot] -> [Robot]
-- simulate n dim = (!! n) . iterate (simulateStep dim)
simulate dim n = map (simulateRobot dim n)

countsAtScale :: Int -> (Int,Int) -> [Robot] -> [[Int]]
countsAtScale s (w,h) rs = [[count x y | x <- [0..((w-1) `div` s)]] | y <- [0..((h-1) `div` s)]]
	where
		count x y = length $ filter (\(Robot rx ry _ _) -> (rx `div` s) == x && (ry `div` s) == y) rs

displayCountsScale :: Int -> (Int,Int) -> [Robot] -> [String]
-- why can't I write this using composition?
displayCountsScale n dim rs = map (map dispCount) $ countsAtScale n dim rs
	where
		dispCount :: Int -> Char
		dispCount 0 = '.'
		dispCount c
			| c < 10 = head $ show c
			| otherwise = '+'

simulateVisual :: (Int,Int) -> Int -> [Robot] -> IO ()
simulateVisual dim n rs = do
	let rs' = simulate dim n rs
	let ls = countsAtScale 20 dim rs'
	if any (any (>= 80)) ls then do
		print n
		-- mapM_ print ls
		mapM_ putStrLn $ displayCountsScale 1 dim rs'
		getLine
		return ()
	else do
		print n
		return ()

main = do
	let dim = (101,103)
	-- let dim = (11,7)
	inputH <- openFile "input" ReadMode
	robots <- fmap ((map parseRobot) . lines) $ hGetContents inputH
	-- let robots = [Robot 2 4 2 (-3)]
	let robots' = simulate dim 100 robots
	let qCounts = map (flip (countQuadrant dim) robots') [0..3]
	print qCounts
	print $ foldr (*) 1 qCounts
	mapM_ (\n -> simulateVisual dim n robots) [0..100000]
