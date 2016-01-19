#!/usr/bin/perl
package Kent;
use common::sense;

use Kent::Lexer  ();
use Kent::Parser ();
use Kent::Util   ();

script(@ARGV) unless caller;

sub new {
    my ($class) = @_;
    return bless {}, $class;
}

sub script {
    my (@args) = @_;
    my $sourcecode = Kent::Util::slurp(shift @args);

    my $tokens = Kent::Lexer->new($sourcecode)->lex;
    my $ast    = Kent::Parser->new($tokens)->parse;
    return 1;
}

1;
