import Data.List.Extra
import System.IO

type Rule = [Int]
type Pages = [Int]

parseRule :: String -> Rule
parseRule = map read . splitOn "|"
    where toPair [x,y] = (x,y)

parsePages :: String -> Pages
parsePages = map read . splitOn ","

follows :: Rule -> Pages -> Bool
follows rule pages = length filt <= 1 || filt == rule
    where
        filt = filter (`elem` rule) pages

followsAll :: [Rule] -> Pages -> Bool
followsAll rules pages = all (flip follows pages) rules

middle :: Pages -> Int
middle xs = xs !! (length xs `div` 2)

rulesOrdering :: [Rule] -> Int -> Int -> Ordering
rulesOrdering rules x y
    | x == y = EQ
    | [x,y] `elem` rules = LT
    | otherwise = GT

main = do
    ls <- fmap lines $ readFile "input"
    let [ruleText,pageText] = splitOn [""] ls
    let rules = map parseRule ruleText
    let pages = map parsePages pageText
    print . sum . map middle . filter (followsAll rules) $ pages

    let brokenPages = filter (not . followsAll rules) $ pages
    print brokenPages
    let relevantRules = filter (\[x,y] -> any (x `elem`) brokenPages || any (y `elem`) brokenPages) rules
    print relevantRules
    let fixedPages = map (sortBy (rulesOrdering relevantRules)) brokenPages
    print fixedPages
    print . sum . map middle $ fixedPages
    -- let brokenRules = map (\ps -> filter (not . flip follows ps) rules) $ brokenPages
    -- print brokenRules
