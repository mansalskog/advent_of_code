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

-- Part 2 --

toWide :: State -> State
toWide (State tiles (Pos x y)) = State newTiles (Pos (2*x) y)
    where
        newTiles = M.foldrWithKey updateTile M.empty tiles
        updateTile :: Pos -> Char -> Tiles -> Tiles
        updateTile (Pos x y) c = M.insert (Pos (2*x) y) c1 . M.insert (Pos (2*x+1) y) c2
            where
                [c1,c2] = case c of
                    'O' -> "[]"
                    '#' -> "##"
                    '.' -> ".."
                    '@' -> "@."

stepWide :: Char -> State -> State
stepWide i state@(State tiles pos) = let
        delta = instrDelta i
        pos' = applyDelta pos delta
    in case fromJust $ M.lookup pos' tiles of
        c
            | c == '.' -> moveRobot pos' state -- move into empty
            | c == '#' -> state -- no move possible
            | c `elem` "[]" -> case pushBoxes pos' delta state of
                Just state -> moveRobot pos' state -- boxes moved alreay, just update robot
                Nothing -> state -- no move possible

-- move boxes and push robot if possible
pushBoxes :: Pos -> Delta -> State -> Maybe State
pushBoxes pos delta (State tiles robotPos) = case moveWideBox pos delta tiles of
    Just tiles' -> Just $ State tiles' robotPos
    Nothing -> Nothing

moveWideBox :: Pos -> Delta -> Tiles -> Maybe Tiles
moveWideBox pos delta tiles = let
        c = fromJust $ M.lookup pos tiles
        (linkedPos,linkedC) = case c of
            '[' -> (applyDelta pos (Delta 1 0), ']')
            ']' -> (applyDelta pos (Delta (-1) 0), '[')
            otherwise -> error $ "Invalid box " ++ [c]
        pos' = applyDelta pos delta
        linkedPos' = applyDelta linkedPos delta
        propLinked :: Tiles -> Maybe Tiles
        propLinked ts = case fromJust $ M.lookup linkedPos' ts of
            c
                | c == '.' -> Just ts
                | c `elem` "[]" -> moveWideBox linkedPos' delta ts
                | c == '#' -> Nothing
        prop :: Tiles -> Maybe Tiles
        prop ts = case fromJust $ M.lookup pos' ts of
            c
                | c == '.' -> Just ts
                | c `elem` "[]" -> moveWideBox pos' delta ts
                | c == '#' -> Nothing
        moveThem :: Tiles -> Maybe Tiles
        moveThem ts = if '#' == (fromJust $ M.lookup pos' ts) || '#' == (fromJust $ M.lookup linkedPos' ts)
            then Nothing
            else Just . M.insert pos' c . M.insert linkedPos' linkedC . M.insert pos '.' . M.insert linkedPos '.' $ ts
    in if linkedPos /= pos'
        then propLinked tiles >>= prop >>= moveThem
        else moveThem tiles

simulateWide :: Int -> [Char] -> State -> IO ()
simulateWide _ [] state = do
    printTiles $ getTiles state
    return ()
simulateWide idx (i:is) state = do
    let state' = stepWide i state
    if True
        then do
            putStrLn $ show idx ++ " move " ++ [i] ++ ":"
            printTiles $ getTiles state'
        else return ()
    simulateWide (idx+1) is state'

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
    -- simulate instr state
    -- Part 2
    let wideState = toWide $ state
    -- printTiles $ getTiles wideState
    simulateWide 0 (take 150 instr) wideState
