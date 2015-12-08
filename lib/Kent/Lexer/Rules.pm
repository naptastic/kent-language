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
    [ qr/^$/,                       'EOF',           0     ],

    # Quoting and comments
    [ qr/^[$qchars]\"/,             'QUOTE_BEGIN',   2     ],
    [ '/*',                         'CMT_BEGIN',     2     ],

    # Basics
    [ qr/^([\t\f\r ]+)/,            's_SPACE',       undef ],
    [ qr/^(\n)/,                    's_NEWLINE',     -1    ],
    [ qr/^([A-Za-z][A-Za-z0-9_]*)/, 's_ID',          undef ],
    [ '.',                          's_DOT',         1     ],
    [ ':',                          's_COLON',       1     ],
    [ qr/^(\d+)/,                   's_DIGITS',      undef ],
    [ '\\',                         's_ESC',         1     ],

    # Comparison
    # TODO: Heredocs; binary shifting.
    [ '<=>',                        'o_NCMP',        3     ],
    [ '==',                         'o_EQ',          2     ],
    [ '=<',                         'o_LE',          2     ],
    [ '>=',                         'o_GE',          2     ],
    [ '<',                          'o_LT',          1     ],
    [ '>',                          'o_GT',          1     ],

    # Basic Syntax
    [ '=',                          'o_SET',         1     ],
    [ ';',                          'o_SEMI',        1     ],
    [ '(',                          'o_EXPR_BEGIN',  1     ],
    [ ')',                          'o_EXPR_END',    1     ],
    [ ',',                          'o_NEXT',        1     ],
    [ '{',                          'o_SCOPE_BEGIN', 1     ],
    [ '}',                          'o_SCOPE_END',   1     ],

    # Arithmetic
    [ '++',                         'o_INCR_1',      2     ],
    [ '+=',                         'o_INCR',        2     ],
    [ '+',                          'o_ADD',         1     ],
    [ '**',                         'o_POW',         2     ],
    [ '*',                          'o_MUL',         1     ],
    [ '/',                          'o_DIV',         1     ],
    [ '--',                         'o_DECR_1',      2     ],
    [ '-=',                         'o_DECR',        2     ],
    [ '-',                          's_MINUS',       1     ], );

my @comment_rules = [
    [ qr/^$/,                       'EOF',           0     ],
    [ '*/',                         'CMT_END',       2     ],
    [ qr/^\\(.)/,                   'CHAR',          1     ],
    [ qr/./,                        'CHAR',          1     ], ];

sub quote_rules {
    my $quote_end = %pairs{shift};
    return (
        [ qr/^$/,                   'EOF',           0     ],
        [ qr/^"\Q$quote_end\E/,     'STR_END',       2     ],
        [ qr/^\\(.)/,               'CHAR',          1     ],
        [ qr/./,                    'CHAR',          1     ],
    );
}

sub table {
    my ( $context ) = @_;
    $context //= 'code';

    my $table = [];
    push @$table, { 'regex' => $_->[0],
                    'name'  => $_->[1],
                    'width' => $_->[2], } foreach @{code_rules};
    return $table;
}

# tidyon
1;
