# MultVarPolynomialManipulation

Data Structure of a polynomial   

We opted for this structure because it's very flexible, especially when dealing with multiplication.
It manages to store all the information of a polynomial in a list of lists. A list starts with 
the coefficient of the member, and is followed by n elements, where n is the number of variables
in the polynomial. These elements are numbers that indicate the power/exponent of the variable
in that position.
We have written a function capable of getting the output of the functions asked by the exercise, which give 
their output in this list of lists format, and transform it into a readable polynomial expression, with letters
and exponents.


[   
  [first coefficient, var 1 exponent, var 2 exponent, var n exponent],    
  [second coefficient, var 1 exponent, var 2 exponent, var n exponent],   
  [third coefficient, var 1 exponent, var 2 exponent, var n exponent],   
  ...   
  [n coefficient, var 1 exponent, var 2 exponent, var n exponent]
]   

for example A = x^2 + y^2 + 2xyz
[
  [1, 2, 0, 0],
  [1, 0, 2, 0],
  [2, 1, 1, 1]
]



NORMALIZATION OF A POLYNOMIAL
To normalize a polynomial, we first search for the equivalent factors of the head of the polynomial.
Then we sum the equivalent factors and drop them from the polynomial so that only the first remains.
We recursively call the function which, in the end, will concatenate the factors and create the normalized polynomial.

-- TEST CASE: formatPolyList (normalizePolynomial [[1,1,1,0], [3,2,1,0], [4,1,1,0], [0,1,1,0], [2,2,1,0], [4,0,0,0]])
-- which is +1ab +3a^2b +4ab +2a^2b + 4
-- list result is [[5,1,1,0],[5,2,1,0],[4,0,0,0]]
-- formatted result is +5ab +5a^2b +4


SUM OF POLYNOMIALS
To add an element to a polynomial, we simply concatenate the element to the list of lists, then normalize.
To add two different polynomials, we recursively add the elements of a polynomial to the other, then normalize.

-- TEST CASE: formatPolyList (sumPolynomialsList [[[1,0,0,1],[3,1,0,0],[1,0,1,0]],[[3,1,1,0],[1,1,0,0],[5,0,0,1]],[[7,1,1,1]]])
-- which is (1c + 3a +1b) + (3ab + 1a + 5c) + (7abc)
-- list result [[6,0,0,1],[4,1,0,0],[1,0,1,0],[3,1,1,0],[7,1,1,1]]
-- formatted result is +6c +4a +1b +3ab +7abc



MOLTIPLICATION OF POLYNOMIALS
To perform a moltiplication of two elements, we multiply the coefficients and then add the powers of each of the variables, 
creating a list. To multiply two polynomials we multiply the elements recursively and, since we'll get two same results 
from the same multiplication, we drop the excess.

-- TEST CASE formatPolyList (multiplyPolynomials [[2,1,0], [4,0,1]] [[3,1,2], [(-5),0,0]])
-- which is (2a + 4b) * (3ab^2 -5)
-- formatted result is +6a^2b^2 -10a +12ab^3 -20b
-- list result [[6,2,2],[-10,1,0],[12,1,3],[-20,0,1]]


-- TEST CASE: formatPolyList (multiplyPolynomialsList [[[1,1,0], [1,0,1]], [[1,1,0], [1,0,1]], [[1,1,0], [1,0,1]]])
-- which is (1a + 1b) * (1a + 1b) * (1a + 1b)
-- formatted result is +1a^3 +3a^2b +3ab^2 +1b^3
-- list result is [[1,3,0],[3,2,1],[3,1,2],[1,0,3]]



DERIVATIVE OF POLYNOMIALS
We get as an input the polynomials and the variable for which we should derive, expressed as its position in the array.
We then recursively use a function that derivates each single element: it multiplies the coefficient with the power of the
variable, then decreases the power of the variable by 1.

-- TEST CASE: formatPolyList (derivatePolynomials [[3,4,3,6],[5,0,2,1],[2,1,3,8]] 3)
-- which is (3a^4b^3c^6 + 5b^2c + 2ab^3c^8) derivated for c
-- formatted result is +18a^4b^3c^5 +5b^2 +16ab^3c^7
-- list result is [[18,4,3,5],[5,0,2,0],[16,1,3,7]]
