package Kent::Lexer;

use Kent::Lexer::Keywords ();
use Kent::Lexer::Rules    ();
use Kent::Token           ();
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

    my $rule_table = Kent::Lexer::Rules::table;
    my $rule_list  = Kent::Lexer::Rules::list;

    my $matchfound;

    while ( $self->{sourcecode} !~ /^$/ ) {

        $matchfound = 0;

        foreach my $rule_name (@$rule_list) {
            my $rule = $rule_table->{$rule_name};

            if ( $self->{sourcecode} =~ s/$rule->{regex}// ) {
                my $newtoken = Kent::Token->new(
                    'name'   => $rule->{name},
                    'raw'    => $1,
                    'line'   => $self->{line},
                    'column' => $self->{column},
                );

                $matchfound++;

                if ( $newtoken->width == -1 ) {
                    $self->{line}++;
                    $self->{column} = 1;
                }
                else { $self->{column} += $newtoken->width; }

                push @{ $self->{tokens} }, $newtoken;

                last;
            }
        }

        # When the lexer can handle everything, this will go away.
        if ( !$matchfound ) { return 0; }
    }

    push @{ $self->{tokens} },
      Kent::Token->new(
        'name'   => 'EOF',
        'line'   => $self->{line},
        'column' => $self->{column},
      );

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

1;
