package Kent::Lexer::Rules;

use common::sense;

# Regex matching token. MUST capture, to prevent stale data leaking into the token list.
# Token name - MUST be unique (right now).
# Width, or undef for tokens that vary in width
# next context or undef

my @code_rules = (

    # Quoting
    [ "'", 'q_1', 1 ],
    [ '"', 'q_2', 1 ],
    [ '`', 'q_B', 1 ],

    # p.sure I don't like where this is going. Basically all of these
    # introduce ambiguities into the language which require whitespace
    # to resolve. I don't think I want to set that precedent.
    [ '<"', 'qb_A', 2 ],    # Quote with Angle brackets
    [ '{"', 'qb_C', 2 ],    # Quote with Curly braces
    [ '("', 'qb_P', 2 ],    # Quote with Parenthesis
    [ '["', 'qb_S', 2 ],    # Quote with Square brackets
    [ '">', 'qe_A', 2 ],    # Quote with Angle brackets
    [ '"}', 'qe_C', 2 ],    # Quote with Curly braces
    [ '")', 'qe_P', 2 ],    # Quote with Parenthesis
    [ '"]', 'qe_S', 2 ],    # Quote with Square brackets

    # Basics
    [ qr/^([\t\f\r ]+)/,            's_SPACE',   undef ],
    [ qr/^(\n)/,                    's_NEWLINE', -1 ],
    [ qr/^([A-Za-z][A-Za-z0-9_]*)/, 's_ID',      undef ],
    [ '.',                          's_DOT',     1 ],
    [ ':',                          's_COLON',   1 ],
    [ qr/^(\d+)/,                   's_DIGITS',  undef ],
    [ '\\',                         's_ESC',     1 ],

    # Comparison
    # TODO: Heredocs; binary shifting.
    [ '<=>', 'o_NCMP', 3 ],
    [ '==',  'o_EQ',   2 ],
    [ '=<',  'o_LE',   2 ],
    [ '>=',  'o_GE',   2 ],
    [ '<',   'o_LT',   1 ],
    [ '>',   'o_GT',   1 ],

    # Basic Syntax
    [ '=', 'o_SET',         1 ],
    [ ';', 'o_SEMI',        1 ],
    [ '(', 'o_EXPR_BEGIN',  1 ],
    [ ')', 'o_EXPR_END',    1 ],
    [ ',', 'o_NEXT',        1 ],
    [ '{', 'o_SCOPE_BEGIN', 1 ],
    [ '}', 'o_SCOPE_END',   1 ],

    # Comments
    [ qr/^(#[^\n]*)/, 'COMMENT', undef ],

    # Arithmetic
    [ '++', 'o_INCR_1', 2 ],
    [ '+=', 'o_INCR',   2 ],
    [ '+',  'o_ADD',    1 ],
    [ '**', 'o_POW',    2 ],
    [ '*',  'o_MUL',    1 ],
    [ '/',  'o_DIV',    1 ],
    [ '--', 'o_DECR_1', 2 ],
    [ '-=', 'o_DECR',   2 ],
    [ '-',  's_MINUS',  1 ], );

my @str_1_rules = (

    [ q{\\'},   'n_ESCQ', 2 ],
    [ q{'},     'n_EOS',  1 ],
    [ qr/^(.)/, 'n_char', 1 ],

);

my @str_C_rules = (

    [ q{\\"},   'i_ESCQ', 1 ],
    [ '{',      'o_ADD',  1 ],
    [ qr/^(.)/, 'char',   1 ],

);

# Not sure I like where this is going.
# tidyoff
my %pairs = ( qw| ' ' " " < > ( ) [ ]
                  « » ᚛ ᚜ “ ” ‟ ” ‹ ›
                  ⁅ ⁆ ∈ ∋ ∊ ∍ ≒ ≓ ≤ ≥
                  ≶ ≷ ≺ ≻ ≼ ≽ ⊂ ⊃ ⊆ ⊇
                  ⊊ ⊋ ⊏ ⊐ ⊑ ⊒ ⊢ ⊣ ⊦ ⫞
                  ⊰ ⊱ ⊲ ⊳ ⊴ ⊵ ⋐ ⋑ ⋖ ⋗
                  ⋘ ⋙ ⋚ ⋛ ⋜ ⋝ ⋞ ⋟ ⋠ ⋡
                  ⋢ ⋣ ⋤ ⋥ ⋰ ⋱ ⟅ ⟆ ⟦ ⟧
                  ⟪ ⟫ ⦑ ⦒ ⧘ ⧙ ⧼ ⧽ ⪿ ⫀
                  ⫁ ⫂ ⫕ ⫖ ⸄ ⸅ ⸠ ⸡ ｢ ｣ | );
# tidyon

# Make all pairs symmetric; IOW, they can be used in either direction.
foreach ( sort keys %pairs ) { $pairs{ $pairs{ $_ } } = $_; }

sub table {
    my ( $context ) = @_;
    $context //= 'code';

    #tidyoff
    my $table = [];
    push @$table, { 'regex' => $_->[0],
                    'name'  => $_->[1],
                    'width' => $_->[2], } foreach @{code_rules};
    return $table;
    #tidyon
}

1;
