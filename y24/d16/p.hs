import qualified Data.Map as M
import qualified Data.Set as S
import Data.Maybe
import Data.List.Extra (wordsBy)
import Control.Monad (msum)
import Data.List (elemIndex)

data Heading = East | North | West | South deriving (Show, Eq, Ord)
data Loc = Loc Pos Heading deriving (Show, Eq, Ord)
type Pos = (Int,Int)
type Tiles = M.Map Pos Char
data State = State {getTiles :: Tiles, getStart :: Pos, getEnd :: Pos} deriving Show

parseState :: [String] -> State
parseState ls = State tiles start end
    where
        tiles = M.fromList . concat . map parseLine . zip [0..] $ ls
        parseLine :: (Int,String) -> [(Pos,Char)]
        parseLine (y,l) = [((x,y),c) | (x,c) <- zip [0..] l]
        start = fromJust . msum . map (findUniqTile 'S') . M.toList $ tiles
        end = fromJust . msum . map (findUniqTile 'E') . M.toList $ tiles
        findUniqTile c (pos,c')
            | c == c' = Just pos
            | otherwise = Nothing

printTiles :: Tiles -> IO ()
printTiles tiles = putStrLn . unlines $ [[fromJust $ M.lookup (x,y) tiles | x <- [0..w]] | y <- [0..h]]
    where
        tileList = M.toList tiles
        w = maximum . map (\(x,_) -> x) . map fst $ tileList
        h = maximum . map (\(_,y) -> y) . map fst $ tileList

safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead (x:_) = Just x

headingChar :: Heading -> Char
headingChar East = '>'
headingChar North = '^'
headingChar West = '<'
headingChar South = 'v'

printTilesPath :: Tiles -> [Loc] -> IO ()
printTilesPath tiles path = putStrLn . unlines $ [[showTile (x,y) | x <- [0..w]] | y <- [0..h]]
    where
        showTile pos = case pathHeading pos of
            Just c -> c
            Nothing -> fromJust $ M.lookup pos tiles 
        pathHeading :: Pos -> Maybe Char
        pathHeading pos = fmap (headingChar . (\(Loc _ heading) -> heading)) . safeHead . filter (\(Loc pos' _) -> pos' == pos) $ path
        tileList = M.toList tiles
        w = maximum . map (\(x,_) -> x) . map fst $ tileList
        h = maximum . map (\(_,y) -> y) . map fst $ tileList

isGoal :: Loc -> State -> Bool
isGoal (Loc (x,y) d) (State tiles _ _) = M.lookup (x,y) tiles == Just 'E'

headingMove :: Heading -> Pos -> Pos
headingMove North (x,y) = (x,y-1)
headingMove South (x,y) = (x,y+1)
headingMove West (x,y) = (x-1,y)
headingMove East (x,y) = (x+1,y)

turnHeading :: Bool -> Heading -> Heading
turnHeading clockwise = (order !!) . (`mod` (length order)) . (+ direction) . fromJust . (`elemIndex` order)
    where
        direction = if clockwise then -1 else 1
        order = [East,North,West,South]

reachableFrom :: Loc -> Tiles -> [(Loc,Int)]
reachableFrom (Loc pos h) tiles = filter (isNonWall . fst) [
        ((Loc (headingMove h pos) h), 1),
        ((Loc pos (turnHeading False h)), 1000),
        ((Loc pos (turnHeading True h)), 1000)]
    where
        isNonWall :: Loc -> Bool
        isNonWall (Loc pos _) = case M.lookup pos tiles of
            Just 'S' -> True
            Just 'E' -> True
            Just '.' -> True
            Just '#' -> False

data SearchState = SearchState {
    getFrontier :: [Loc],
    getScoreAndPrev :: M.Map Loc (Int,Loc),
    getVisited :: S.Set Loc,
    getState :: State,
    getEndLoc :: Maybe (Loc,Int)} deriving Show

searchStep :: SearchState -> Either SearchState ([Loc],Int)
searchStep (SearchState [] scoreAndPrev _ state endLoc) =
    Right $ ((toPath (getStart state) endLocLoc scoreAndPrev), endScore)
    where
        (endLocLoc,endScore) = fromJust endLoc
searchStep (SearchState (loc:locs) scoreAndPrev visited state endLoc) =
        if loc `elem` visited
        then Left $ SearchState locs scoreAndPrev visited state endLoc -- skip this location
        else if isGoal loc state
            then
                let newEndLoc = updateEndLoc
                in Left $ SearchState newFrontier newScoreAndPrev newVisited state newEndLoc
            else Left $ SearchState newFrontier newScoreAndPrev newVisited state endLoc
    where
        updateEndLoc = case endLoc of
            (Just (l,s)) -> if currScore < s
                then Just (loc, currScore)
                else Just (l, s)
            Nothing -> Just (loc, currScore)
        currScore = fst . fromJust $ M.lookup loc scoreAndPrev
        reachable = reachableFrom loc $ getTiles state
        newVisited = S.insert loc visited
        newFrontier = (map fst . filter (\(loc,scoreDelta) -> betterScore (loc,currScore+scoreDelta) scoreAndPrev) $ reachable) ++ locs
        newScoreAndPrev = foldr updateScoreAndPrev scoreAndPrev reachable
        updateScoreAndPrev :: (Loc,Int) -> M.Map Loc (Int,Loc) -> M.Map Loc (Int,Loc)
        updateScoreAndPrev (loc',scoreDelta) oldScoreAndPrev =
            if betterScore (loc', currScore+scoreDelta) oldScoreAndPrev
                then M.insert loc' (currScore + scoreDelta, loc) oldScoreAndPrev
                else oldScoreAndPrev
        betterScore :: (Loc,Int) -> M.Map Loc (Int,Loc) -> Bool
        betterScore (loc,score) oldScoreAndPrev = case M.lookup loc oldScoreAndPrev of
            Just (oldScore,_) -> score < oldScore
            Nothing -> True

doSearch :: SearchState -> IO ()
doSearch searchState = case searchStep searchState of
    (Left searchState') -> do
        case take 1 . getFrontier $ searchState' of
            [(Loc pos h)] -> if pos == (11,13)
                then do
                    print pos
                    print h
                    print $ M.lookup (Loc pos h) (getScoreAndPrev searchState')
                else return ()
            otherwise -> return ()
        doSearch searchState'
    (Right (path,score)) -> do
        printTilesPath (getTiles $ getState searchState) path
        print score

toPath :: Pos -> Loc -> M.Map Loc (Int,Loc) -> [Loc]
toPath start loc@(Loc pos _) prevs
    | start == pos = [loc]
    | otherwise = let Just (_,loc') = M.lookup loc prevs
        in loc : toPath start loc' prevs

main = do
    ls <- fmap lines getContents
    let state = parseState ls
    printTiles . getTiles $ state
    print $ getStart state
    print $ getEnd state
    print $ reachableFrom (Loc (getStart state) East) (getTiles state)
    let startLoc = Loc (getStart state) East
    let dummyLoc = Loc (0,0) East
    let startSearch = SearchState [(startLoc)] (M.fromList [(startLoc,(0,dummyLoc))]) S.empty state Nothing
    doSearch startSearch
