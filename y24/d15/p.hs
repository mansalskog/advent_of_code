import qualified Data.Map as M
import Data.Maybe
import Data.List.Extra (wordsBy)
import Control.Monad (msum)

data Pos = Pos Int Int deriving (Show, Eq, Ord)
data Delta = Delta Int Int deriving Show
type Tiles = M.Map Pos Char
data State = State {getTiles :: Tiles, getPos :: Pos} deriving Show

parseState :: [String] -> State
parseState ls = State tiles pos
    where
        tiles = M.fromList . concat . map parseLine . zip [0..] $ ls
        parseLine :: (Int,String) -> [(Pos,Char)]
        parseLine (y,l) = [(Pos x y,c) | (x,c) <- zip [0..] l]
        pos = fromJust . msum . map robotPos . M.toList $ tiles
        robotPos ((Pos x y),'@') = Just $ Pos x y
        robotPos (_,_) = Nothing

instrDelta :: Char -> Delta
instrDelta '^' = Delta 0 (-1)
instrDelta 'v' = Delta 0 1
instrDelta '<' = Delta (-1) 0
instrDelta '>' = Delta 1 0

applyDelta :: Pos -> Delta -> Pos
applyDelta (Pos x y) (Delta dx dy) = Pos (x+dx) (y+dy)

findEmpty :: Tiles -> Pos -> Delta -> Maybe Pos
findEmpty tiles pos delta = let pos' = applyDelta pos delta
    in case M.lookup pos' tiles of
        Just '.' -> Just pos'
        Just 'O' -> findEmpty tiles pos' delta
        Just '#' -> Nothing
        Nothing -> Nothing

moveRobot :: Pos -> State -> State
moveRobot pos' state@(State tiles pos)
    | pos' == pos = state
    | otherwise = State (M.insert pos' '@' . M.insert pos '.' $ tiles) pos'

moveBox :: Pos -> Pos -> State -> State
moveBox pos pos' state@(State tiles robotPos)
    | pos' == pos = state
    | otherwise = State (M.insert pos' 'O' . M.insert pos '.' $ tiles) robotPos

step :: State -> Char -> State
step state@(State tiles pos) instr = let pos' = applyDelta pos (instrDelta instr)
    in case M.lookup pos' tiles of
        Just '.' -> moveRobot pos' state
        Just 'O' -> case findEmpty tiles pos (instrDelta instr) of
            Just pos'' -> moveRobot pos' . moveBox pos' pos'' $ state  --todo also move boxes
            Nothing -> state
        Just '#' -> state
        -- Nothing -> (State tiles pos) -- should never happen

printTiles :: Tiles -> IO ()
printTiles tiles = putStrLn . unlines $ [[fromJust $ M.lookup (Pos x y) tiles | x <- [0..w]] | y <- [0..h]]
    where
        tiles' = M.toList tiles
        w = maximum . map (\(Pos x _) -> x) . map fst $ tiles'
        h = maximum . map (\(Pos _ y) -> y) . map fst $ tiles'

simulate :: [Char] -> State -> IO ()
simulate [] state = do
    printTiles $ getTiles state
    print . scoreTiles $ getTiles state
simulate (i:is) state = do
    let state' = step state i
    -- putStrLn $ "Move " ++ [i] ++ ":"
    -- printTiles $ getTiles state'
    simulate is state'

scoreTiles :: Tiles -> Int
scoreTiles = M.foldrWithKey scoreBox 0
    where
        scoreBox :: Pos -> Char -> Int -> Int
        scoreBox (Pos x y) 'O' s = s + x + y * 100
        scoreBox _ _ s = s

main = do
    ls <- fmap lines getContents
    let [ls0, ls1] = wordsBy (== "") ls
    let state = parseState ls0
    let instr = concat ls1
    -- printTiles $ getTiles state
    simulate instr state
