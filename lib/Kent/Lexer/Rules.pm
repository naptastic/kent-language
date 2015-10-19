package Kent::Lexer::Rules;

use common::sense;

# Regex matching token
# Token name
# Width, or undef for tokens that vary in width

my @rules = (

    # Quoting
    [ qr/^'/, 'Q',  1 ],
    [ qr/^"/, 'DQ', 2 ],
    [ qr/^`/, 'BQ', 2 ],

    # Basics
    [ qr/^([\t\f\r ]+)/,            'SPACE',   undef ],
    [ qr/^\n/,                      'NEWLINE', -1 ],
    [ qr/^([A-Za-z][A-Za-z0-9_]*)/, 'ID',      undef ],
    [ qr/^[.]/,                     'DOT',     1 ],
    [ qr/^:/,                       'COLON',   1 ],
    [ qr/^(\d+)/,                   'DIGITS',  undef ],
    [ qr/^\\/,                      'ESC',     1 ],

    # Comparison
    # TODO: Heredocs; binary shifting.
    [ qr/^<=>/, 'OP_NCMP', 3 ],
    [ qr/^==/,  'OP_EQ',   2 ],
    [ qr/^=</,  'OP_LE',   2 ],
    [ qr/^</,   'OP_LT',   1 ],
    [ qr/^>=/,  'OP_GE',   2 ],
    [ qr/^>/,   'OP_GT',   1 ],

    # Basic Syntax
    [ qr/^=/,  'OP_SET',         1 ],
    [ qr/^;/,  'OP_SEMI',        1 ],
    [ qr/^\(/, 'OP_EXPR_START',  1 ],
    [ qr/^\)/, 'OP_EXPR_END',    1 ],
    [ qr/^,/,  'OP_NEXT',        1 ],
    [ qr/^{/,  'OP_SCOPE_START', 1 ],
    [ qr/^}/,  'OP_SCOPE_END',   1 ],

    # Comments
    [ qr/^(#[^\n]*)/, 'COMMENT', undef ],

    # Math
    [ qr/^[+]{2}/, 'OP_INCR', 2 ],
    [ qr/^[+]/,    'OP_ADD',  1 ],
    [ qr/^\*\*/,   'OP_POW',  2 ],
    [ qr/^\*/,     'OP_MUL',  1 ],
    [ qr{^/},      'OP_DIV',  1 ],
    [ qr/^--/,     'OP_DECR', 2 ],
    [ qr/^-/,      'MINUS',   1 ],

);

sub table {
    my $table = [];
    foreach my $rule_ar (@rules) {
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
