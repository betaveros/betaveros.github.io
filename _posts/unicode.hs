import Control.Applicative
import Control.Arrow
import Control.Monad.Trans.State
import Control.Monad.Trans
import Control.Monad.Trans.Writer
import Data.Char
import Data.List
import Data.Function
import Text.Printf
import Data.Maybe

td s = "<td>" ++ s ++ "</td>"
codeTag s = "<code>" ++ s ++ "</code>"
preTag s = "<pre>" ++ s ++ "</pre>"
tr ss = "<tr>" ++ concatMap td ss ++ "</tr>\n"

escape '<' = "&lt;"
escape '>' = "&gt;"
escape '&' = "&amp;"
escape c = [c]

vimEscape '|' = "\\|"
vimEscape c = [c]

row :: (Char, Maybe String, String) -> String
row (c,ks,desc) = let n = ord c in tr $
	[ [c]
	, show n
	, printf "%X" n
	, maybe "" (codeTag . concatMap escape) ks
	, desc
	]
thRow s = tr ["<th colspan='5'>" ++ s ++ "</th>"]

type CharMake x = WriterT (String,String) (State Bool) x

tellData :: (Char, Maybe String, String) -> CharMake ()
tellData tup@(c, Just ks, _) = do
	isCustom <- lift get
	tell (row tup, if isCustom then " " ++ ks ++ " " ++ show (ord c) else "")
tellData tup@_ = tell (row tup, "")

tellHeader :: String -> CharMake ()
tellHeader s = do
	tell (thRow s, "")
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
	, "sel: blog"
	, "title: Unicode"
	, "---"
	, "<p><a href='" ++ selfUrl ++ "'>Peek behind the scenes</a></p>"
	]

table :: String -> String
table x = "<table class='table table-condensed table-hover'>\n" ++ x ++ "</table>\n"

splitTabs = filter ((/= '\t') . head) . groupBy ((==) `on` (== '\t'))

main = do
	dat <- map splitTabs . lines <$> getContents
	let (tableContent, digraphContent) = evalState (execWriterT (mapM pr dat)) False
	putStrLn header
	putStrLn $ table tableContent
	putStrLn "{% highlight vim %}"
	putStrLn $ "digraph" ++ concatMap vimEscape digraphContent
	putStrLn "{% endhighlight %}"
