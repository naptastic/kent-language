package Kent::Lexer::Rules;

use common::sense;

# Regex matching token. MUST capture, to prevent stale data leaking into the token list.
# Token name - MUST be unique (right now).
# Width, or undef for tokens that vary in width
# next context or undef

my @code_rules = (

    # Quoting
    [ "'",  'q_1',  1 ],
    [ '"',  'q_2',  1 ],
    [ '`',  'q_B',  1 ],
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
    [ qr/^([.])/,                   's_DOT',     1 ],
    [ qr/^(:)/,                     's_COLON',   1 ],
    [ qr/^(\d+)/,                   's_DIGITS',  undef ],
    [ qr/^(\\)/,                    's_ESC',     1 ],

    # Comparison
    # TODO: Heredocs; binary shifting.
    [ qr/^(<=>)/, 'o_NCMP', 3 ],
    [ qr/^(==)/,  'o_EQ',   2 ],
    [ qr/^(=<)/,  'o_LE',   2 ],
    [ qr/^(>=)/,  'o_GE',   2 ],
    [ qr/^(<)/,   'o_LT',   1 ],
    [ qr/^(>)/,   'o_GT',   1 ],

    # Basic Syntax
    [ qr/^(=)/,  'o_SET',         1 ],
    [ qr/^(;)/,  'o_SEMI',        1 ],
    [ qr/^(\()/, 'o_EXPR_BEGIN',  1 ],
    [ qr/^(\))/, 'o_EXPR_END',    1 ],
    [ qr/^(,)/,  'o_NEXT',        1 ],
    [ qr/^({)/,  'o_SCOPE_BEGIN', 1 ],
    [ qr/^(})/,  'o_SCOPE_END',   1 ],

    # Comments
    [ qr/^(#[^\n]*)/, 'COMMENT', undef ],

    # Math
    [ qr/^(\+\+)/, 'o_INCR',  2 ],
    [ qr/^(\+)/,   'o_ADD',   1 ],
    [ qr/^(\*\*)/, 'o_POW',   2 ],
    [ qr/^(\*)/,   'o_MUL',   1 ],
    [ qr{^(/)},    'o_DIV',   1 ],
    [ qr/^(--)/,   'o_DECR',  2 ],
    [ qr/^(-)/,    's_MINUS', 1 ],

);

my @str_1_rules = (

    [ qr/(\\')/, 'n_ESCQ', 2 ],
    [ qr/(')/,   'n_EOS',  1 ],
    [ qr/(.)/,   'n_char', 1 ],

);

my @str_C_rules = (

    [ qr/^(\\")/, 'i_ESCQ', 1 ],
    [ qr/^({)/,   'o_ADD',  1 ],
    [ qr/^(.)/,   'char',   1 ],

);

sub table {
    my ($context) = @_;
    $context //= 'code';

    my $table = [];
    foreach my $rule_ar ( @{code_rules} ) {
        push @$table,
          {
            'regex' => $rule_ar->[0],
            'name'  => $rule_ar->[1],
            'width' => $rule_ar->[2],
          };

    }
    return $table;
}

1;
