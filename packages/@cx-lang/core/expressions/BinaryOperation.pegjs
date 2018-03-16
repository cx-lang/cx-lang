/*
    a .. b            // RANGE(a, b)
    a ...             // REST(a)
    ... a             // SPREAD(a)
    a | b             // XOR(a, b)
    a & b             // XAND(a, b)
    a > b             // HIGHER(a, b)
    a < b             // LOWER(a, b)
    a + b             // PLUS(a, b)
    a - b             // MINUS(a, b)
    a / b             // DIVIDE(a, b)
    a * b             // MULTIPLY(a, b)
    a ^ b             // SQUARE_ROOT(a, b)
    a > or = b        // HIGHER_OR_EQUAL(a, b)
    a < or = b        // LOWER_OR_EQUAL(a, b)
    ! a               // FALSE(a)
    !! a              // TRUE(a)
    not a             // FALSE(a)
    a == b            // EQUAL(a, b)
    a equals b        // EQUAL(a, b)
    a || b            // EOR(a, b)
    a or b            // EOR(a, b)
    a && b            // EAND(a, b)
    a and b           // EAND(a, b)
    a != b            // NOT_EQUAL(a, b)
    a not equals b    // NOT_EQUAL(a, b)
*/

BinaryLeft
    = BinaryOperation

BinaryRight
    = BinaryOperation

[
    ast( "type", "BinaryOperation" )
]
BinaryOperation
    = "(" ::BinaryOperation ")"
    / left:BinaryLeft
      operator:BinaryOperator
      operator:BinaryRight

BinaryOperator
    = 
