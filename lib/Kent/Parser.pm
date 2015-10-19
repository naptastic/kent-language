package Kent::Parser;

use common::sense;
use Kent::Parser::Rules;
use Data::Dumper;

sub new {

    # $tokens should be a Lexer object
    my ( $class, $tokens ) = @_;

    return bless {
        'stack'  => [],
        'tokens' => $tokens,
    }, $class;
}

sub parse {
    my ( $self, $tokens ) = @_;

    #    while ( scalar @$tokens ) {
    for ( 1 .. 10 ) {

        $self->push( shift @{ $self->{tokens} } );
        my $phrase = $self->join();    # don't wanna do this a hundred times
        say $self->join(q{ });
        # say scalar @{ $self->{stack} };

      APPLYRULES:
        foreach my $rule (@Kent::Parser::Rules::rules) {

            if ( $phrase =~ $rule ) {

                #                $self->$rule->do->thingy->now->maximum->go;
                next APPLYRULES;
            }
        }
    }
}

sub push {
    my ( $self, $thingy ) = @_;
    push @{ $self->{stack} }, $thingy;

    #    print Data::Dumper::Dumper($thingy);
    return 1;
}

sub pop {
    my ($self) = @_;
    return pop @{ $self->{stack} };
}

sub join {
    my ( $self, $string ) = @_;
    $string // q{};
    return join( $string, map { $_->name } @{ $self->{stack} } );
}

1;
