package Kent::Lexer::State;

use common::sense;

# think hashref of actions based on a single input
# most of which will probably be "add that character and go to this state
# other possible actions:
#   accept what we've gathered so far--time to return a finished token
#   raise an exception, because this can't possibly result in a valid token
#
# We need to accommodate different possible things to match, such as:
#   specific character
#   newline
#   number
#   letter
#   Any alphanumeric character
#   Any whitespace character
#   Any character at all
#
# oh god... I've just realized that, at some point, I'm going to be lexing
# and parsing regular expressions
#
# please, somebody make me stop

sub new {
    my ( $class ) = @_;

    # Every rule needs to be either a single-character string literal,
    # or a regex that's just a character class of some kind.

    my $self = { rules   => [],
                 default => undef, };

    return bless $self, $class;
}

# takes a character, returns either a complete token, or the index of the next state.
# If no next state is defined, raise an exception.
sub do {
    my ( $self, $char ) = @_;

    # TODO: needs validation

    foreach my $rule ( @{ $self->{rules} } ) {

        # no, wrong, needs conditionals but idk what they are
        if ( $rule->matches( $char ) ) { return $rule->{action}; }
    }

    if   ( defined $self->{default} ) { return $self->{default} }
    else                              { die "bug or incompletion in the lexer"; }
}

1;
