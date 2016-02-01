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
# [1] Token name - No longer required to be unique.
# [2] Next Context - the set of rules that should be used for lexing after this
#     token. This context effectively creates another level of state machine in
#     the parser. Is this a good idea? IDK, but it makes some of my questions go
#     away, so *fneh*
#
sub code_rules {
    return [
    [ qr/^$/,                       'EOF',           'eof',     ],

    # Tokens that cause us to move to a different context
    # The quoting stuff returns the wrong number of characters.
    # I don't care right now, since I'm going to replace all that syntax soon
    # anyway. Allowing ["literal [interpolated] literal "] is a mistake.
    [ qr/^([$qchars])"/,            'IQUOTE_BEGIN',  'iquote',  ],
    [ qr/^([$qchars])'/,            'NQUOTE_BEGIN',  'nquote',  ],
    [ '/*',                         'CMT_BEGIN',     'comment', ],

    # Basics
    [ qr/^([\t\f\r ]+)/,            's_SPACE',       'code',    ],
    [ qr/^(\n)/,                    's_NEWLINE',     'code',    ],
    [ qr/^([A-Za-z][A-Za-z0-9_]*)/, 's_ID',          'code',    ],
    [ '.',                          's_DOT',         'code',    ],
    [ ':',                          's_COLON',       'code',    ],
    [ qr/^(\d+)/,                   's_DIGITS',      'code',    ],
    [ '\\',                         's_ESC',         'code',    ],

    # Comparison
    # TODO: Heredocs; binary shifting.
    [ '<=>',                        'o_NCMP',        'code',    ],
    [ '==',                         'o_EQ',          'code',    ],
    [ '=<',                         'o_LE',          'code',    ],
    [ '>=',                         'o_GE',          'code',    ],
    [ '<',                          'o_LT',          'code',    ],
    [ '>',                          'o_GT',          'code',    ],

    # Basic Syntax
    [ '=',                          'o_SET',         'code',    ],
    [ ';',                          'o_SEMI',        'code',    ],
    [ '(',                          'o_EXPR_BEGIN',  'code',    ],
    [ ')',                          'o_EXPR_END',    'code',    ],
    [ ',',                          'o_NEXT',        'code',    ],
    [ '{',                          'o_SCOPE_BEGIN', 'code',    ],
    [ '}',                          'o_SCOPE_END',   'code',    ],

    # Arithmetic
    [ '++',                         'o_INCR_1',      'code',    ],
    [ '+=',                         'o_INCR',        'code',    ],
    [ '+',                          'o_ADD',         'code',    ],
    [ '**',                         'o_POW',         'code',    ],
    [ '*',                          'o_MUL',         'code',    ],
    [ '/',                          'o_DIV',         'code',    ],
    [ '--',                         'o_DECR_1',      'code',    ],
    [ '-=',                         'o_DECR',        'code',    ],
    [ '-',                          's_MINUS',       'code',    ], ];
}

sub comment_rules {
    return [
    [ qr/^$/,                       'EOF',           'die',     ],
    [ '*/',                         'CMT_END',       'code',    ],
    [ qr/(.)/,                      'CHAR',          'comment', ], ];
}

sub nquote_rules {
    # $quote_begin does not include the single-quote.
    my $quote_begin = shift;
    my $quote_end = $pairs{$quote_begin};
    return [
        [ qr/^$/,                   'EOF',           'die',     ],
        [ qr/^\\(.)/,               'CHAR',          'nquote',  ],
        [ qr/^'\Q$quote_end\E/,     'STR_END',       'code',    ],
        [ qr/(.)/,                  'CHAR',          'nquote',  ],
    ];
}

sub iquote_rules {
    # $quote_begin does not include the double-quote.
    my $quote_begin = shift;
    my $quote_end   = $pairs{$quote_begin};
    return [
        [ qr/^$/,                   'EOF',           'die',    ],
        [ qr/^\\(.)/,               'CHAR',          'iquote', ],
        [ qr/^'\Q$quote_end\E/,     'STR_END',       'code',   ],
        [ qr/(.)/,                  'CHAR',          'iquote', ],
    ];
}

# I wonder how expensive this is. I wonder if I should cache it
sub table {
    my ( $rule_table_ar ) = @_;

        my $table = [];
        push @{ $table }, { 'regex'        => $_->[0],
                            'name'         => $_->[1],
                            'next_context' => $_->[2] } foreach @{ $rule_table_ar };
        return $table;
}

# tidyon
1;
