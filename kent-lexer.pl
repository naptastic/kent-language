#!/usr/bin/perl

use strict;
use warnings;

# this will matter later.
my $objreg = qr/[a-zA-Z][a-zA-Z0-9_]*/;

my @tokens;
my $sourcecode;

{
    my $filename = shift @ARGV;
    open( my $fh, '<', $filename ) or die "Couldn't open $filename for reading: $!";
    local $/;
    $sourcecode = (<$fh>);
    close $fh;
}

# This is only good for "normal mode." We will need subroutines for other modes, like "inside a function prototype",
# or "inside an interpolating string" or "inside a non-interpolating string" or or or or or.
while ( $sourcecode !~ /^$/ ) {
    if ( $sourcecode =~ s{^(\s+)}{} ) {
        push @tokens,
          {
            'token' => 'non-significant whitespace',
            'raw'   => $1,
          };
    }
    elsif ( $sourcecode =~ s/^($objreg)// ) {
        push @tokens,
          {
            'token' => 'possible object',
            'raw'   => $1,
          };
    }
    elsif ( $sourcecode =~ s{^==}{} ) {
        push @tokens,
          {
            'token' => 'comparison operator',
            'raw'   => '=',
          };
    }
    elsif ( $sourcecode =~ s{^=}{} ) {
        push @tokens,
          {
            'token' => 'assignment operator',
            'raw'   => '=',
          };
    }
    elsif ( $sourcecode =~ s{^;}{} ) {
        push @tokens,
          {
            'token' => 'statement separator',
            'raw'   => ';',
          };
    }
    elsif ( $sourcecode =~ s[^{][] ) {
        push @tokens,
          {
            'token' => 'begin scope operator',
            'raw'   => '{',
          };
    }
    elsif ( $sourcecode =~ s[^}][] ) {
        push @tokens,
          {
            'token' => 'end scope operator',
            'raw'   => '}',
          };
    }
    elsif ( $sourcecode =~ s[^[+]][] ) {
        push @tokens,
          {
            'token' => 'addition operator',
            'raw'   => '+',
          };
    }
    elsif ( $sourcecode =~ s[^-(\s+)][] ) {
        push @tokens,
          (
            {
                'token' => 'subtraction operator',
                'raw'   => '-',
            },
            {
                'token' => 'insignificant whitespace',
                'raw'   => $1,
            }
          );
    }
    elsif ( $sourcecode =~ s[^[.]][] ) {
        push @tokens,
          {
            'token' => 'access operator',
            'raw'   => '.',
          };
    }
    else {
        print "found something I couldn't lex. Here's what I've got so far:\n";
        print Dumper(@tokens);
        die;
    }
}

# nothing smarter to do at the moment
use Data::Dumper;
print Dumper(@tokens);
