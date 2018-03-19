#!/usr/bin/perl

use strict;
use warnings;

use Kent::Lexer;

use Test::More tests => 2;

subtest "Trivial comment" => sub {

    my $sourcecode = "/* try */";
    my @expected_tokens = ( '/* ', 't', 'r', 'y', ' */' );

    my $lexer   = Kent::Lexer->new( $sourcecode );
    my $context = 'code';

    foreach my $expected_token ( @expected_tokens ) {
        my $token = $lexer->next( $context );

        isa_ok( $token, 'Kent::Token', '$lexer->next returned a Kent::Token' );
        is( $token->raw(), $expected_token, "Got expected token '$expected_token'" );

        $context = $token->{next_context};
    }
};

subtest "Compose new object" => sub {

    my $sourcecode = "foo <- bar(),";
    my @expected_tokens = ('foo', ' ', '<-', ' ', 'bar', '(', ')', ',');

    my $lexer   = Kent::Lexer->new( $sourcecode );
    my $context = 'code';

    foreach my $expected_token ( @expected_tokens ) {
        my $token = $lexer->next( $context );

        isa_ok( $token, 'Kent::Token', '$lexer->next returned a Kent::Token' );
        is( $token->raw(), $expected_token, "Got expected token '$expected_token'" );

        $context = $token->{next_context};
    }
};
