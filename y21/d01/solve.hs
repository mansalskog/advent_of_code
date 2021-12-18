import System.Environment (getArgs)

b2i :: Bool -> Int
b2i False = 0
b2i True = 1

main = do
    content <- getContents
    let xs = map read . lines $ content :: [Int]
    print . sum . map b2i $ zipWith (<) (init xs) (tail xs)
    print . sum . map b2i $ zipWith (<) (take (length xs - 3) xs) (drop 3 xs)
