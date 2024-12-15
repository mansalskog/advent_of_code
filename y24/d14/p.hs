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

displayCountsScale :: Int -> (Int,Int) -> [Robot] -> [String]
displayCountsScale s (w,h) rs = [[count x y | x <- [0..((w-1) `div` s)]] | y <- [0..((h-1) `div` s)]]
	where
		count x y = fixZero . head . show . length $ filter (\(Robot rx ry _ _) -> (rx `div` s) == x && (ry `div` s) == y) rs
		fixZero '0' = '.'
		fixZero c = c

displayCounts :: (Int,Int) -> [Robot] -> [String]
displayCounts = displayCountsScale 1

printCountsScale :: Int -> (Int,Int) -> [Robot] -> IO ()
printCountsScale s dim = mapM_ putStrLn . displayCountsScale s dim

simulateVisual :: (Int,Int) -> Int -> [Robot] -> IO ()
simulateVisual dim n rs = do
	let rs' = simulate dim n rs
	getLine
	printCountsScale 5 dim rs

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
	mapM_ (\n -> simulateVisual dim n robots) [0..1000]
