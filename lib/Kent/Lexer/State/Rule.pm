package Kent::Lexer::State::Rule;

use common::sense;

sub new {
    my ( $class, $condition, $action ) = @_;

    # Every rule needs to be either a single-character string literal,
    # or a regex that's just a character class of some kind.

    my $self = { condition => $condition,
                 action    => $action, };

    return bless $self, $class;
}

sub matches {
    my ( $self, $char ) = @_;

    # TODO: needs validation

    if ( ref $self->{condition} eq 'Regexp' && $char =~ $self->{condition} ) { return 1; }
    elsif ( $char eq $self->{condition} ) { return 1; }
    else                                  { return 0; }
}

1;
