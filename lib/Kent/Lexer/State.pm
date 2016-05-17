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

    # Every rule needs to be either a single-character string literal,
    # or a regex that's just a character class of some kind.

    my $self = {
        rules   => [],
        default => undef,
    };

    return bless $self, $class;
}

# takes a character, returns either a complete token, or the index of the next state.
# If no next state is defined, raise an exception.
sub do {
    my ( $self, $char ) = @_;

    length($char) == 1 || die "Got a character more than one character long.";

    foreach my $rule ( @{ $self->{rules} } ) {

        if ( ref $rule->{condition} eq 'Regexp' && $char =~ $self->{condition} )
        {

            # Match
        }
        elsif ( $char eq $rule->{condition} ) {

            # Match
        }
        else {
            # No match
        }
    }

    if ( defined $self->{default} ) { return $self->{default} }
    else                            { die "bug or incompletion in the lexer"; }
}

# Eventually this needs to get smart enough to split a condition, like, if the
# caller adds a rule that overlaps an already-existing rule, that needs to get
# handled. TODO
sub add_rule {

   # XXX: Probably would be better as named rather than positional parameters...
    my ( $self, $condition, $action ) = @_;
    push @{ $self->{rules} },
      {
        condition => $condition,
        action    => $action,
      };
    return 1;
}

sub set_default_action {
    my ($self) = @_;

    # idk if this is the right thing to do
    die "default action for this state is already defined"
      if defined $self->{default};

    $self->{default} = shift;
    return 1;
}

1;
