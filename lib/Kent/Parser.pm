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
                   'lexer'      => Kent::Lexer->new( \$args{sourcecode} ),
                   'tokens'     => $args{tokens},
                   'end_with'   => $args{end_with},
                   }, $class;
}
# tidyon

sub parse {
    my ($self) = @_;
    my $lexer  = $self->lexer;

    my $start = $self->lexer->next;
    return $self->{$start->{name}};
}

sub lexer { $_[0]->{lexer} }

sub push {
    my ( $self, $thingy ) = @_;
    unshift @{ $self->{stack} }, $thingy;

    return 1;
}

sub pop {
    my ( $self ) = @_;
    return shift @{ $self->{stack} };
}

sub join {
    my ( $self, $string ) = @_;
    $string // q{};
    return join( $string, reverse map { $_->name } @{ $self->{stack} } );
}

1;
