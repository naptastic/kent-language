#!/usr/bin/perl

use strict;
use warnings;
use v5.14;

use Data::Dumper;
use Kent::Grammar;
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

my $grammar = Kent::Grammar->new;

summarize_rules( $grammar );
summarize_choices( $grammar );
summarize_states( $grammar );

# print_state_table_module( $states );

exit 0;

sub summarize_rules {
    my ( $grammar ) = @_;
    my $rules = $grammar->{rules};

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
    my ( $grammar ) = @_;

    say $printer->encode( $grammar->{choices} );
}

sub summarize_states {
    my ( $grammar ) = @_;
    my $states = $grammar->{states};

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
    my ( $grammar ) = @_;
    my $states = $grammar->{states};

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
