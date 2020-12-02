module Main where

import qualified Data.Set as Set -- O(log(n)) insertion and lookup
import qualified Data.IntSet as IntSet -- O(min(n,W)) insertion and lookup

-- This is problem just 2-sum

-- Takes a list of numbers, a target sum, and a set of seen numbers
twosum :: [Int] -> Int -> (Set.Set Int) -> Maybe (Int, Int)
twosum (x:xs) target seen
    | Set.member y seen = Just (y, x)
    | otherwise = twosum xs target (Set.insert x seen)
    where y = target - x
twosum [] _ _ = Nothing

-- Same thing but faster
twosumIntSet :: [Int] -> Int -> IntSet.IntSet -> Maybe (Int, Int)
twosumIntSet (x:xs) target seen
    | IntSet.member y seen = Just (y, x)
    | otherwise = twosumIntSet xs target (IntSet.insert x seen)
    where y = target - x
twosumIntSet [] _ _ = Nothing

-- Now 3-sum
threesumIntSet :: [Int] -> Int -> IntSet.IntSet -> Maybe (Int, Int, Int)
threesumIntSet (x:xs) target seen =
    case twosumIntSet (IntSet.toList seen) (target - x) IntSet.empty of
        Just (z, y) -> Just (z, y, x)
        Nothing -> threesumIntSet xs target (IntSet.insert x seen)
threesumIntSet [] _ _ = Nothing

main :: IO ()
main = do
    targetline <- getLine
    let target = read targetline :: Int
    let getnums xs = do
        line <- getLine
        if length line > 0
        then getnums (xs ++ [read line :: Int])
        else return xs
    nums <- getnums []
    case threesumIntSet nums target IntSet.empty of
        Just (x, y, z) -> putStrLn (show (x * y * z))
        Nothing -> putStrLn "Nothing"