-- Gets a tuple with the power of the variable and a letter associated to it, then it transforms it into a string
formatVarExponent :: (Int, Char) -> String
formatVarExponent (0,x) = []
formatVarExponent (1,x) = [x]
formatVarExponent (n,x) = [x]++"^"++show n

-- Transforms all of the variables of a polynomial into readable strings
formatVarExponentList :: [Int] -> Char -> String
formatVarExponentList [] y = []
formatVarExponentList (x:xs) y = formatVarExponent(x,y) ++ formatVarExponentList xs (succ y) 

-- Gets a polynomial and makes a string attaching the coefficient to its variables
formatPoly :: [Int] -> String
formatPoly (x:xs) | (x>0) = "+" ++ show x ++ formatVarExponentList (xs) 'a'
                  | (x<0) = show x ++ formatVarExponentList (xs) 'a'

-- Transforms a list of polynomials into a readable string with letters associated to variables
formatPolyList :: [[Int]] -> String
formatPolyList [] = []
formatPolyList [[]] = []
formatPolyList (x:xs) | (head x/=0) = formatPoly x  ++ " " ++ formatPolyList xs
                      | otherwise = []

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

-- TEST CASE formatPolyList (normalizePolynomial [[1,1,1,0], [3,2,1,0], [4,1,1,0], [0,1,1,0], [2,2,1,0], [4,0,0,0]])
-- which is +1ab +3a^2b +4ab +2a^2b + 4
-- formatted result is +5ab +5a^2b +4
-- list result is [[5,1,1,0],[5,2,1,0],[4,0,0,0]]

normalizePolynomial :: [[Int]] -> [[Int]]
normalizePolynomial [] = []
normalizePolynomial [[]] = [[]]
normalizePolynomial poly = [sumAllEqFactors poly (findEquivalentFactors (poly !! 0) poly)] ++ normalizePolynomial (dropTableIndexes poly (findEquivalentFactors (poly !! 0) poly))

-- Sum polynomials
-- take the two polynomials and ++
-- normalize the generated polynomial

-- TEST CASE formatPolyList (sumPolynomials [[1,0,0,1],[3,1,0,0],[1,0,1,0]] [[3,1,1,0],[1,1,0,0],[5,0,0,1]])
-- which is (1c + 3a + 1b) + (3ab + 1a + 5c)
-- formatted result is "+6c +4a +1b +3ab "
-- list result [[6,0,0,1],[4,1,0,0],[1,0,1,0],[3,1,1,0]]

sumPolynomials :: [[Int]] -> [[Int]] -> [[Int]]
sumPolynomials [[]] [[]] =[]
sumPolynomials [[]] y = y
sumPolynomials x [[]] = x
sumPolynomials x y = normalizePolynomial (x ++ y)

-- Sum an array of polynomials
-- recursively take the head of the array, sum with the rest of the array and normalize

-- TEST CASE formatPolyList (sumPolynomialsList [[[1,0,0,1],[3,1,0,0],[1,0,1,0]],[[3,1,1,0],[1,1,0,0],[5,0,0,1]],[[7,1,1,1]]])
-- which is (1c + 3a +1b) + (3ab + 1a + 5c) + (7abc)
-- formatted result is +6c +4a +1b +3ab +7abc
-- list result [[6,0,0,1],[4,1,0,0],[1,0,1,0],[3,1,1,0],[7,1,1,1]]

sumPolynomialsList :: [[[Int]]] -> [[Int]]
sumPolynomialsList [] = []
sumPolynomialsList [[[]]] = []
sumPolynomialsList polyList = normalizePolynomial (sumPolynomials (head polyList) (sumPolynomialsList (tail polyList)))

-- Sum two arrays by indexes
sumIndexesArrays :: [Int] -> [Int] -> [Int]
sumIndexesArrays [] [] = []
sumIndexesArrays (x:xs) (y:ys) = [x + y] ++ sumIndexesArrays xs ys

-- Multiply two factors
multiplyFactors :: [Int] -> [Int] -> [Int]
multiplyFactors (x:xs) (y:ys) = [x * y] ++ sumIndexesArrays xs ys

-- Multiply a factor and a polynomial
multiplyFactorPolynomial :: [Int] -> [[Int]] -> [[Int]]
multiplyFactorPolynomial factor [] = []
multiplyFactorPolynomial factor poly = [multiplyFactors factor (head poly)] ++ multiplyFactorPolynomial factor (tail poly)

-- Multiply two Polynomials
-- use multiplyFactorPolynomial to multiply every factor of the first polynomial by the second one and then normalize the result
-- TEST CASE formatPolyList (multiplyPolynomials [[2,1,0], [4,0,1]] [[3,1,2], [(-5),0,0]])
-- which is (2a + 4b) * (3ab^2 -5)
-- formatted result is +6a^2b^2 -10a +12ab^3 -20b
-- list result [[6,2,2],[-10,1,0],[12,1,3],[-20,0,1]]

multiplyPolynomials :: [[Int]] -> [[Int]] -> [[Int]]
multiplyPolynomials [] y = []
multiplyPolynomials x y = normalizePolynomial ((multiplyFactorPolynomial (head x) y) ++ multiplyPolynomials (tail x) y)

-- Multiply an array of polynomials
-- first multiply the first two polynomials of the array using multiplyPolynomials
-- then concat the result with the list of the rest of the array not used, dropping the first two elements of the array
-- recursively do that until it rests 1 element in the array

-- TEST CASE formatPolyList (multiplyPolynomialsList [[[1,1,0], [1,0,1]], [[1,1,0], [1,0,1]], [[1,1,0], [1,0,1]]])
-- which is (1a + 1b) * (1a + 1b) * (1a + 1b)
-- formatted result is +1a^3 +3a^2b +3ab^2 +1b^3
-- list result is [[1,3,0],[3,2,1],[3,1,2],[1,0,3]]

multiplyPolynomialsList :: [[[Int]]] -> [[Int]]
multiplyPolynomialsList array | length array == 1 = head array
    | otherwise = multiplyPolynomialsList ([multiplyPolynomials (head array) (array !! 1)] ++ (drop 2 array))

-- Derivate 
-- The second input of Int type is the position of the variable that we should derive for.
-- If the variable chosen doesn't exist in the polynomial, the input is returned unchanged
-- otherwise we return a list with:
-- as head, the starting coefficient multiplicated with the coefficient of the variable we derive for
-- the rest of the polynomial until the variable we derive for
-- the variable we derive for but with power decreased by 1
-- the rest of the list after the variable we derive for

derivate :: [Int] -> Int -> [Int]
derivate x y | ((y > (length x)-1) || y < 1) = x
             | ((x !! y )<1) = x
             | otherwise = [head(x)*n] ++ (tail (take (y) x)) ++ [n-1] ++ (drop (y+1) x)
               where n = x !! y


-- Derivative of a polynomial 
-- Does the derivative for all the polynomials in the list

-- TEST CASE: formatPolyList (derivatePolynomials [[3,4,3,6],[5,0,2,1],[2,1,3,8]] 3)
-- which is (3a^4b^3c^6 + 5b^2c + 2ab^3c^8) derived for c
-- formatted result is +18a^4b^3c^5 +5b^2 +16ab^3c^7
-- list result is [[18,4,3,5],[5,0,2,0],[16,1,3,7]]

derivatePolynomials :: [[Int]] -> Int -> [[Int]]
derivatePolynomials [] y = []
derivatePolynomials (x:xs) y = (normalizePolynomial ([derivate x y] ++ derivatePolynomials xs y))
