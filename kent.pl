#!/usr/bin/perl
package Kent;
use common::sense;

use Kent::Lexer  ();
use Data::Dumper ();

script(@ARGV) unless caller;

sub new {
    return 1;
}

sub script {
    my (@args) = @_;

    my $sourcecode;
    my $filename = shift @args;
    {
        open( my $fh, '<', $filename ) or die "Couldn't open $filename for reading: $!";
        local $/;
        $sourcecode = (<$fh>);
        close $fh;
    }

    say "loaded source code from $filename";

    my $stack = Kent::Lexer->new($sourcecode);
    $stack->lex;
    $stack->barf;

    return 1;
}

