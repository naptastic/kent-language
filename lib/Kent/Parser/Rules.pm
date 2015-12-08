package Kent::Parser::Rules;

use common::sense;

our @rules = (

    # This file is just a scratchpad for ideas right now, because I really
    # don't know what I'm doing.

#    [ qr/CMT_BEGIN$/,              undef,               'Kent::Comment' ],
    [ qr/CMT_BEGIN CHAR CMT_END$/, 'Kent::Comment::new', undef          ],
    [ qr/CHAR CHAR/,               'Kent::Char::new',    undef          ],

#    [ qr/ (DIGITS)? (DOT)? (DIGITS) /x, 'Number', ],
#    [ qr/ Number OP_ADD Number /x,     'Addition', ],

    # A block is an array of zero or more statements.
    # A statement is a structure made of expressions.
    # Expressions have many possible forms.

    # Conditionals

    # statement?
    # expression?
    # math op?

    # TERNARY    := EXPR ? STMT : STMT
    # ASSIGN     := FQID '=' EXPR
    # FQID       := ID (DOT ID)*
    # TERM       := ID | NUMBER | STRING
    # ARITH      := TERM (arithmetic operator) TERM

#    [ qr/ (ID)? (DOT ID) /x, 'Access' ],
);
