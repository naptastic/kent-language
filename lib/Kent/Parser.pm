package Kent::Parser;

use common::sense;
use Kent::Grammar;
use Kent::Lexer;
use Kent::Token;
use Kent::Util;
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
    my ( $self ) = @_;

    my $state;
    my @previous_states = ();
    my @has             = ();
    my $lexer           = $self->lexer;
    my $token           = $lexer->next;
    say Kent::Util::dump($self->{grammar});
    
    my $states          = $self->{grammar}{states};
    my $next_state      = $states->{$token->name};

    $self->_skip_whitespace( $token );

DO_STATE:

    die "'$next_state' is not a valid state in the parser's state table!" unless defined $next_state;
    $state = $self->{states}{$next_state};
    say $state->{name};

    if ( $state->{returns} ) {
        shift @has, $self->pop foreach ( 1 .. $state->{depth} );
        $self->push(
                     Kent::Token->new( 'name' => $state->{returns},
                                       'has'  => \@has,
                     ) );
        $next_state = pop @previous_states;
        @has = ();
        next DO_STATE;
    }

    # nows goes here

    $token = $self->_skip_whitespace( $token );

    # nexts go here
    foreach my $next ( @{ $state->{nexts} } ) {
        if ( $token->{name} eq $next ) {
            $self->push( $token );
            $next_state = "$state->{name}_$token->{name}";
            $token      = $lexer->next;
            next DO_STATE;
        }
    }

    # others go here
    foreach my $other ( @{$state->{others}} ) {
        if ( $token->{name} = $other ) {
            $self->push( $token );
            push @previous_states, $state->{name};
            $next_state = $token->{name};
            $token      = $lexer->next;
            next DO_STATE;
        }
    }

    if ( $state->{default} ) {

        # token remains unchanged
        $self->top->{name} = $state->{default};
        $self->push( $token );

        $self->_skip_whitespace;

        $next_state = "$state->{default}_$token->{name}";
    }

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
    $string //= q{_};
    return join( $string, map { $_->name } @{ $self->{stack} } );
}

sub _skip_whitespace {
    my ($self, $token) = @_;
    my $lexer = $self->lexer;

    while ( $token->{name} eq 'space' ) {
        $token = $lexer->next;
    }

    return $token;
}

1;
