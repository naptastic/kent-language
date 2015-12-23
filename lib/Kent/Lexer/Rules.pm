package Kent::Lexer::Rules;

# tidyoff
use common::sense;

our @qchars = ( qw| ' ' " " < > ( ) [ ]
                    « » ᚛ ᚜ “ ” ‟ ” ‹ ›
                    ⁅ ⁆ ∈ ∋ ∊ ∍ ≒ ≓ ≤ ≥
                    ≶ ≷ ≺ ≻ ≼ ≽ ⊂ ⊃ ⊆ ⊇
                    ⊊ ⊋ ⊏ ⊐ ⊑ ⊒ ⊢ ⊣ ⊦ ⫞
                    ⊰ ⊱ ⊲ ⊳ ⊴ ⊵ ⋐ ⋑ ⋖ ⋗
                    ⋘ ⋙ ⋚ ⋛ ⋜ ⋝ ⋞ ⋟ ⋠ ⋡
                    ⋢ ⋣ ⋤ ⋥ ⋰ ⋱ ⟅ ⟆ ⟦ ⟧
                    ⟪ ⟫ ⦑ ⦒ ⧘ ⧙ ⧼ ⧽ ⪿ ⫀
                    ⫁ ⫂ ⫕ ⫖ ⸄ ⸅ ⸠ ⸡ ｢ ｣
                    { }                 | );

# otherwise this will be interpolated with spaces, which would cause problems.
our $qchars = join '', @qchars;

our %pairs = ( @qchars, reverse @qchars );

#
# RULES TABLES: Every rule is an arrayref consisting of:
#
# [0] String or regex matching token.
#     if regex, it MUST capture, to prevent stale data leaking into the token list.
# [1] Token name - MUST be unique (right now).
# [2] Width: 0 for EOF, -1 for newline, undef for vaiable width, or literal width.
#
my @code_rules = (
    [ qr/^$/,                       'EOF',           ],

    # Quoting and comments
    [ qr/^[$qchars]"/,              'QUOTE_BEGIN',   ],
    [ '/*',                         'CMT_BEGIN',     ],

    # Basics
    [ qr/^([\t\f\r ]+)/,            's_SPACE',       ],
    [ qr/^(\n)/,                    's_NEWLINE',     ],
    [ qr/^([A-Za-z][A-Za-z0-9_]*)/, 's_ID',          ],
    [ '.',                          's_DOT',         ],
    [ ':',                          's_COLON',       ],
    [ qr/^(\d+)/,                   's_DIGITS',      ],
    [ '\\',                         's_ESC',         ],

    # Comparison
    # TODO: Heredocs; binary shifting.
    [ '<=>',                        'o_NCMP',        ],
    [ '==',                         'o_EQ',          ],
    [ '=<',                         'o_LE',          ],
    [ '>=',                         'o_GE',          ],
    [ '<',                          'o_LT',          ],
    [ '>',                          'o_GT',          ],

    # Basic Syntax
    [ '=',                          'o_SET',         ],
    [ ';',                          'o_SEMI',        ],
    [ '(',                          'o_EXPR_BEGIN',  ],
    [ ')',                          'o_EXPR_END',    ],
    [ ',',                          'o_NEXT',        ],
    [ '{',                          'o_SCOPE_BEGIN', ],
    [ '}',                          'o_SCOPE_END',   ],

    # Arithmetic
    [ '++',                         'o_INCR_1',      ],
    [ '+=',                         'o_INCR',        ],
    [ '+',                          'o_ADD',         ],
    [ '**',                         'o_POW',         ],
    [ '*',                          'o_MUL',         ],
    [ '/',                          'o_DIV',         ],
    [ '--',                         'o_DECR_1',      ],
    [ '-=',                         'o_DECR',        ],
    [ '-',                          's_MINUS',       ], );

my @comment_rules = [
    [ qr/^$/,                       'EOF',           ],
    [ qr/^\\(.)/,                   'CHAR',          ],
    [ '*/',                         'CMT_END',       ],
    [ qr/(.)/,                      'CHAR',          ], ];

sub quote_rules {
    my $quote_begin = shift;
    my $quote_end = $pairs{$quote_begin};
    return (
        [ qr/^$/,                   'EOF',           ],
        [ qr/^\\(.)/,               'CHAR',          ],
        [ qr/^"\Q$quote_end\E/,     'STR_END',       ],
        [ qr/(.)/,                  'CHAR',          ],
    );
}

sub table {
    my ( $context ) = @_;
    $context //= 'code';

    my $table = [];
    push @$table, { 'regex' => $_->[0],
                    'name'  => $_->[1], } foreach @{code_rules};
    return $table;
}

# tidyon
1;
