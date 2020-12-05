-- Same as elixir day3 but I wanted to see how it would look in Haskell

p1 :: [String] -> Int -> Int -> Int -> Int -> Int -> Int
p1 (l:ls) right down index skip trees
    | skip > 0  = p1 ls right down index (skip - 1)  trees
    | c == '.'  = p1 ls right down nexti (down - 1)  trees
    | otherwise = p1 ls right down nexti (down - 1) (trees + 1)
    where
        nexti = mod (index + right) (length l)
        c = l !! index
p1 [] _ _ _ _ trees = trees

p2 :: [String] -> [(Int, Int)] -> Int -> Int
p2 lines (slope:slopes) prod = p2 lines slopes (prod * trees)
    where trees = uncurry (p1 lines) slope 0 0 0
p2 _ [] prod = prod

main :: IO ()
main = do
    let getlines lines = do
        line <- getLine
        if not $ null line
        then getlines (lines ++ [line])
        else return lines
    lines <- getlines []
    let slopes = [(1,1), (3,1), (5,1), (7,1), (1,2)]
    print $ p2 lines slopes 1