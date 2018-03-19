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
our $qchars = join '\\', @qchars;

our %pairs = ( @qchars, reverse @qchars );

sub rules_by_context {
    my ( $context ) = @_;

    if ( $context eq 'code' )    { return table( code_rules() ); }
    if ( $context eq 'comment' ) { return table( comment_rules() ); }
    if ( $context eq 'iquote' )  { return table( iquote_rules() ); }
    if ( $context eq 'nquote' )  { return table( nquote_rules() ); }

    die "Unknown lexer context '$context'";
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
    [ qr/^$/,                       'eof',           'eof',     ],

    # Tokens that cause us to move to a different context
    # The quoting stuff returns the wrong number of characters.
    # I don't care right now, since I'm going to replace all that syntax soon
    # anyway. Allowing ["literal [interpolated] literal "] is a mistake.
    [ qr/^([$qchars])"/,            'IQUOTE_BEGIN',  'iquote',  ],
    [ qr/^([$qchars])'/,            'NQUOTE_BEGIN',  'nquote',  ],
    [ '/* ',                        'CMT_BEGIN',     'comment', ],

    # Basics
    # TODO: Forbid tabs
    [ qr/^([\t\f\r ]+)/,                     'space',         'code',    ],
    [ "\n",                                  'space',         'code',    ],
    [ qr/^([A-Za-z_][A-Za-z0-9_]*)/,         'id',            'code',    ],
    [ qr/^(0x[0-9A-Fa-f]+)/,                 'hex',           'code',    ],
    [ qr/^(0[0-7]+)/,                        'oct',           'code',    ],
    [ qr/^(-?[1-9][0-9]*)/,                  'int',           'code',    ],
    [ qr/^(-?[1-9][0-9]*\.[0-9]+)/,          'rat',           'code',    ],
    [ qr/^(-?[1-9]\.[0-9]+-?e[1-9][0-9]*)/i, 'sci',           'code',    ],
    [ '..',                                  'dotdot',        'code',    ],
    [ '.',                                   'dot',           'code',    ],
    [ '::',                                  'coloncolon',    'code',    ],
    [ ':',                                   'colon',         'code',    ], # somehow this isn't used anywhere.
    [ '%',                                   'percent',       'code',    ],
    [ '\\',                                  'bslashbslash',  'code',    ],

    # Comparison
    # TODO: Heredocs
    [ '<=>',                        'cmp',           'code',    ],
    [ '=>',                         'hashrocket',    'code',    ],
    [ '==',                         'eqeq',          'code',    ],
    [ '~~',                         'match',         'code',    ],
    [ '!~',                         'nomatch',       'code',    ],
    [ '!<',                         'nlt',           'code',    ],
    [ '!>',                         'ngt',           'code',    ],
    [ '||',                         'logor',         'code',    ],
    [ '&&',                         'logand',        'code',    ],
    [ '^^',                         'logxor',        'code',    ],
    [ '|',                          'binor',         'code',    ],
    [ '&',                          'binand',        'code',    ],
    [ '^',                          'binxor',        'code',    ],
    [ '<-',                         'compose',       'code',    ],
    [ '<<',                         'shl',           'code',    ],
    [ '>>',                         'shr',           'code',    ],
    [ '<',                          'lt',            'code',    ],
    [ '>',                          'gt',            'code',    ],

    # Basic Syntax
    [ '=',                          'eq',            'code',    ],
    [ ';',                          'semicolon',     'code',    ], # somehow this isn't used anywhere.
    [ '(',                          'lparen',        'code',    ],
    [ ')',                          'rparen',        'code',    ],
    [ ',',                          'comma',         'code',    ],
    [ '{',                          'lcurly',        'code',    ],
    [ '}',                          'rcurly',        'code',    ],
    [ '[',                          'lbrace',        'code',    ],
    [ ']',                          'rbrace',        'code',    ],

    # Arithmetic
    [ '++',                         'plusplus',      'code',    ],
    [ '+=',                         'pluseq',        'code',    ],
    [ '+',                          'plus',          'code',    ],
    [ '**',                         'starstar',      'code',    ],
    [ '*',                          'star',          'code',    ],
    [ '/',                          'fslash',        'code',    ],
    [ '--',                         'minusminus',    'code',    ],
    [ '-=',                         'minuseq',       'code',    ],
    [ '-',                          'minus',         'code',    ], ];
}

sub comment_rules {
    return [
    [ qr/^$/,                       'EOF',           'die',     ],
    [ ' */',                        'CMT_END',       'code',    ],
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
