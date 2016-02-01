package Kent::Lexer;

use Kent::Lexer::Keywords ();
use Kent::Lexer::Rules    ();
use Kent::Token           ();
use common::sense;

# sourcecode:   a string to tokenize. You should probably load the whole file.
# context:      the name of the set of rules for the lexer to use.
# ending_token: When this token is found, ... aw, shit.
sub new {
    my ( $class ) = @_;

    return  bless { line       => 1,
                    column     => 1, }, $class;
}

# Don't use this anymore.
sub lex {
    my ( $self ) = @_;
    my $rule_table = $self->{rule_table};
    my $matchfound;

    while ( $self->{sourcecode} !~ /^$/ ) {
        $matchfound = 0;

        foreach my $rule ( @$rule_table ) {

            if ( ref $rule->{regex} eq 'Regexp'
                 && $self->{sourcecode} =~ s/$rule->{regex}// )
            {
                $self->store( $rule, $1 );
                $matchfound++;
                last;
            }

            if ( $self->{sourcecode} =~ s/^\Q$rule->{regex}\E// ) {
                $self->store( $rule, $rule->{regex} );
                $matchfound++;
                last;
            }
        }

        # When the lexer can handle everything, this will go away.
        if ( !$matchfound ) { return 0; }
    }

    push @{ $self->{tokens} },
        Kent::Token->new( name   => 'EOF',
                          line   => $self->{line},
                          column => $self->{column}, );

    return $self->{tokens};
}

sub next {
    my ( $self, $rules, $source_ref ) = @_;
#    my $rule_table = Kent::Lexer::Rules::table($context);

    foreach my $rule ( @{ $rules } ) {

        if ( ref $rule->{regex}     eq 'Regexp'
            && ${ $source_ref } =~ s/$rule->{regex}// )
        { return $self->_make_token( $rule, $1 ) }

        if ( ${ $source_ref } =~ s/^\Q$rule->{regex}\E// )
        { return $self->_make_token( $rule, $1 ) }
    }

}

sub store {
    my ( $self, $rule, $raw ) = @_;

    push @{ $self->{tokens} }, $self->_make_token( $rule, $raw );

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

sub _make_token {
    my ( $self, $rule, $raw ) = @_;

    my $newtoken = Kent::Token->new( name         => $rule->{name},
                                     raw          => $raw,
                                     line         => $self->{line},
                                     column       => $self->{column},
                                     next_context => $rule->{next_context}, );

    if ( $newtoken->name eq 's_NEWLINE' ) {
        $self->{line}++;
        $self->{column} = 1;
    } else {
        $self->{column} += $newtoken->width;
    }

    return $newtoken;
}

1;
