#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;

my $grammar_filename = 'grammar.csv';

my @lines;
my $choices = {};

open( my $fh, '<', $grammar_filename ) or die "Couldn't open $grammar_filename for reading: $!";
@lines = <$fh>;
close $fh;

# first row is comments; chunk it
shift @lines;

foreach my $line ( @lines ) {
    my @elements = split( /,/, $line );

    my $token_name        = shift @elements;
    my $forbid_whitespace = pop @elements;

    @elements = grep { $_ ne '' } @elements;
    next if scalar @elements == 0;

    my $ref = $choices;

    while (1)  {

        my $element = shift @elements;

        if ( scalar @elements == 0 ) {
            $ref->{$element} = $token_name;
            last;
        }
        else {
            $ref->{$element} //= {};
            if (ref $ref->{$element} eq 'HASH') { $ref = $ref->{$element}; }
            else {
                my $holder = $ref->{$element};
                $ref->{$element} = { 's_SPACE' => $holder, $element => {} };
                $ref = $ref->{$element};
            }
        }
    }
}

print Dumper( $choices );
