import Control.Applicative
import Control.Arrow
import Control.Monad
import Control.Monad.Trans.State
import Control.Monad.Trans
import Control.Monad.Trans.Writer
import Data.Char
import Data.List
import Data.Function
import Text.Printf
import Data.Maybe
import Data.List.Split
import System.Environment

td s = "<td>" ++ s ++ "</td>"
codeTag s = "<code>" ++ s ++ "</code>"
preTag s = "<pre>" ++ s ++ "</pre>"
tr ss = "<tr>" ++ concatMap td ss ++ "</tr>\n"

escape :: Char -> String
escape '<' = "&lt;"
escape '>' = "&gt;"
escape '&' = "&amp;"
escape c = [c]

vimEscape :: Char -> String
vimEscape '|' = "\\|"
vimEscape c = [c]

sqEscape :: Char -> String
sqEscape '\'' = "\\'"
sqEscape c = [c]

paddedHex :: Int -> String
paddedHex n = let
        hex = printf "%X" n
        padding = if length hex < 4 then "<span class='text-muted'>" ++ replicate (4 - length hex) '0' ++ "</span>" else ""
    in padding ++ hex

row :: (Char, Maybe String, String) -> String
row (c,ks,desc) = let n = ord c in tr
    [ [c]
    , show n
    , paddedHex n
    , maybe "" (codeTag . concatMap escape) ks
    , desc
    ]
thRow s = tr ["<th colspan='5'>" ++ s ++ "</th>"]

type DigraphInfo = (String, Int)
type CharMake x = WriterT (String,[DigraphInfo]) (State Bool) x

tellData :: (Char, Maybe String, String) -> CharMake ()
tellData tup@(c, Just ks, _) = do
    isCustom <- lift get
    tell (row tup, [(ks, ord c) | isCustom])
tellData tup@_ = tell (row tup, [])

tellHeader :: String -> CharMake ()
tellHeader s = do
    tell (thRow s, [])
    lift . put $ "Custom:" `isPrefixOf` s

pr :: [String] -> CharMake ()
pr []            = return ()
pr [[c]]         = tellData (c, Nothing, "")
pr [hd]          = tellHeader hd
pr [[c],ks]      = tellData (c, Just ks, "")
pr [[c],ks,desc] = tellData (c, Just ks, desc)
pr _             = error "cannot parse"

selfUrl = "https://github.com/betaveros/betaveros.github.io/blob/master/_posts/unicode.hs"

header :: String
header = unlines
    [ "---"
    , "layout: default"
    , "category: code"
    , "title: Unicode"
    , "---"
    , "<p><a href='" ++ selfUrl ++ "'>Peek behind the scenes</a></p>"
    ]

table :: String -> String
table x = "<table class='table table-condensed table-hover'>\n" ++ x ++ "</table>\n"

splitTabs :: String -> [String]
splitTabs = filter ((/= '\t') . head) . groupBy ((==) `on` (== '\t'))

digraphInfoToPureString :: DigraphInfo -> String
digraphInfoToPureString (s, n) = concat [s, " ", show n]

digraphInfoToPythonEntry :: DigraphInfo -> String
digraphInfoToPythonEntry (s, n) =
    concat ["'", concatMap sqEscape s, "': ", show n, ","]

digraphInfoToPerlEntry :: DigraphInfo -> String
digraphInfoToPerlEntry (s, n) =
    concat ["'", concatMap sqEscape s, "' => \"\\N{U+", printf "%X" n, "}\","]

printVimCommands :: [DigraphInfo] -> IO ()
printVimCommands digraphContent =
    forM_ (chunksOf 8 digraphContent) $
        putStrLn . ("digraph " ++) . unwords .
        map (concatMap vimEscape . digraphInfoToPureString)

printHTML :: String -> [DigraphInfo] -> IO ()
printHTML tableContent digraphContent = do
    putStrLn header
    putStrLn $ table tableContent
    putStrLn "{% highlight vim %}"
    printVimCommands digraphContent
    putStrLn "{% endhighlight %}"

main :: IO ()
main = do
    dat <- map splitTabs . lines <$> getContents
    let (tableContent, digraphContent) = evalState (execWriterT (mapM pr dat)) False
    args <- getArgs
    case args of
        [] -> printHTML tableContent digraphContent
        ["vim"] -> printVimCommands digraphContent
        ["dc"] -> forM_ digraphContent (putStrLn . digraphInfoToPureString)
        ["py"] -> forM_ digraphContent (putStrLn . digraphInfoToPythonEntry)
        ["pl"] -> forM_ digraphContent (putStrLn . digraphInfoToPerlEntry)
        _ -> error "Could not understand argument"
