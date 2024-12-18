{-# LANGUAGE TemplateHaskell #-}
import Control.Lens
import Data.Bits (xor)
import Data.List.Extra (wordsBy)
import System.IO

data Prog = Prog {_mem :: [Int], _ip :: Int, _ra :: Int, _rb :: Int, _rc :: Int, _out :: [Int]}
    deriving Show
makeLenses ''Prog

getCombo :: Int -> Prog -> Int
getCombo 4 = view ra
getCombo 5 = view rb
getCombo 6 = view rc
getCombo x
    | 0 <= x && x <= 3 = const x
    | otherwise = error $ "Invalid operand " ++ show x

runInstr :: Int -> Int -> Prog -> Prog
runInstr 0 com prog = over ra (`div` (2 ^ (getCombo com prog))) prog
runInstr 1 lit prog = over rb (xor lit) prog
runInstr 2 com prog = set rb ((`mod` 8) $ getCombo com prog) prog
runInstr 3 lit prog = if 0 == view ra prog then prog else set ip (lit - 2) prog
runInstr 4 _ prog = set rb (xor (view rb prog) (view rc prog)) prog
runInstr 5 com prog = over out (++ [(getCombo com prog) `mod` 8]) prog
runInstr 6 com prog = set rb ((view ra prog) `div` (2 ^ (getCombo com prog))) prog
runInstr 7 com prog = set rc ((view ra prog) `div` (2 ^ (getCombo com prog))) prog

runStep :: Prog -> Prog
runStep prog = incIp . runInstr instr oper $ prog
    where
        ipVal = view ip prog
        instr = (!! ipVal) . view mem $ prog
        oper = (!! (ipVal+1)) . view mem $ prog
        incIp = over ip (+2)

runProg :: Prog -> Prog
runProg prog = if (view ip prog) >= length (view mem prog)
    then prog
    else runProg $ runStep prog

runProgQuineCheck :: Prog -> Maybe Prog
runProgQuineCheck prog = let prog' = runStep prog
    in if prefixEq (view out prog') (view mem prog)
        then if (view ip prog') >= length (view mem prog')
			then if (view out prog') == (view mem prog)
				then Just prog'
				else Nothing
			else runProgQuineCheck prog'
        else Nothing

prefixEq :: Eq a => [a] -> [a] -> Bool
prefixEq pref xs = pref == take (length pref) xs

findQuine :: Prog -> Int
findQuine prog = head $ filter (isQuine prog) [0..]

findQuineIO :: Prog -> Int -> IO ()
findQuineIO prog a = do
    print a
    case runProgQuineCheck $ (set ra a prog) of
        Just prog' -> do
            print "Done!"
        Nothing -> findQuineIO prog (a+1)

isQuine :: Prog -> Int -> Bool
isQuine prog a = (view mem prog) == (view out prog')
    where
        prog' = runProg $ set ra a prog

parseProg :: [String] -> Prog
parseProg ls = Prog mem 0 a b c []
    where
        a = read $ findLine "Register A"
        b = read $ findLine "Register B"
        c = read $ findLine "Register C"
        mem = map read . wordsBy (==',') $ findLine "Program"
        findLine :: String -> String
        findLine prefix = let prefix' = prefix ++ ": "
            in drop (length prefix') . head . filter ((prefix' ==) . (take (length prefix'))) $ ls

main = do
    hInput <- openFile "input" ReadMode
    prog <- fmap (parseProg . lines) $ hGetContents hInput
    -- print prog
    -- let prog' = runProg prog
    -- print prog'
    -- print $ view out prog'
    findQuineIO prog 0
