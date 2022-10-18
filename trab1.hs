-- Check if two factors have the same expoents in each variable, if they are equivalents and can be normalize
checkEquivalentFactors :: [Int] -> [Int] -> Bool
checkEquivalentFactors (x:xs) (y:ys) | xs == ys = True
    | otherwise = False

-- find in a polynomial factors that are equivalent with the input one
findEquivalentFactors :: [Int] -> [[Int]] -> [Int]
findEquivalentFactors x ys = [i | (y, i) <- zip ys [0..n], checkEquivalentFactors x y]
    where n = length ys -1

-- sum the coeficients of two factors, keeping the expoents of the first one
sumFactorsCoef :: [Int] -> [Int] -> [Int]
sumFactorsCoef (x:xs) (y:ys) = [x + y] ++ xs

-- receive a polynomial and a list of indexes of that are equivalents and return the sum of them
sumAllEqFactors :: [[Int]] -> [Int] -> [Int]
sumAllEqFactors [[]] [a] = []
sumAllEqFactors poly [] = [0 | i <- [1..n]]
    where n = length (head poly)
sumAllEqFactors poly indexes = sumFactorsCoef (poly !! (head indexes)) (sumAllEqFactors poly (tail indexes))

-- delete an element from the list by it's index
delIndexList :: [a] -> Int -> [a]
delIndexList [] n = []
delIndexList list n | n < 0 = list
    | otherwise = (take n list) ++ (drop (n + 1) list)

-- drop the table lines according to the indexes in a list
dropTableIndexes :: [[a]] -> [Int] -> [[a]]
dropTableIndexes [[]] [a] = [[]]
dropTableIndexes table [] = table
dropTableIndexes table indexes = dropTableIndexes (delIndexList table ((last indexes))) (init indexes)

-- normalize a polynomial
-- First search for the equivalent factors of the head of the polynomial
-- Sum the equivalent factors
-- Drop the factors from the polynomial
-- Recursively call the function with the tables dropped
-- in the end it will ++ the factors summed and create the normalized polynomial
-- TEST CASE normalizePolynomial [[1,1,1,0], [3,2,1,0], [4,1,1,0], [0,1,1,0], [2,2,1,0], [4,0,0,0]]
-- result [[5,1,1,0],[5,2,1,0],[4,0,0,0]]
normalizePolynomial :: [[Int]] -> [[Int]]
normalizePolynomial [] = []
normalizePolynomial [[]] = [[]]
normalizePolynomial poly = [sumAllEqFactors poly (findEquivalentFactors (poly !! 0) poly)] ++ normalizePolynomial (dropTableIndexes poly (findEquivalentFactors (poly !! 0) poly))

-- Sum polynomials
-- take the two polynomials and ++
-- normalize the generated polynomial
-- TEST CASE sumPolynomials [[1,0,0,1],[3,1,0,0],[1,0,1,0]] [[3,1,1,0],[1,1,0,0],[5,0,0,1]]
-- result [[6,0,0,1],[4,1,0,0],[1,0,1,0],[3,1,1,0]]
sumPolynomials :: [[Int]] -> [[Int]] -> [[Int]]
sumPolynomials [[]] [[]] =[]
sumPolynomials [[]] y = y
sumPolynomials x [[]] = x
sumPolynomials x y = normalizePolynomial (x ++ y)

-- Sum an array of polynomials
-- recursively take the head of the array, sum with the rest of the array and normalize
-- TEST CASE sumMultPolynomials [[[1,0,0,1],[3,1,0,0],[1,0,1,0]],[[3,1,1,0],[1,1,0,0],[5,0,0,1]],[[7,1,1,1]]]
-- result [[6,0,0,1],[4,1,0,0],[1,0,1,0],[3,1,1,0],[7,1,1,1]]
sumMultPolynomials :: [[[Int]]] -> [[Int]]
sumMultPolynomials [] = []
sumMultPolynomials [[[]]] = []
sumMultPolynomials polyList = normalizePolynomial (sumPolynomials (head polyList) (sumMultPolynomials (tail polyList)))