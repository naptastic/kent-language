package Kent::Parser;

use common::sense;
use Kent::Lexer;
use Kent::Lexer::Rules;
use Data::Dumper;

use base 'Kent::Parser::States';

# tidyoff
sub new {
    my ( $class, %args ) = @_;

    return bless { 'stack'      => [],
                   'lexer'      => Kent::Lexer->new( $args{sourcecode} ),
                   'tokens'     => $args{tokens},
                   'end_with'   => $args{end_with},
                   }, $class;
}
# tidyon

sub parse {
    my ($self) = @_;
    $self->Kent::Parser::States::bof;
    return $self->{stack};
}

sub lexer { $_[0]->{lexer} }

sub push {
    my ( $self, $thingy ) = @_;
    push @{ $self->{stack} }, $thingy;

    return 1;
}

sub pop {
    my ( $self ) = @_;
    my $thingy = pop @{ $self->{stack} };
    return $thingy;
}

sub top {
    my ( $self ) = @_;
    return $self->{stack}[-1];
}

sub join {
    my ( $self, $string ) = @_;
    $string // q{};
    return join( $string, map { $_->name } @{ $self->{stack} } );
}

1;
