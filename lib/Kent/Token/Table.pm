package Kent::Token::Table;

use common::sense;

our @table = (

    [ qr{^(\s+)},                'SPACE' ],
    [ qr/[A-Za-z][A-Za-z0-9_]*/, 'ID' ],
    [ qr/^:/,                    'OP_NMSPC' ],
    [ qr/^[.]/,                  'DOT' ],
    [ qr/^(\d+)/,                'DIGITS' ],
    [ qr/^'/,                    'Q' ],
    [ qr/^"/,                    'DQ' ],
    [ qr/^`/,                    'BQ' ],

    [ qr/^==/, 'OP_EQ' ],
    [ qr/^=</, 'OP_LE' ],
    [ qr/^</,  'OP_LT' ],
    [ qr/^>=/, 'OP_GE' ],
    [ qr/^>/,  'OP_GT' ],

    [ qr/^=/,  'OP_SET' ],
    [ qr/^;/,  'OP_SEMI' ],
    [ qr/^\(/, 'OP_EXPR_START' ],
    [ qr/^\)/, 'OP_EXPR_END' ],
    [ qr/^,/,  'OP_LIST_NEXT' ],
    [ qr/^{/,  'OP_SCOPE_START' ],
    [ qr/^}/,  'OP_SCOPE_END' ],

    [ qr/^(#.*?\n)/, 'COMMENT' ],

    [ qr/^[+]{2}/, 'OP_INCR' ],
    [ qr/^[+]/,    'OP_ADD' ],
    [ qr/^\**/,    'OP_POW' ],
    [ qr/^\*/,     'OP_MUL' ],
    [ qr[/],       'OP_DIV' ],
    [ qr/^--/,     'OP_DECR' ],
    [ qr/^-/,      'MINUS' ],

);

1;
