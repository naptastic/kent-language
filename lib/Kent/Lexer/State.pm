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
    my ($class) = @_;
}

# takes a character, returns either a complete token, or the index of the next state.
# If no next state is defined, raise an exception.
sub do {
    # if self yoinks... shit, how do I advance the position from here?

    foreach ( @{ $self->{rules} } ) {
        # if the rule matches
        #    maybe we go to another state
        #    maybe we return a fully-formed token
        #    except how do we get the information from the lexer to make the token? Does the lexer
        #    pass itself in here? That seems gross...
    }

    if ( defined $self->{default_next_state} ) { return $self->{default_next_state} }
    else { die "bug or incompletion in the lexer"; }
}

1;
