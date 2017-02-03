#!/usr/bin/perl

use common::sense;

use Data::Dumper;
$Data::Dumper::Sortkeys = 1;

use JSON;

my $grammar_filename = 'grammar.csv';
my $debug            = 0;

my $printer = JSON->new->canonical( 1 )->pretty( 1 );

my @lines;
my $choices = {};

open( my $fh, '<', $grammar_filename ) or die "Couldn't open $grammar_filename for reading: $!";
@lines = <$fh>;
close $fh;

# first row is comments; chunk it
shift @lines;

foreach my $line ( @lines ) {
    my @elements = split( /,/, $line );

    my $token_name = shift @elements;
    pop @elements;    # sort order
    my $forbid_whitespace = pop @elements;
    pop @elements;    # category

    @elements = grep { $_ ne '' } @elements;
    next if scalar @elements == 0;

    my $ref = $choices;

    if ( $debug ) {
        system( 'clear' );
        print "@elements -> $token_name\n";
        print $printer->encode( $choices );
        <>;
    }

    while ( 1 ) {

        my $element = shift @elements;

        if ( scalar @elements == 0 ) {
            if   ( ref $ref->{$element} eq 'HASH' ) { $ref->{$element}{'space'} = $token_name; }
            else                                    { $ref->{$element}          = $token_name; }
            last;
        }
        else {
            $ref->{$element} //= {};
            if ( ref $ref->{$element} eq 'HASH' ) {
                $ref = $ref->{$element};
            }
            else {
                my $holder = $ref->{$element};
                $ref->{$element} = { 'space' => $holder };
                $ref = $ref->{$element};
            }
        }
    }
}

print Dumper( $choices ) if $debug;

my @states = make_states( $choices, '', 1 );

foreach my $state ( @states ) {
        say "name: $state->{name}";
        if ( $state->{returns} ) { say "    returns: $state->{returns} with $state->{depth} elements"; }
}

sub make_states {
    my ( $choices, $name_so_far, $depth ) = @_;
    my @states;

    foreach my $key ( keys %$choices ) {
        if ( ref $choices->{$key} eq 'HASH' ) {
            push @states, { name => "$name_so_far$key" };
                           # valid_next => find_valid_nexts($choices->{$key}) };
            push @states, make_states( $choices->{$key}, "$name_so_far$key\_", $depth + 1 );
        }
        else {
            push @states,
                { name    => "$name_so_far$key",
                  returns => $choices->{$key},
                  depth   => $depth, };
        }
    }

    return @states;
}

sub find_valid_nexts {
    my ($state) = @_;
}
