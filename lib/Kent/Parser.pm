package Kent::Parser;

use common::sense;
use Kent::Lexer;
use Kent::Token;
use Data::Dumper;

our $debug = 0;

# tidyoff
sub new {
    my ( $class, %args ) = @_;

    return bless { 'stack'      => [],
                   'lexer'      => Kent::Lexer->new( $args{sourcecode} ),
                   'grammar'    => Kent::Grammar->new,
                   'tokens'     => $args{tokens},
                   'end_with'   => $args{end_with},
                   }, $class;
}
# tidyon

sub parse {
    my ($self) = @_;

    my $state;
    my $token      = $lexer->next;
    my $next_state = $token->name;

    DO_STATE:

    die "'$next_state' is not a valid state in the parser's state table!" unless defined $next_state;
    $state = $self->{states}{$next_state};

    if $state->{returns} {
        my @has = $self->pop foreach (1 .. $state->{depth} );
        $self->push( Kent::Token->new(
            'name' => $state->{returns},
            'has'  => \@has,
        ) );
        # XXX ???
    

    return $self->{stack};
}

sub lexer { $_[0]->{lexer} }

sub push {
    my ( $self, $thingy ) = @_;
    push @{ $self->{stack} }, $thingy;

    if ( $debug ) {
        say "push called from " . [ caller(1) ]->[3];
        say $self->join('_');
    }

    return 1;
}

sub pop {
    my ( $self ) = @_;
    my $thingy = pop @{ $self->{stack} };

    if ( $debug ) {
        say "pop called from " . [ caller(1) ]->[3];
        say $self->join('_');
    }

    return $thingy;
}

sub top {
    my ( $self ) = @_;
    return $self->{stack}[-1];
}

sub join {
    my ( $self, $string ) = @_;
    $string // q{_};
    return join( $string, map { $_->name } @{ $self->{stack} } );
}

1;
