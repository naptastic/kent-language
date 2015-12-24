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
# [2] Next Context - undef if the parser should remain in the same context, or the
#     name of the next context. '_pop' is special; it means exit the current context
#     and return to the previous one.
#
my @code_rules = (
    [ qr/^$/,                       'EOF',           '_pop',   ],

    # Quoting and comments
    [ qr/^[$qchars]"/,              'QUOTE_BEGIN',   'quote'   ],
    [ '/*',                         'CMT_BEGIN',     'comment' ],

    # Basics
    [ qr/^([\t\f\r ]+)/,            's_SPACE',       undef,    ],
    [ qr/^(\n)/,                    's_NEWLINE',     undef,    ],
    [ qr/^([A-Za-z][A-Za-z0-9_]*)/, 's_ID',          undef,    ],
    [ '.',                          's_DOT',         undef,    ],
    [ ':',                          's_COLON',       undef,    ],
    [ qr/^(\d+)/,                   's_DIGITS',      undef,    ],
    [ '\\',                         's_ESC',         undef,    ],

    # Comparison
    # TODO: Heredocs; binary shifting.
    [ '<=>',                        'o_NCMP',        undef,    ],
    [ '==',                         'o_EQ',          undef,    ],
    [ '=<',                         'o_LE',          undef,    ],
    [ '>=',                         'o_GE',          undef,    ],
    [ '<',                          'o_LT',          undef,    ],
    [ '>',                          'o_GT',          undef,    ],

    # Basic Syntax
    [ '=',                          'o_SET',         undef,    ],
    [ ';',                          'o_SEMI',        undef,    ],
    [ '(',                          'o_EXPR_BEGIN',  undef,    ],
    [ ')',                          'o_EXPR_END',    undef,    ],
    [ ',',                          'o_NEXT',        undef,    ],
    [ '{',                          'o_SCOPE_BEGIN', 'code',   ],
    [ '}',                          'o_SCOPE_END',   '_pop',   ],

    # Arithmetic
    [ '++',                         'o_INCR_1',      undef,    ],
    [ '+=',                         'o_INCR',        undef,    ],
    [ '+',                          'o_ADD',         undef,    ],
    [ '**',                         'o_POW',         undef,    ],
    [ '*',                          'o_MUL',         undef,    ],
    [ '/',                          'o_DIV',         undef,    ],
    [ '--',                         'o_DECR_1',      undef,    ],
    [ '-=',                         'o_DECR',        undef,    ],
    [ '-',                          's_MINUS',       undef,    ], );

my @comment_rules = [
    [ qr/^$/,                       'EOF',           undef,    ],
    [ qr/^\\(.)/,                   'CHAR',          undef,    ],
    [ '*/',                         'CMT_END',       '_pop'    ],
    [ qr/(.)/,                      'CHAR',          undef,    ], ];

sub quote_rules {
    my $quote_begin = shift;
    my $quote_end = $pairs{$quote_begin};
    return (
        [ qr/^$/,                   'EOF',           undef,    ],
        [ qr/^\\(.)/,               'CHAR',          undef,    ],
        [ qr/^"\Q$quote_end\E/,     'STR_END',       '_pop',   ],
        [ qr/(.)/,                  'CHAR',          undef,    ],
    );
}

{
    # Table cache. Closed over so nobody can mess with it while using it.
    my $rule_sets = {};

    sub table {
        my ( $context ) = @_;

        if (defined $rule_sets->{$context}) {
            return $rule_sets->{$context};
        }
        else {
            my $table = [];
            push @$table, { 'regex'        => $_->[0],
                            'name'         => $_->[1],
                            'next_context' => $_->[2] } foreach @{code_rules};
            return $rule_sets->{$context} = $table;
        }
    }
}

# tidyon
1;
