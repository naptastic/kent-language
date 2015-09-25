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
    if    ( $sourcecode =~ s{^(\s+)}{} )    { push @tokens, { token => 'SPACE',      raw => $1, }; }
    elsif ( $sourcecode =~ s/^($objreg)// ) { push @tokens, { token => 'ID', raw => $1, }; }
    elsif ( $sourcecode =~ s[^[.]($objreg)][] ) {
        push @tokens,
          (
            { token => 'OP_ACCESS' },
            { token => 'ID', raw => $1, },
          );
    }

    # Number Literals
    # TODO: Make it actually a number.
    elsif ( $sourcecode =~ s[^(\d*[.]?\d+)][] ) { push @tokens, { token => 'LIT_NUM', raw => $1 }; }

    # Comparison. ORDER MATTERS.
    elsif ( $sourcecode =~ s{^==}{} ) { push @tokens, { token => 'OP_EQ', }; }
    elsif ( $sourcecode =~ s{^=<}{} ) { push @tokens, { token => 'OP_LE', }; }
    elsif ( $sourcecode =~ s{^<}{} )  { push @tokens, { token => 'OP_LT', }; }
    elsif ( $sourcecode =~ s{^>=}{} ) { push @tokens, { token => 'OP_GE', }; }
    elsif ( $sourcecode =~ s{^>}{} )  { push @tokens, { token => 'OP_GT', }; }

    # Syntax
    elsif ( $sourcecode =~ s{^=}{} )  { push @tokens, { token => 'OP_SET', }; }
    elsif ( $sourcecode =~ s{^;}{} )  { push @tokens, { token => 'OP_SEMI', }; }
    elsif ( $sourcecode =~ s[^\(][] ) { push @tokens, { token => 'OP_EXPR_START', } }
    elsif ( $sourcecode =~ s[^\)][] ) { push @tokens, { token => 'OP_EXPR_END', } }
    elsif ( $sourcecode =~ s[^,][] )  { push @tokens, { token => 'OP_LIST_NEXT', } }
    elsif ( $sourcecode =~ s[^{][] )  { push @tokens, { token => 'OP_SCOPE_START', }; }
    elsif ( $sourcecode =~ s[^}][] )  { push @tokens, { token => 'OP_SCOPE_END', }; }

    # Comments
    elsif ( $sourcecode =~ s[^(#.*?\n)][] ) { push @tokens, { token => 'COMMENT', raw => $1 }; }

    # Maths. ORDER MATTERS.
    elsif ( $sourcecode =~ s[^[+]][] ) { push @tokens, { token => 'OP_ADD', }; }
    elsif ( $sourcecode =~ s[^\^][] )  { push @tokens, { token => 'OP_POW', } }
    elsif ( $sourcecode =~ s[^\*][] )  { push @tokens, { token => 'OP_MUL', } }
    elsif ( $sourcecode =~ s[/][] )    { push @tokens, { token => 'OP_DIV', } }
    elsif ( $sourcecode =~ s[^-(\s+)][] ) {
        push @tokens,
          (
            { token => 'OP_SUB', },
            { token => 'SPACE', raw => $1, }
          );
    }

    # Non-interpolating strings. I'm sorry.
    elsif ( $sourcecode =~ s[^'][] ) {
        push @tokens, { token => 'begin non-interpolating string' };
        my $quote_insides = q{};

        while (1) {
            if ( $sourcecode =~ s[^(.*?)'][] ) {
                $quote_insides .= $1;
                if ( $quote_insides =~ s/\\$// ) {

                    # This single quote was escaped. Move the single quote from $source_code to $quoted_insides.
                    # NOTE: The escape character does not get included in the string's actual contents.
                    # That would be silly.
                    $quote_insides .= q{'};
                    $sourcecode =~ s/^'//;
                }
                else {
                    # This single quote was not escaped.
                    last;
                }
            }
            else {
                # The string never terminated. Specifically, $sourcecode has zero single-quotes before it ends.
                die 'unterminated string (don\'t ask me where, sorry)';
            }
        }
        push @tokens, { token => 'literal string contents', raw => $quote_insides };
        push @tokens, { token => 'end non-interpolating string' };
    }

    else { print "found something I couldn't lex. Here's what I've got so far:\n"; print Dumper(@tokens); die; }
}
# use Data::Dumper;
# print Dumper(@tokens);

print "I found these identifiers:\n";
# We've got two-thirds of a Schwartzian transform here
print join(q{ }, map { $_->{'raw'} } grep { $_->{'token'} eq 'ID' } @tokens);
print "\n";
