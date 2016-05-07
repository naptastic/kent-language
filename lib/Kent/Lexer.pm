package Kent::Lexer;

use Kent::Lexer::Keywords ();
use Kent::Lexer::Rules    ();
use Kent::Token           ();
use Kent::Util            ();
use common::sense;

sub new {
    my ( $class, $sourcecode ) = @_;

    my $self = { sourcecode => $sourcecode,
                 tokens     => [],
                 line       => 1,
                 column     => 1,
                 position   => 0 };

    return bless $self, $class;
}

# $rules is a Kent::Lexer::State::Table object.
sub get_next_token {
    my (@self, $rules) = @_;

    while (1) {
        my $next_char = substr( ${$self->{sourcecode}}, $self->{position}, 1 );

        my $next_state = $rules

        $self->{position}++;
    }
}

sub lex {
    my ( $self ) = @_;
    my $rule_table = Kent::Lexer::Rules::table;
    my $matchfound;

    while ( length $self->{sourcecode} ) {
        $matchfound = 0;

        foreach my $rule ( @$rule_table ) {

            if ( ref $rule->{regex} eq 'Regexp'
                 && $self->{sourcecode} =~ s/$rule->{regex}// )
            {
                $self->store( $rule, $1 );
                $matchfound++;
                last;
            }

            if ( $self->{sourcecode} =~ s/^(\Q$rule->{regex}\E)// ) {
                $self->store( $rule, $rule->{regex} );
                $matchfound++;
                last;
            }
        }

        # When the lexer can handle everything, this will go away.
        if ( !$matchfound ) {
            say Kent::Util::dump( $self->{tokens} );
            die "Source code contained something I couldn't understand.";
        }
    }

    push @{ $self->{tokens} },
        Kent::Token->new( 'name'   => 'EOF',
                          'line'   => $self->{line},
                          'column' => $self->{column}, );

    return $self->{tokens};
}

sub store {
    my ( $self, $rule, $raw ) = @_;

    my $newtoken = Kent::Token->new( 'name'   => $rule->{name},
                                     'raw'    => $1,
                                     'line'   => $self->{line},
                                     'column' => $self->{column}, );

    if ( $newtoken->width == -1 ) {
        $self->{line}++;
        $self->{column} = 1;
    }
    else { $self->{column} += $newtoken->width; }

    say Kent::Util::dump( $newtoken );
    push @{ $self->{tokens} }, $newtoken;

    return 1;
}

sub barf {
    my ( $self ) = @_;

    foreach my $token ( @{ $self->{tokens} } ) {
        print "[$token->{line}, $token->{column}] $token->{name} ";
        if ( exists $token->{raw} ) { print "($token->{raw})"; }
        print "\n";
    }
    return 1;
}

1;
