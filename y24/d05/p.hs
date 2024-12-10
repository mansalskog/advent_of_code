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

fixWithRule :: Rule -> Pages -> Pages
fixWithRule [fst,snd] ps = if follows [fst,snd] ps
    then ps
    else case elemIndex snd ps of
        Nothing -> ps
        Just idx -> let fixed = filter (/= fst)
            in fixed (take idx ps) ++ [fst] ++ fixed (drop idx ps)

main = do
    ls <- fmap lines $ readFile "test"
    let [ruleText,pageText] = splitOn [""] ls
    let rules = map parseRule ruleText
    let pages = map parsePages pageText
    print . sum . map middle . filter (followsAll rules) $ pages

    let incPages = filter (not . followsAll rules) $ pages
    print incPages
    let brokenRules = map (\ps -> filter (not . flip follows ps) rules) $ incPages
    print brokenRules
    print $ foldl' (flip fixWithRule (head incPages)) (head brokenRules)
