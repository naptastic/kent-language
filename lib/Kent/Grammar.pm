package Kent::Grammar;

use strict;
use warnings;
use v5.14;

use Kent::Util;

our $grammar_filename = 'grammar.csv';

sub new {
    my ( $class ) = @_;

    my $self = bless {}, $class;

    $self->{lines}     = [ Kent::Util::slurp( $grammar_filename ) ];
    $self->{rules}     = $self->rules_from_lines;
    $self->{choices}   = $self->choices_from_rules;
    $self->{states_ar} = $self->states_from_choices;
    $self->{states_hr} = $self->states_hr_from_states_ar;

    foreach my $state ( @{ $self->{states_ar} } ) {
        $self->{states}{ $state->{name} } = $state;
    }

    print Kent::Util::dump( $self );

    return $self;
}

sub rules_from_lines {
    my ( $self ) = @_;
    my $lines = $self->{lines};

    # First line is comments.
    shift @{ $self->{lines} };

    my $rules = [];

    foreach my $line ( @{$lines} ) {
        my $rule = {};
        my @parts = split( /,/, $line );
        $rule->{token_name} = $parts[0];
        $rule->{parts}      = [ grep { $_ ne '' } @parts[ 1 .. 6 ] ];
        $rule->{category}   = $parts[7];
        $rule->{sort_order} = $parts[8] + 0;                            # Remove newline and cast to IV
        push @{$rules}, $rule;
    }
    return $rules;
}

sub choices_from_rules {
    my ( $self ) = @_;
    my $rules    = $self->{rules};
    my $choices  = {};

    foreach my $rule ( @{$rules} ) {
        my @parts             = @{ $rule->{parts} };
        my $token_name        = $rule->{token_name};
        my $forbid_whitespace = $rule->{forbid_whitespace};

        @parts = grep { $_ ne '' } @parts;
        next if scalar @parts == 0;

        my $ref = $choices;

        while ( 1 ) {

            my $part = shift @parts;

            if ( scalar @parts == 0 ) {
                if   ( ref $ref->{$part} eq 'HASH' ) { $ref->{$part}{'default'} = $token_name; }
                else                                 { $ref->{$part}            = $token_name; }
                last;
            }
            else {
                $ref->{$part} //= {};
                if ( ref $ref->{$part} eq 'HASH' ) {
                    $ref = $ref->{$part};
                }
                else {
                    my $holder = $ref->{$part};
                    $ref->{$part} = { 'default' => $holder };
                    $ref = $ref->{$part};
                }
            }
        }
    }
    return $choices;
}

sub states_from_choices {
    my ( $self, $choices, $name, $depth ) = @_;
    my $rules = $self->{rules};
    my @states;

    $choices //= $self->{choices};
    $name    //= [];
    $depth   //= 0;

    my $new_state;

    foreach my $key ( sort keys %$choices ) {
        if ( ref $choices->{$key} eq 'HASH' ) {

            # "nows" have to be checked before whitespace is discarded.
            #     ( "nows" is short for "no whitespace allowed" )
            # "nexts" are checked right after whitespace is discarded.
            #     They will call $name_so_far_$next.
            # "others" are checked last. Their return replaces the token being
            #     evaluated, and we go back to checking "nexts". They
            #     will call their own name, as if starting from scratch.
            my ( @nows, @nexts, $default );
            foreach my $choice ( sort keys %{ $choices->{$key} } ) {
                next if ref $choice eq 'HASH';
                if ( $choice =~ m/[*]/ ) { push @nows, $choice; }
                elsif ( $choice eq 'default' ) { $default = 1; }
                else                           { push @nexts, $choice; }
            }

            foreach my $now ( @nows ) { $now =~ s/[*]//; }

            $new_state = { 'name'   => join( '_', @{$name}, $key ),
                           'depth'  => $depth,
                           'nows'   => \@nows,
                           'nexts'  => \@nexts,
                           'others' => $self->find_others( $choices->{$key} ), };
            if ( $default ) { $new_state->{default} = join( '_', @{$name}, $key, 'default' ) }

            push @states, $new_state;
            push @states, @{ $self->states_from_choices( $choices->{$key}, [ @{$name}, $key ], $depth + 1 ) };
        }
        else {
            if ( $key eq 'default' ) {
                push @states,
                    { 'name'    => join( '_', @{$name}, $key ),
                      'returns' => $choices->{$key},
                      'default' => 1,
                      'depth'   => $depth, };
            }
            else {
                push @states,
                    { 'name'    => join( '_', @{$name}, $key ),
                      'returns' => $choices->{$key},
                      'depth'   => $depth, };
            }
        }
    }
    foreach my $state ( @states ) { $state->{name} =~ s/[*]//; }
    return \@states;
}

sub states_hr_from_states_ar {
    my ( $self ) = @_;
    my $states_ar = $self->{states_ar};

    my $states_hr = {};

    foreach my $state ( @{$states_ar} ) {
        $states_hr->{ $state->{name} } = $state;
    }

    return $states_hr;
}

sub find_others {
    my ( $self, $choice ) = @_;
    my $rules = $self->{rules};
    my %others;
    my @to_check = keys %{$choice};

    while ( scalar @to_check ) {
        my $key = shift @to_check;

        foreach my $rule ( grep { $_->{token_name} eq $key } @{$rules} ) {
            my $other = $rule->{parts}[0];
            push @to_check, $other unless defined $others{$other};
            $others{$other} = 1;
        }
    }

    return [ sort keys %others ];
}

1;
