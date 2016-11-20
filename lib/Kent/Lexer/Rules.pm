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

our $rules = {
    code => code_rules(),
    cmnt => comment_rules(),
}

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

        #    [ qr/^([$qchars])"/,            'IQUOTE_BEGIN',  'iquote',  ],
        #    [ qr/^([$qchars])'/,            'NQUOTE_BEGIN',  'nquote',  ],

        # These used to be in a more logical order, but I realized there
        # were precedence problems, so now they're sorted by longest to
        # shortest.

        [ qr/^$/, 'eof', ],
        [ qr/^([\t\f\r ]+)/,               'ws',          ],
        [ qr/^(\n)/,                       'newline',     ],
        [ qr/^([A-Za-z][A-Za-z0-9_]+)/,    'id',          ],
        [ qr/^(0x[0-9a-fA-F]+)/,           'hex',         ],
        [ qr/^(0[0-7]+)/,                  'oct',         ],
        [ qr/^(-?[1-9][0-9]+/,             'int',         ],
        [ qr/^(-?[1-9][0-9][.][0-9]+)/,    'rat',         ],
        [ qr/^(-?[1-9][.][0-9]+e-?[0-9]+/, 'sci',         ],
        [ '/* ',                           'lcmnt',       ],
        [ ' */',                           'rcmnt',       ],
        [ '<=>',                           'spaceship',   ],
        [ '=>',                            'keypair',     ],
        [ '==',                            'eqeq',        ],
        [ '<<',                            'shl',         ],
        [ '>>',                            'shr',         ],
        [ '!>',                            'ngt',         ],
        [ '!<',                            'nlt',         ],
        [ '++',                            'plusplus',    ],
        [ '+=',                            'pluseq',      ],
        [ '**',                            'starstar',    ],
        [ '--',                            'minusminus',  ],
        [ '-=',                            'minuseq',     ],
        [ '::',                            'coloncolon',  ],
        [ '!',                             'bang',        ],
        [ '+',                             'plus',        ],
        [ '*',                             'star',        ],
        [ '/',                             'fslash',      ],
        [ ';',                             'semicolon',   ],
        [ '(',                             'lparen',      ],
        [ ')',                             'rparen',      ],
        [ ',',                             'comma',       ],
        [ '{',                             'lcurly',      ],
        [ '}',                             'rcurly',      ],
        [ '<',                             'lt',          ],
        [ '>',                             'gt',          ],
        [ '-',                             'minus',       ],
        [ '=',                             'eq',          ],
        [ "'",                             'squote',      ], # Plans for these but not using yet
        [ '"',                             'dquote',      ],
        [ ':',                             'colon',       ], # No plans for these yet
        [ '\\',                            'bslash',      ],
        [ '.',                             'dot',         ],
    ];
}

sub comment_rules {
    return [
        [ qr/^$/,  'eof',      ],
        [ ' */',   'rcomment', ],
        [ qr/(.)/, 'char',     ],
    ];
}

sub nquote_rules {

    # $quote_begin does not include the single-quote.
    my $quote_begin = shift;
    my $quote_end   = $pairs{$quote_begin};
    return [ 
            [ qr/^$/,               'eof',     ],
            [ qr/^\\(.)/,           'char',    ],
            [ qr/^'\Q$quote_end\E/, 'STR_END', ],
            [ qr/(.)/,              'char',    ],
    ];
}

sub iquote_rules {

    # $quote_begin does not include the double-quote.
    my $quote_begin = shift;
    my $quote_end   = $pairs{$quote_begin};
    return [
            [ qr/^$/,               'eof',     ],
            [ qr/^\\(.)/,           'char',    ],
            [ qr/^'\Q$quote_end\E/, 'STR_END', ],
            [ qr/(.)/,              'char',    ],
    ];
}

# I wonder how expensive this is. I wonder if I should cache it.
sub table {
    my ( $rule_table_ar ) = @_;

        my $table = [];
        push @{ $table }, { 'regex'        => $_->[0],
                            'name'         => $_->[1], } foreach @{ $rule_table_ar };
        return $table;
}

# tidyon
1;
