import Text.Regex.TDFA
import qualified Data.Text as T

pattern = "mul\\([0-9]+,[0-9]+\\)|do\\(\\)|don't\\(\\)"

mul :: T.Text -> Int
mul str = let
    [x,y] = T.splitOn (T.pack ",") . T.drop 4 . T.dropEnd 1 $ str
    in (read $ T.unpack x) * (read $ T.unpack y)

dropDont :: Bool -> [String] -> [String]
dropDont _ [] = []
dropDont False (("do()"):ms) = dropDont True ms
dropDont False (_:ms) = dropDont False ms
dropDont True (("don't()"):ms) = dropDont False ms
dropDont True (("do()"):ms) = dropDont True ms
dropDont True (m:ms) = m:(dropDont True ms)

main = do
    cs <- getContents
    let ms = getAllTextMatches (cs =~ pattern)
    -- print ms
    let ms' = dropDont True ms
    -- print ms'
    let res = map mul . map T.pack $ ms'
    print $ sum res
