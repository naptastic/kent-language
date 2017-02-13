#!/usr/bin/perl

use strict;
use warnings;
use v5.14;

use Data::Dumper;
use Kent::Grammar;
use Kent::Util;
$Data::Dumper::Sortkeys = 1;

use JSON;

my $grammar_filename = 'grammar.csv';
my $debug            = 0;

my $printer = JSON->new->canonical( 1 )->pretty( 1 );

my $header = <<EOM;
package Kent::Parser::States;

use strict;
use warnings;
use v5.14;

EOM

my $footer = "1;\n";

my $grammar = Kent::Grammar->new;

# say Dumper($grammar);

#say Kent::Util::dump( $grammar );

#summarize_rules( $grammar );
# summarize_choices( $grammar );
summarize_states( $grammar );

# print_state_table_module( $states );

exit 0;

sub summarize_rules {
    my ( $grammar ) = @_;
    my $rules = $grammar->{rules};

    my $last_token_name //= '';

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

1;
