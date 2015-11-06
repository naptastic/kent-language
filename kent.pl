#!/usr/bin/perl
package Kent;
use common::sense;

use Kent::Lexer  ();
use Kent::Parser ();
use Data::Dumper ();

script(@ARGV) unless caller;

sub new {
    my ($class) = @_;
    return bless {}, $class;
}

sub script {
    my (@args) = @_;

    my $sourcecode;
    my $filename = shift @args;

    {
        open( my $fh, '<', $filename )
          or die "Couldn't open $filename for reading: $!";
        local $/;
        $sourcecode = (<$fh>);
        close $fh;
    }

    say "loaded source code from $filename";

    my $tokens = Kent::Lexer->new($sourcecode)->lex;
    my $ast    = Kent::Parser->new($tokens)->parse;

    return 1;
}

1;
