package Kent::Parser;

use common::sense;
use Kent::Lexer::Rules;
use Kent::Parser::Rules;
use Data::Dumper;

my %pairs = %Kent::Lexer::Rules::pairs;

# tidyoff
sub new {
    # $tokens is an arrayref full of Kent::Token objects.
    my ( $class, %args ) = @_;

    $args{context} //= 'code';

    return bless { 'stack'      => [],
                   '_contexts'  => [],
                   'lexer'      => Kent::Lexer::new();
                   'tokens'     => $args{tokens},
                   'end_with'   => $args{end_with},
                   'sourcecode' => $args{sourcecode},
                 }, $class;
}
# tidyon

sub parse {
    my ( $self, $lexer ) = @_;
    my $contexts   = $self->{_contexts};
    my $sourcecode = $self->{sourcecode};

    my $matched = 0;

    while ( 1 ) {
        unless ($matched) {
          $self->push(
            $lexer->next( $contexts->[0], \$sourcecode )
          ); }

        $matched = 0;

        my $phrase = $self->join();    # don't wanna do this a hundred times
        say $self->join( q{ } );       # Debugging info

    }
}

sub apply_rule {
    my ($self, $rule) = @_;

    return 1;    
}

sub deepen {
    my ($self, $context, $end_with) = @_;
    unshift @{ $self->{_contexts} }, $context;
}

sub undeepen {
    my ($self) = @_;
    shift @{ $self->{_contexts} };
}

sub push {
    my ( $self, $thingy ) = @_;
    unshift @{ $self->{stack} }, $thingy;

    if (defined $thingy->{next_context}) {
        if ($thingy->{next_context} eq 'quote' {
            # TODO idk what to do here.   
        }
        elsif ($thingy->{next_context} eq '_pop') { $self->undeepen;                       }
        else                                      { $self->deepen($thingy->{next_context}) };
    }

    #    print Data::Dumper::Dumper($thingy);
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
