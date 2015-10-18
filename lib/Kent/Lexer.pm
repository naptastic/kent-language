package Kent::Lexer;

use Kent::Lexer::Rules    ();
use Kent::Lexer::Keywords ();
use common::sense;

sub new {
    my ( $class, $sourcecode ) = @_;

    my $self = {
        sourcecode => $sourcecode,
        tokens     => [],
        line       => 1,
        column     => 1,
    };

    return bless $self, $class;
}

sub lex {
    my ($self) = @_;

    my @rules = @Kent::Lexer::Rules::table;
    my $matchfound;

    while ( $self->{sourcecode} !~ /^$/ ) {

        #    for (1..10) {
        $matchfound = 0;

        foreach my $rule (@rules) {
            my $regex  = $rule->[0];
            my $action = $rule->[1];

            if ( $self->{sourcecode} =~ s/$regex// ) {
                $self->$action($1);
                $matchfound++;
                last;
            }
        }
        if ( !$matchfound ) { return 0; }
    }
    return $self->{tokens};
}

sub barf {
    my ($self) = @_;

    foreach my $token ( @{ $self->{tokens} } ) {
        print "[$token->{line}, $token->{column}] $token->{name} ";
        if ( exists $token->{raw} ) { print "($token->{raw})"; }
        print "\n";
    }
    return 1;
}

#############################################################################
##  QUOTING  ################################################################
#############################################################################

sub Q {
    my ( $self, $raw ) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'Q',
        'raw'    => $raw,
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column}++;
    return 1;
}

sub DQ {
    my ( $self, $raw ) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'DQ',
        'raw'    => $raw,
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column}++;
    return 1;
}

sub BQ {
    my ( $self, $raw ) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'BQ',
        'raw'    => $raw,
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column}++;
    return 1;
}

#############################################################################
##  THE BASICS  #############################################################
#############################################################################

sub SPACE {
    my ( $self, $raw ) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'SPACE',
        'raw'    => $raw,
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column} += length($raw);
    return 1;
}

sub NEWLINE {
    my ($self) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'NEWLINE',
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{line}++;
    $self->{column} = 0;
    return 1;
}

sub ID {
    my ( $self, $raw ) = @_;

    my $id;

    if ( $Kent::Lexer::Keywords::keywords{$raw}) {        $id = "KW_$raw"; }
    else { $id = 'ID'; }
#    my $id = exists $Kent::Lexer::Keywords::keywords{$raw} ? "KW_$raw" : 'ID';
    push @{ $self->{tokens} },
      {
        'name'   => $id,
        'raw'    => $raw,
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column} += length($raw);
    return 1;
}

sub DOT {
    my ($self) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'DOT',
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column}++;
    return 1;
}

sub COLON {
    my ($self) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'COLON',
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column}++;
    return 1;
}

sub DIGITS {
    my ( $self, $raw ) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'DIGITS',
        'line'   => $self->{line},
        'column' => $self->{column},
        'raw'    => $raw,
      };
    $self->{column} += length($raw);
    return 1;
}

sub ESC {
    my ( $self, $raw ) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'ESC',
        'line'   => $self->{line},
        'column' => $self->{column},
        'raw'    => $raw,
      };
    $self->{column}++;
    return 1;
}

#############################################################################
##  COMPARISON  #############################################################
#############################################################################

sub OP_NCMP {
    my ($self) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'OP_NCMP',
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column} += 3;
    return 1;
}

sub OP_EQ {
    my ($self) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'OP_EQ',
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column} += 2;
    return 1;
}

sub OP_LE {
    my ($self) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'OP_LE',
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column} += 2;
    return 1;
}

sub OP_LT {
    my ($self) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'OP_LT',
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column}++;
    return 1;
}

sub OP_GE {
    my ($self) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'OP_GE',
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column} += 2;
    return 1;
}

sub OP_GT {
    my ($self) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'OP_GT',
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column}++;
    return 1;
}

#############################################################################
##  BASIC SYNTAX  ###########################################################
#############################################################################

sub OP_SET {
    my ($self) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'OP_SET',
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column}++;
    return 1;
}

sub OP_SEMI {
    my ($self) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'OP_SEMI',
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column}++;
    return 1;
}

sub OP_EXPR_START {
    my ($self) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'OP_EXPR_START',
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column}++;
    return 1;
}

sub OP_EXPR_END {
    my ($self) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'OP_EXPR_END',
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column}++;
    return 1;
}

sub OP_NEXT {
    my ($self) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'OP_NEXT',
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column}++;
    return 1;
}

sub OP_SCOPE_START {
    my ($self) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'OP_SCOPE_START',
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column}++;
    return 1;
}

sub OP_SCOPE_END {
    my ($self) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'OP_SCOPE_END',
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column}++;
    return 1;
}

sub COMMENT {
    my ( $self, $raw ) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'COMMENT',
        'line'   => $self->{line},
        'column' => $self->{column},
        'raw'    => $raw,
      };
    $self->{column} += length($raw);
    return 1;
}

#############################################################################
##  MATH  ###################################################################
#############################################################################

sub OP_INCR {
    my ($self) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'OP_INCR',
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column} += 2;
    return 1;
}

sub OP_ADD {
    my ($self) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'OP_ADD',
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column}++;
    return 1;
}

sub OP_POW {
    my ($self) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'OP_POW',
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column} += 2;
    return 1;
}

sub OP_MUL {
    my ($self) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'OP_MUL',
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column}++;
    return 1;
}

sub OP_DIV {
    my ($self) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'OP_DIV',
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column}++;
    return 1;
}

sub OP_DECR {
    my ($self) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'OP_DECR',
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column} += 2;
    return 1;
}

sub MINUS {
    my ($self) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'MINUS',
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column}++;
    return 1;
}

1;
