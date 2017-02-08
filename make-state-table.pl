#!/usr/bin/perl

use strict;
use warnings;
use v5.14;

use Data::Dumper;
use Kent::Util;
$Data::Dumper::Sortkeys = 1;

use JSON;
use Template;

my $grammar_filename = 'grammar.csv';
my $debug            = 0;

my $printer = JSON->new->canonical( 1 )->pretty( 1 );
my $templater = Template->new( { 'INCLUDE_PATH' => 'share/', } );

my $header = <<EOM;
package Kent::Parser::States;

use strict;
use warnings;
use v5.14;

EOM

my $footer = "1;\n";

my $lines = [ Kent::Util::slurp($grammar_filename) ];
# first row is comments; chunk it
shift @{$lines};

my $rules   = rules_from_lines( $lines );
my $choices = choices_from_rules( $rules );
my $states  = states_from_choices( $choices );

# summarize_rules($rules);
print_state_table_module( $states );

# summarize_states($states);

exit 0;

sub rules_from_lines {
    my ( $lines ) = @_;
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
    my ( $rules ) = @_;
    my $choices = {};

    foreach my $rule ( @{$rules} ) {
        my @parts             = @{ $rule->{parts} };
        my $token_name        = $rule->{token_name};
        my $forbid_whitespace = $rule->{forbid_whitespace};

        @parts = grep { $_ ne '' } @parts;
        next if scalar @parts == 0;

        my $ref = $choices;

        if ( $debug ) {
            system( 'clear' );
            print "@parts -> $token_name\n";
            print $printer->encode( $choices );
            <>;
        }

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
    my ( $choices, $name, $depth ) = @_;
    my @states;

    $name //= [];
    $depth       //= 1;

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
                elsif ( $choice eq 'default' ) { $default = $choice; }
                else                           { push @nexts, $choice; }
            }

            foreach my $now ( @nows ) { $now =~ s/[*]//; }

            push @states,
                { 'name'    => join( '_', @{ $name }, $key),
                  'depth'   => $depth,
                  'nows'    => \@nows,
                  'nexts'   => \@nexts,
                  'others'  => find_others( $choices->{$key} ),
                  'default' => $default, };
            push @states, @{ states_from_choices( $choices->{$key}, [ @{ $name }, $key ], $depth + 1 ) };
        }
        else {
            if ( $key eq 'default' ) {
                push @states,
                    { 'name'    => join( '_', @{ $name }, $key),
                      'returns' => $choices->{$key},
                      'default' => 1,
                      'depth'   => $depth, };
            }
            else {
                push @states,
                    { 'name'    => join( '_', @{ $name }, $key),
                      'returns' => $choices->{$key},
                      'depth'   => $depth, };
            }
        }
    }
    foreach my $state ( @states ) { $state->{name} =~ s/[*]//; }
    return \@states;
}

sub find_others {
    my ( $choice ) = @_;
    my %others;
    my @to_check;

    push @to_check, keys %{$choice};

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

sub summarize_rules {
    my ( $rules ) = @_;

    my $last_token_name;

    foreach my $rule ( sort { $a->{sort_order} <=> $b->{sort_order} } @{$rules} ) {
        next unless scalar @{ $rule->{parts} };
        if ( $rule->{token_name} ne $last_token_name ) {
            say "$rule->{token_name}";
            $last_token_name = $rule->{token_name};
        }
        say "      [ " . join( ' ', @{ $rule->{parts} } ) . " ]";
    }
}

sub summarize_choices {
    say $printer->encode( shift );
}

sub summarize_states {
    my ( $states ) = @_;
    foreach my $state ( @{$states} ) {
        say "$state->{name}";
        if ( $state->{returns} ) {
            say "    return:  $state->{returns} with $state->{depth} parts";
            say '';
        }
        else {
            say "    nows:    $_" foreach @{ $state->{nows} };
            say "    nexts:   $_" foreach @{ $state->{nexts} };
            say "    others:  $_" foreach @{ $state->{others} };
            say "    default: $state->{default}" if defined $state->{default};
            say '';
        }
    }
    return 1;
}

sub print_state_table_module {
    my ( $states ) = @_;

    print $header;

    foreach my $state ( @{$states} ) {
        if ( $state->{returns} ) {
            if    ( $state->{default} )   { $templater->process( 'terminal_default.tt', $state ); }
            elsif ( $state->{depth} > 1 ) { $templater->process( 'terminal_multi.tt',   $state ); }
            else                          { $templater->process( 'terminal_single.tt',  $state ); }
        }
        else {
            $templater->process( 'intermediate.tt', $state );
        }
    }

    print $footer;

    return 1;
}
