package Kent::Parser::Rules;

use common::sense;

our @rules = (

    [ qr/ (DIGITS)? (DOT) (DIGITS) /x, 'Number', ],
    [ qr/ Number OP_ADD Number /x,     'Addition', ],

    # statement?
    # expression?
    # math op?
    # Ternary op - that ought to be fun
    [ qr/ (ID)? (DOT ID) /x, 'Access' ],

);
