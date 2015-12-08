#!/usr/bin/perl
package Kent;
use common::sense;

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

    my $parser = Kent::Parser->new( sourcecode => $sourcecode);
    my $ast    = $parser->parse();

    return 1;
}

1;
