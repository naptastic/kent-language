package Kent::Parser;

use common::sense;
use Kent::Lexer::Rules;
use Kent::Parser::Rules;
use Data::Dumper;

my %pairs = %Kent::Lexer::Rules::pairs;

# tidyoff
sub new {
    # $tokens is an arrayref full of Kent::Token objects.
    my ( $class, $tokens ) = @_;

    return bless { 'stack'  => [],
                   'tokens' => $tokens, }, $class;

}
# tidyon

sub parse {
    my ( $self, $lexer ) = @_;

    my $matched = 0;

    while ( 1 ) {
        $self->push( $lexer->next ) unless $matched;
        $matched = 0;

        my $phrase = $self->join();    # don't wanna do this a hundred times
        say $self->join( q{ } );       # Debugging info

        foreach my $rule ( @Kent::Parser::Rules::rules ) {
            if ( $phrase =~ $rule->[0] ) { 
                $self->apply_rule($rule);
                $matched = 1;
                last;
            }
        }
    }
}

sub apply_rule {
    my ($self, $rule) = @_;

    if ( defined $rule->[1] ) {
        # Reduce.
        my $method = $rule->[1];
        $self->push( $method->($self) );
    }
    elsif ( defined $rule->[2] ) {
        # Change out the rules we're using.
        # Needs so much work...
    }
    else { die "This code should never be reached." }

    return 1;    
}

sub push {
    my ( $self, $thingy ) = @_;
    push @{ $self->{stack} }, $thingy;

    #    print Data::Dumper::Dumper($thingy);
    return 1;
}

sub pop {
    my ( $self ) = @_;
    return pop @{ $self->{stack} };
}

sub join {
    my ( $self, $string ) = @_;
    $string // q{};
    return join( $string, map { $_->name } @{ $self->{stack} } );
}

1;
