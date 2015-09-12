#!/usr/bin/perl

use strict;
use warnings;
my $objreg = qr/[A-Za-z][A-Za-z0-9_]*/;
my @tokens;
my $sourcecode;
{
    my $filename = shift @ARGV;
    open( my $fh, '<', $filename ) or die "Couldn't open $filename for reading: $!";
    local $/;
    $sourcecode = (<$fh>);
    close $fh;
}
while ( $sourcecode !~ /^$/ ) {

    # The Basics
    if    ( $sourcecode =~ s{^(\s+)}{} )    { push @tokens, { 'token' => 'whitespace',      'raw' => $1, }; }
    elsif ( $sourcecode =~ s/^($objreg)// ) { push @tokens, { 'token' => 'possible object', 'raw' => $1, }; }
    elsif ( $sourcecode =~ s[^[.]($objreg)][] ) {
        push @tokens,
          (
            { 'token' => 'access operator' },
            { 'token' => 'possible object', 'raw' => $1, },
          );
    }

    # Number Literals
    elsif ( $sourcecode =~ s[^([.]\d+)][] ) { push @tokens, { 'token' => 'number literal', 'raw' => $1 }; }
    elsif ( $sourcecode =~ s[^(\d+)][] )    { push @tokens, { 'token' => 'number literal', 'raw' => $1 }; }

    # Syntax
    elsif ( $sourcecode =~ s{^=}{} )  { push @tokens, { 'token' => 'assignment operator', }; }
    elsif ( $sourcecode =~ s{^;}{} )  { push @tokens, { 'token' => 'statement separator', }; }
    elsif ( $sourcecode =~ s[^\(][] ) { push @tokens, { 'token' => 'begin expression operator', } }
    elsif ( $sourcecode =~ s[^\)][] ) { push @tokens, { 'token' => 'end expression operator', } }
    elsif ( $sourcecode =~ s[^,][] )  { push @tokens, { 'token' => 'item separator', } }
    elsif ( $sourcecode =~ s[^{][] )  { push @tokens, { 'token' => 'begin scope operator', }; }
    elsif ( $sourcecode =~ s[^}][] )  { push @tokens, { 'token' => 'end scope operator', }; }

    # Comparison. ORDER MATTERS.
    elsif ( $sourcecode =~ s{^==}{} ) { push @tokens, { 'token' => 'comparison operator', }; }
    elsif ( $sourcecode =~ s{^=<}{} ) { push @tokens, { 'token' => 'less than or equal to', }; }
    elsif ( $sourcecode =~ s{^<}{} )  { push @tokens, { 'token' => 'less than', }; }
    elsif ( $sourcecode =~ s{^>=}{} ) { push @tokens, { 'token' => 'greater than or equal to', }; }
    elsif ( $sourcecode =~ s{^>}{} )  { push @tokens, { 'token' => 'greater than', }; }

    # Comments
    elsif ( $sourcecode =~ s[^(#.*?\n)][] ) { push @tokens, { 'token' => 'comment', 'raw' => $1 }; }

    # Maths. ORDER MATTERS.
    elsif ( $sourcecode =~ s[^[+]][] ) { push @tokens, { 'token' => 'addition operator', }; }
    elsif ( $sourcecode =~ s[^\^][] )  { push @tokens, { 'token' => 'exponentiation operator', } }
    elsif ( $sourcecode =~ s[^\*][] )  { push @tokens, { 'token' => 'multiplication operator', } }
    elsif ( $sourcecode =~ s[/][] )    { push @tokens, { 'token' => 'division operator', } }
    elsif ( $sourcecode =~ s[^-(\s+)][] ) {
        push @tokens,
          (
            { 'token' => 'subtraction operator', },
            { 'token' => 'whitespace', 'raw' => $1, }
          );
    }

    else { print "found something I couldn't lex. Here's what I've got so far:\n"; print Dumper(@tokens); die; }
}
use Data::Dumper;
print Dumper(@tokens);
