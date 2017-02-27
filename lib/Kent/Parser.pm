package Kent::Parser;

use strict;
use warnings;
use v5.14;
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
    my $token           = $self->_skip_whitespace( { 'name' => 'space' } );

    #    say Kent::Util::dump($token);
    my $states = $self->{grammar}{states_hr};

    #    say Kent::Util::dump($states);

    #    say "first non-whitespace token:";
    my $next_state = $token->{name};

    #    say "next state: $next_state";

DO_STATE:
    while ( $token->name ne 'eof' ) {

        $state = $states->{$next_state};
        say '';
        say "reached DO_STATE: $state->{name} and it looks like this:";
        die 'oh no, a statement' if $next_state eq 'statement';

        say Kent::Util::dump( $state ) if $state->{name} eq 'int';

        if ( $state->{returns} ) {
#            say "this state returns a $state->{returns}";
            unshift @has, $self->pop foreach ( 1 .. $state->{depth} );
            $self->push(
                         Kent::Token->new( 'name' => $state->{returns},
                                           'has'  => \@has,
                         ) );
            $next_state = pop @previous_states;
            if ( defined $next_state ) {
                $next_state .= "_$state->{returns}";
            }
            else {
                if ($state->{default}) {
                    say "line 67 (default return)";
                    $next_state = "$state->{returns}_$token->{name}";
                    $token      = $lexer->next;
                } else {
                    $next_state = $state->{returns};
                    #$token = $lexer->next;
                }
            }

            say "after returning a $state->{returns}, I think my next state should be $next_state";

            # $next_state = "$next_state\_$state->{returns}";
            @has = ();
            next DO_STATE;
        }

        # nows goes here

        $token = $self->_skip_whitespace( $token );

        # XXX The foreach is unnecessary; just look up the next directly. O(1) rather than O(N).
        foreach my $next ( @{ $state->{nexts} } ) {
#           say "checking NEXT '$next' against $token->{name}";
            if ( $token->{name} eq $next ) {
                say "going with NEXT $next";
                $self->push( $token );
                $next_state = "$state->{name}_$token->{name}";
#                $token      = $lexer->next;
                next DO_STATE;
            }
        }

        # others go here
        foreach my $other ( @{ $state->{others} } ) {
#            say "checking OTHER '$other' against $token->{name}";
            if ( $token->{name} eq $other ) {
                say "Going with OTHER $other";
                $self->push( $token );
                push @previous_states, "$state->{name}";
                $next_state = $token->{name};
#                $token      = $lexer->next;
                next DO_STATE;
            }
        }

        if ( $state->{default} ) {
            $self->push( $token );
            $token = $self->_skip_whitespace( $lexer->next );
            $next_state = $state->{default};
            next DO_STATE;
        }
    }

    return $self->{stack};
}

sub lexer { $_[0]->{lexer} }

sub push {
    my ( $self, $token ) = @_;
    push @{ $self->{stack} }, $token;

#    say "pushing a new token onto the stack. Here's what it looks like:";
#    say Kent::Util::dump($token);

    if ( $debug ) {
        say "push called from " . [ caller( 1 ) ]->[3];
        say $self->join( '_' );
    }

    return 1;
}

sub pop {
    my ( $self ) = @_;
    my $thingy = pop @{ $self->{stack} };

    if ( $debug ) {
        say "pop called from " . [ caller( 1 ) ]->[3];
        say $self->join( '_' );
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
    my ( $self, $token ) = @_;
    my $lexer = $self->lexer;

    while ( $token->{name} eq 'space' ) {
        $token = $lexer->next;
    }

    return $token;
}

1;
