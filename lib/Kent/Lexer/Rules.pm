package Kent::Lexer::Rules;

use common::sense;

our @table = (

    # Quoting
    [ qr/^'/, 'Q' ],
    [ qr/^"/, 'DQ' ],
    [ qr/^`/, 'BQ' ],

    # Basics
    [ qr/^([\t\f\r ]+)/,            'SPACE' ],
    [ qr/^\n/,                      'NEWLINE' ],
    [ qr/^([A-Za-z][A-Za-z0-9_]*)/, 'ID' ],
    [ qr/^[.]/,                     'DOT' ],
    [ qr/^:/,                       'COLON' ],
    [ qr/^(\d+)/,                   'DIGITS' ],

    # Comparison
    # TODO: Heredocs; binary shifting.
    [ qr/^==/, 'OP_EQ' ],
    [ qr/^=</, 'OP_LE' ],
    [ qr/^</,  'OP_LT' ],
    [ qr/^>=/, 'OP_GE' ],
    [ qr/^>/,  'OP_GT' ],

    # Basic Syntax
    [ qr/^=/,  'OP_SET' ],
    [ qr/^;/,  'OP_SEMI' ],
    [ qr/^\(/, 'OP_EXPR_START' ],
    [ qr/^\)/, 'OP_EXPR_END' ],
    [ qr/^,/,  'OP_NEXT' ],
    [ qr/^{/,  'OP_SCOPE_START' ],
    [ qr/^}/,  'OP_SCOPE_END' ],

    # Comments
    [ qr/^(#[^\n]*)/, 'COMMENT' ],

    # Math
    [ qr/^[+]{2}/, 'OP_INCR' ],
    [ qr/^[+]/,    'OP_ADD' ],
    [ qr/^\*\*/,   'OP_POW' ],
    [ qr/^\*/,     'OP_MUL' ],
    [ qr{^/},      'OP_DIV' ],
    [ qr/^--/,     'OP_DECR' ],
    [ qr/^-/,      'MINUS' ],

);

1;
