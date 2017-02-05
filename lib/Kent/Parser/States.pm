package Kent::Parser::States;

use strict;
use warnings;
use v5.14;

sub access {
    return Kent::Token->new( { 'name' => 'fqid' } );
}

sub annotated {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);
    if ($token->name eq 'space') { return Kent::Parser::States::annotated_space($self); }

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'comment') { return Kent::Parser::States::annotated_comment($self); }
    if ($token->name eq 'lcmt') { $token = Kent::Parser::States::lcmt($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub annotated_space {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'statement',
          'has'  => \@has, }
        );
}

sub annotated_comment {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'annotated',
          'has'  => \@has, }
        );
}

sub array {
    return Kent::Token->new( { 'name' => 'statement' } );
}

sub bang {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);
    if ($token->name eq 'fqid') { return Kent::Parser::States::bang_fqid($self); }

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub bang_fqid {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'expr',
          'has'  => \@has, }
        );
}

sub bof {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'code') { return Kent::Parser::States::bof_code($self); }
    if ($token->name eq 'statement') { return Kent::Parser::States::bof_statement($self); }
    if ($token->name eq 'annotated') { $token = Kent::Parser::States::annotated($self); goto AGAIN; }
    if ($token->name eq 'array') { $token = Kent::Parser::States::array($self); goto AGAIN; }
    if ($token->name eq 'branch') { $token = Kent::Parser::States::branch($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'loop') { $token = Kent::Parser::States::loop($self); goto AGAIN; }
    if ($token->name eq 'statement') { $token = Kent::Parser::States::statement($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub bof_code {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'eof') { return Kent::Parser::States::bof_code_eof($self); }
    if ($token->name eq 'statement') { return Kent::Parser::States::bof_code_statement($self); }
    if ($token->name eq 'annotated') { $token = Kent::Parser::States::annotated($self); goto AGAIN; }
    if ($token->name eq 'array') { $token = Kent::Parser::States::array($self); goto AGAIN; }
    if ($token->name eq 'branch') { $token = Kent::Parser::States::branch($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'loop') { $token = Kent::Parser::States::loop($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub bof_code_eof {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'file',
          'has'  => \@has, }
        );
}

sub bof_code_statement {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'eof') { return Kent::Parser::States::bof_code_statement_eof($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub bof_code_statement_eof {
    my ($self) = @_;

    my @has;
    foreach (1..4) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'file',
          'has'  => \@has, }
        );
}

sub bof_statement {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'eof') { return Kent::Parser::States::bof_statement_eof($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub bof_statement_eof {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'file',
          'has'  => \@has, }
        );
}

sub branch {
    return Kent::Token->new( { 'name' => 'statement' } );
}

sub char {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);
    if ($token->name eq 'char') { return Kent::Parser::States::char_char($self); }

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub char_char {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'char',
          'has'  => \@has, }
        );
}

sub comment {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'annotated') { return Kent::Parser::States::comment_annotated($self); }
    if ($token->name eq 'statement') { return Kent::Parser::States::comment_statement($self); }
    if ($token->name eq 'annotated') { $token = Kent::Parser::States::annotated($self); goto AGAIN; }
    if ($token->name eq 'array') { $token = Kent::Parser::States::array($self); goto AGAIN; }
    if ($token->name eq 'branch') { $token = Kent::Parser::States::branch($self); goto AGAIN; }
    if ($token->name eq 'comment') { $token = Kent::Parser::States::comment($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'loop') { $token = Kent::Parser::States::loop($self); goto AGAIN; }
    if ($token->name eq 'statement') { $token = Kent::Parser::States::statement($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub comment_annotated {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'annotated',
          'has'  => \@has, }
        );
}

sub comment_statement {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'annotated',
          'has'  => \@has, }
        );
}

sub dot {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);
    if ($token->name eq 'fqid') { return Kent::Parser::States::dot_fqid($self); }
    if ($token->name eq 'lbrace') { return Kent::Parser::States::dot_lbrace($self); }
    if ($token->name eq 'space') { return Kent::Parser::States::dot_space($self); }

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub dot_fqid {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'access',
          'has'  => \@has, }
        );
}

sub dot_lbrace {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'id') { return Kent::Parser::States::dot_lbrace_id($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub dot_lbrace_id {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'rbrace') { return Kent::Parser::States::dot_lbrace_id_rbrace($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub dot_lbrace_id_rbrace {
    my ($self) = @_;

    my @has;
    foreach (1..4) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'access',
          'has'  => \@has, }
        );
}

sub dot_space {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'fqid',
          'has'  => \@has, }
        );
}

sub element {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::element_expr($self); }
    if ($token->name eq 'statement') { return Kent::Parser::States::element_statement($self); }
    if ($token->name eq 'annotated') { $token = Kent::Parser::States::annotated($self); goto AGAIN; }
    if ($token->name eq 'array') { $token = Kent::Parser::States::array($self); goto AGAIN; }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'branch') { $token = Kent::Parser::States::branch($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'loop') { $token = Kent::Parser::States::loop($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub element_expr {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'comma') { return Kent::Parser::States::element_expr_comma($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub element_expr_comma {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'element',
          'has'  => \@has, }
        );
}

sub element_statement {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'comma') { return Kent::Parser::States::element_statement_comma($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub element_statement_comma {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'element',
          'has'  => \@has, }
        );
}

sub else {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'codeblock') { return Kent::Parser::States::else_codeblock($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub else_codeblock {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'elseblock',
          'has'  => \@has, }
        );
}

sub elseif {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'cond') { return Kent::Parser::States::elseif_cond($self); }
    if ($token->name eq 'fqid') { return Kent::Parser::States::elseif_fqid($self); }
    if ($token->name eq 'access') { $token = Kent::Parser::States::access($self); goto AGAIN; }
    if ($token->name eq 'dot') { $token = Kent::Parser::States::dot($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'id') { $token = Kent::Parser::States::id($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub elseif_cond {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'codeblock') { return Kent::Parser::States::elseif_cond_codeblock($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub elseif_cond_codeblock {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'elseifblock',
          'has'  => \@has, }
        );
}

sub elseif_fqid {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'codeblock') { return Kent::Parser::States::elseif_fqid_codeblock($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub elseif_fqid_codeblock {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'hashrocket') { return Kent::Parser::States::elseif_fqid_codeblock_hashrocket($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub elseif_fqid_codeblock_hashrocket {
    my ($self) = @_;

    my @has;
    foreach (1..4) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'elseifblock',
          'has'  => \@has, }
        );
}

sub elseifblock {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'elseif') { return Kent::Parser::States::elseifblock_elseif($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub elseifblock_elseif {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'cond') { return Kent::Parser::States::elseifblock_elseif_cond($self); }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub elseifblock_elseif_cond {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'codeblock') { return Kent::Parser::States::elseifblock_elseif_cond_codeblock($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub elseifblock_elseif_cond_codeblock {
    my ($self) = @_;

    my @has;
    foreach (1..4) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'elseifblock',
          'has'  => \@has, }
        );
}

sub embraces {
    return Kent::Token->new( { 'name' => 'array' } );
}

sub emcurlies {
    return Kent::Token->new( { 'name' => 'hash' } );
}

sub emparens {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'array') { return Kent::Parser::States::emparens_array($self); }
    if ($token->name eq 'embraces') { $token = Kent::Parser::States::embraces($self); goto AGAIN; }
    if ($token->name eq 'lbrace') { $token = Kent::Parser::States::lbrace($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub emparens_array {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'function',
          'has'  => \@has, }
        );
}

sub expr {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'binand') { return Kent::Parser::States::expr_binand($self); }
    if ($token->name eq 'binor') { return Kent::Parser::States::expr_binor($self); }
    if ($token->name eq 'binxor') { return Kent::Parser::States::expr_binxor($self); }
    if ($token->name eq 'comma') { return Kent::Parser::States::expr_comma($self); }
    if ($token->name eq 'eqeq') { return Kent::Parser::States::expr_eqeq($self); }
    if ($token->name eq 'fslash') { return Kent::Parser::States::expr_fslash($self); }
    if ($token->name eq 'gt') { return Kent::Parser::States::expr_gt($self); }
    if ($token->name eq 'logand') { return Kent::Parser::States::expr_logand($self); }
    if ($token->name eq 'logor') { return Kent::Parser::States::expr_logor($self); }
    if ($token->name eq 'logxor') { return Kent::Parser::States::expr_logxor($self); }
    if ($token->name eq 'lt') { return Kent::Parser::States::expr_lt($self); }
    if ($token->name eq 'match') { return Kent::Parser::States::expr_match($self); }
    if ($token->name eq 'minus') { return Kent::Parser::States::expr_minus($self); }
    if ($token->name eq 'ne') { return Kent::Parser::States::expr_ne($self); }
    if ($token->name eq 'ngt') { return Kent::Parser::States::expr_ngt($self); }
    if ($token->name eq 'nlt') { return Kent::Parser::States::expr_nlt($self); }
    if ($token->name eq 'nomatch') { return Kent::Parser::States::expr_nomatch($self); }
    if ($token->name eq 'percent') { return Kent::Parser::States::expr_percent($self); }
    if ($token->name eq 'plus') { return Kent::Parser::States::expr_plus($self); }
    if ($token->name eq 'shl') { return Kent::Parser::States::expr_shl($self); }
    if ($token->name eq 'shr') { return Kent::Parser::States::expr_shr($self); }
    if ($token->name eq 'star') { return Kent::Parser::States::expr_star($self); }
    if ($token->name eq 'starstar') { return Kent::Parser::States::expr_starstar($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_binand {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::expr_binand_expr($self); }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_binand_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'expr',
          'has'  => \@has, }
        );
}

sub expr_binor {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::expr_binor_expr($self); }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_binor_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'expr',
          'has'  => \@has, }
        );
}

sub expr_binxor {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::expr_binxor_expr($self); }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_binxor_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'expr',
          'has'  => \@has, }
        );
}

sub expr_comma {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'element',
          'has'  => \@has, }
        );
}

sub expr_eqeq {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::expr_eqeq_expr($self); }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_eqeq_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'cond',
          'has'  => \@has, }
        );
}

sub expr_fslash {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::expr_fslash_expr($self); }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_fslash_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'expr',
          'has'  => \@has, }
        );
}

sub expr_gt {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::expr_gt_expr($self); }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_gt_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'cond',
          'has'  => \@has, }
        );
}

sub expr_logand {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::expr_logand_expr($self); }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_logand_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'expr',
          'has'  => \@has, }
        );
}

sub expr_logor {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::expr_logor_expr($self); }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_logor_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'expr',
          'has'  => \@has, }
        );
}

sub expr_logxor {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::expr_logxor_expr($self); }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_logxor_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'expr',
          'has'  => \@has, }
        );
}

sub expr_lt {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::expr_lt_expr($self); }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_lt_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'cond',
          'has'  => \@has, }
        );
}

sub expr_match {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::expr_match_expr($self); }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_match_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'cond',
          'has'  => \@has, }
        );
}

sub expr_minus {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::expr_minus_expr($self); }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_minus_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'expr',
          'has'  => \@has, }
        );
}

sub expr_ne {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::expr_ne_expr($self); }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_ne_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'cond',
          'has'  => \@has, }
        );
}

sub expr_ngt {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::expr_ngt_expr($self); }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_ngt_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'cond',
          'has'  => \@has, }
        );
}

sub expr_nlt {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::expr_nlt_expr($self); }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_nlt_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'cond',
          'has'  => \@has, }
        );
}

sub expr_nomatch {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::expr_nomatch_expr($self); }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_nomatch_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'cond',
          'has'  => \@has, }
        );
}

sub expr_percent {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::expr_percent_expr($self); }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_percent_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'expr',
          'has'  => \@has, }
        );
}

sub expr_plus {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::expr_plus_expr($self); }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_plus_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'expr',
          'has'  => \@has, }
        );
}

sub expr_shl {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::expr_shl_expr($self); }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_shl_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'expr',
          'has'  => \@has, }
        );
}

sub expr_shr {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::expr_shr_expr($self); }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_shr_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'expr',
          'has'  => \@has, }
        );
}

sub expr_star {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::expr_star_expr($self); }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_star_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'expr',
          'has'  => \@has, }
        );
}

sub expr_starstar {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::expr_starstar_expr($self); }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_starstar_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'expr',
          'has'  => \@has, }
        );
}

sub for {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'fqid') { return Kent::Parser::States::for_fqid($self); }
    if ($token->name eq 'id') { return Kent::Parser::States::for_id($self); }
    if ($token->name eq 'range') { return Kent::Parser::States::for_range($self); }
    if ($token->name eq 'access') { $token = Kent::Parser::States::access($self); goto AGAIN; }
    if ($token->name eq 'dot') { $token = Kent::Parser::States::dot($self); goto AGAIN; }
    if ($token->name eq 'id') { $token = Kent::Parser::States::id($self); goto AGAIN; }
    if ($token->name eq 'int') { $token = Kent::Parser::States::int($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub for_fqid {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'codeblock') { return Kent::Parser::States::for_fqid_codeblock($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub for_fqid_codeblock {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'loop',
          'has'  => \@has, }
        );
}

sub for_id {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'in') { return Kent::Parser::States::for_id_in($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub for_id_in {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'fqid') { return Kent::Parser::States::for_id_in_fqid($self); }
    if ($token->name eq 'range') { return Kent::Parser::States::for_id_in_range($self); }
    if ($token->name eq 'access') { $token = Kent::Parser::States::access($self); goto AGAIN; }
    if ($token->name eq 'dot') { $token = Kent::Parser::States::dot($self); goto AGAIN; }
    if ($token->name eq 'id') { $token = Kent::Parser::States::id($self); goto AGAIN; }
    if ($token->name eq 'int') { $token = Kent::Parser::States::int($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub for_id_in_fqid {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'array') { return Kent::Parser::States::for_id_in_fqid_array($self); }
    if ($token->name eq 'embraces') { $token = Kent::Parser::States::embraces($self); goto AGAIN; }
    if ($token->name eq 'lbrace') { $token = Kent::Parser::States::lbrace($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub for_id_in_fqid_array {
    my ($self) = @_;

    my @has;
    foreach (1..5) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'loop',
          'has'  => \@has, }
        );
}

sub for_id_in_range {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'array') { return Kent::Parser::States::for_id_in_range_array($self); }
    if ($token->name eq 'embraces') { $token = Kent::Parser::States::embraces($self); goto AGAIN; }
    if ($token->name eq 'lbrace') { $token = Kent::Parser::States::lbrace($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub for_id_in_range_array {
    my ($self) = @_;

    my @has;
    foreach (1..5) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'loop',
          'has'  => \@has, }
        );
}

sub for_range {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'array') { return Kent::Parser::States::for_range_array($self); }
    if ($token->name eq 'embraces') { $token = Kent::Parser::States::embraces($self); goto AGAIN; }
    if ($token->name eq 'lbrace') { $token = Kent::Parser::States::lbrace($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub for_range_array {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'loop',
          'has'  => \@has, }
        );
}

sub fqid {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);
    if ($token->name eq 'minusminus') { return Kent::Parser::States::fqid_minusminus($self); }
    if ($token->name eq 'plusplus') { return Kent::Parser::States::fqid_plusplus($self); }
    if ($token->name eq 'space') { return Kent::Parser::States::fqid_space($self); }

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'arglist') { return Kent::Parser::States::fqid_arglist($self); }
    if ($token->name eq 'compose') { return Kent::Parser::States::fqid_compose($self); }
    if ($token->name eq 'emparens') { return Kent::Parser::States::fqid_emparens($self); }
    if ($token->name eq 'eq') { return Kent::Parser::States::fqid_eq($self); }
    if ($token->name eq 'parenexpr') { return Kent::Parser::States::fqid_parenexpr($self); }
    if ($token->name eq 'lparen') { $token = Kent::Parser::States::lparen($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub fqid_minusminus {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'expr',
          'has'  => \@has, }
        );
}

sub fqid_plusplus {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'expr',
          'has'  => \@has, }
        );
}

sub fqid_space {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'expr',
          'has'  => \@has, }
        );
}

sub fqid_arglist {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'statement',
          'has'  => \@has, }
        );
}

sub fqid_compose {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'array') { return Kent::Parser::States::fqid_compose_array($self); }
    if ($token->name eq 'fqid') { return Kent::Parser::States::fqid_compose_fqid($self); }
    if ($token->name eq 'function') { return Kent::Parser::States::fqid_compose_function($self); }
    if ($token->name eq 'hash') { return Kent::Parser::States::fqid_compose_hash($self); }
    if ($token->name eq 'num') { return Kent::Parser::States::fqid_compose_num($self); }
    if ($token->name eq 'str') { return Kent::Parser::States::fqid_compose_str($self); }
    if ($token->name eq 'access') { $token = Kent::Parser::States::access($self); goto AGAIN; }
    if ($token->name eq 'dot') { $token = Kent::Parser::States::dot($self); goto AGAIN; }
    if ($token->name eq 'embraces') { $token = Kent::Parser::States::embraces($self); goto AGAIN; }
    if ($token->name eq 'emcurlies') { $token = Kent::Parser::States::emcurlies($self); goto AGAIN; }
    if ($token->name eq 'emparens') { $token = Kent::Parser::States::emparens($self); goto AGAIN; }
    if ($token->name eq 'hex') { $token = Kent::Parser::States::hex($self); goto AGAIN; }
    if ($token->name eq 'id') { $token = Kent::Parser::States::id($self); goto AGAIN; }
    if ($token->name eq 'int') { $token = Kent::Parser::States::int($self); goto AGAIN; }
    if ($token->name eq 'lbrace') { $token = Kent::Parser::States::lbrace($self); goto AGAIN; }
    if ($token->name eq 'lcurly') { $token = Kent::Parser::States::lcurly($self); goto AGAIN; }
    if ($token->name eq 'oct') { $token = Kent::Parser::States::oct($self); goto AGAIN; }
    if ($token->name eq 'rat') { $token = Kent::Parser::States::rat($self); goto AGAIN; }
    if ($token->name eq 'sci') { $token = Kent::Parser::States::sci($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub fqid_compose_array {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'statement',
          'has'  => \@has, }
        );
}

sub fqid_compose_fqid {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'statement',
          'has'  => \@has, }
        );
}

sub fqid_compose_function {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'statement',
          'has'  => \@has, }
        );
}

sub fqid_compose_hash {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'statement',
          'has'  => \@has, }
        );
}

sub fqid_compose_num {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'statement',
          'has'  => \@has, }
        );
}

sub fqid_compose_str {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'statement',
          'has'  => \@has, }
        );
}

sub fqid_emparens {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'statement',
          'has'  => \@has, }
        );
}

sub fqid_eq {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::fqid_eq_expr($self); }
    if ($token->name eq 'fqid') { return Kent::Parser::States::fqid_eq_fqid($self); }
    if ($token->name eq 'access') { $token = Kent::Parser::States::access($self); goto AGAIN; }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'dot') { $token = Kent::Parser::States::dot($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'id') { $token = Kent::Parser::States::id($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub fqid_eq_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'statement',
          'has'  => \@has, }
        );
}

sub fqid_eq_fqid {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'statement',
          'has'  => \@has, }
        );
}

sub fqid_parenexpr {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'statement',
          'has'  => \@has, }
        );
}

sub hashkey {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'comma') { return Kent::Parser::States::hashkey_comma($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub hashkey_comma {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'str') { return Kent::Parser::States::hashkey_comma_str($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub hashkey_comma_str {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'hashrocket') { return Kent::Parser::States::hashkey_comma_str_hashrocket($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub hashkey_comma_str_hashrocket {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::hashkey_comma_str_hashrocket_expr($self); }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub hashkey_comma_str_hashrocket_expr {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'comma') { return Kent::Parser::States::hashkey_comma_str_hashrocket_expr_comma($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub hashkey_comma_str_hashrocket_expr_comma {
    my ($self) = @_;

    my @has;
    foreach (1..6) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'hashkey',
          'has'  => \@has, }
        );
}

sub hex {
    return Kent::Token->new( { 'name' => 'num' } );
}

sub id {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);
    if ($token->name eq 'dotdot') { return Kent::Parser::States::id_dotdot($self); }
    if ($token->name eq 'space') { return Kent::Parser::States::id_space($self); }

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub id_dotdot {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);
    if ($token->name eq 'id') { return Kent::Parser::States::id_dotdot_id($self); }
    if ($token->name eq 'int') { return Kent::Parser::States::id_dotdot_int($self); }

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub id_dotdot_id {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'range',
          'has'  => \@has, }
        );
}

sub id_dotdot_int {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'range',
          'has'  => \@has, }
        );
}

sub id_space {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'fqid',
          'has'  => \@has, }
        );
}

sub if {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'cond') { return Kent::Parser::States::if_cond($self); }
    if ($token->name eq 'fqid') { return Kent::Parser::States::if_fqid($self); }
    if ($token->name eq 'access') { $token = Kent::Parser::States::access($self); goto AGAIN; }
    if ($token->name eq 'dot') { $token = Kent::Parser::States::dot($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'id') { $token = Kent::Parser::States::id($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub if_cond {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'codeblock') { return Kent::Parser::States::if_cond_codeblock($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub if_cond_codeblock {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'ifblock',
          'has'  => \@has, }
        );
}

sub if_fqid {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'codeblock') { return Kent::Parser::States::if_fqid_codeblock($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub if_fqid_codeblock {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'ifblock',
          'has'  => \@has, }
        );
}

sub ifblock {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);
    if ($token->name eq 'space') { return Kent::Parser::States::ifblock_space($self); }

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'elseblock') { return Kent::Parser::States::ifblock_elseblock($self); }
    if ($token->name eq 'elseifblock') { return Kent::Parser::States::ifblock_elseifblock($self); }
    if ($token->name eq 'else') { $token = Kent::Parser::States::else($self); goto AGAIN; }
    if ($token->name eq 'elseif') { $token = Kent::Parser::States::elseif($self); goto AGAIN; }
    if ($token->name eq 'elseifblock') { $token = Kent::Parser::States::elseifblock($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub ifblock_space {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'branch',
          'has'  => \@has, }
        );
}

sub ifblock_elseblock {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'branch',
          'has'  => \@has, }
        );
}

sub ifblock_elseifblock {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);
    if ($token->name eq 'space') { return Kent::Parser::States::ifblock_elseifblock_space($self); }

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'elseblock') { return Kent::Parser::States::ifblock_elseifblock_elseblock($self); }
    if ($token->name eq 'else') { $token = Kent::Parser::States::else($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub ifblock_elseifblock_space {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'branch',
          'has'  => \@has, }
        );
}

sub ifblock_elseifblock_elseblock {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'branch',
          'has'  => \@has, }
        );
}

sub int {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);
    if ($token->name eq 'dotdot') { return Kent::Parser::States::int_dotdot($self); }
    if ($token->name eq 'space') { return Kent::Parser::States::int_space($self); }

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub int_dotdot {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);
    if ($token->name eq 'id') { return Kent::Parser::States::int_dotdot_id($self); }
    if ($token->name eq 'int') { return Kent::Parser::States::int_dotdot_int($self); }

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub int_dotdot_id {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'range',
          'has'  => \@has, }
        );
}

sub int_dotdot_int {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'range',
          'has'  => \@has, }
        );
}

sub int_space {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'num',
          'has'  => \@has, }
        );
}

sub lbrace {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'element') { return Kent::Parser::States::lbrace_element($self); }
    if ($token->name eq 'expr') { return Kent::Parser::States::lbrace_expr($self); }
    if ($token->name eq 'rbrace') { return Kent::Parser::States::lbrace_rbrace($self); }
    if ($token->name eq 'statement') { return Kent::Parser::States::lbrace_statement($self); }
    if ($token->name eq 'annotated') { $token = Kent::Parser::States::annotated($self); goto AGAIN; }
    if ($token->name eq 'array') { $token = Kent::Parser::States::array($self); goto AGAIN; }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'branch') { $token = Kent::Parser::States::branch($self); goto AGAIN; }
    if ($token->name eq 'element') { $token = Kent::Parser::States::element($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'loop') { $token = Kent::Parser::States::loop($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    if ($token->name eq 'statement') { $token = Kent::Parser::States::statement($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lbrace_element {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::lbrace_element_expr($self); }
    if ($token->name eq 'rbrace') { return Kent::Parser::States::lbrace_element_rbrace($self); }
    if ($token->name eq 'statement') { return Kent::Parser::States::lbrace_element_statement($self); }
    if ($token->name eq 'annotated') { $token = Kent::Parser::States::annotated($self); goto AGAIN; }
    if ($token->name eq 'array') { $token = Kent::Parser::States::array($self); goto AGAIN; }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'branch') { $token = Kent::Parser::States::branch($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'loop') { $token = Kent::Parser::States::loop($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lbrace_element_expr {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'rbrace') { return Kent::Parser::States::lbrace_element_expr_rbrace($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lbrace_element_expr_rbrace {
    my ($self) = @_;

    my @has;
    foreach (1..4) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'array',
          'has'  => \@has, }
        );
}

sub lbrace_element_rbrace {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'array',
          'has'  => \@has, }
        );
}

sub lbrace_element_statement {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'rbrace') { return Kent::Parser::States::lbrace_element_statement_rbrace($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lbrace_element_statement_rbrace {
    my ($self) = @_;

    my @has;
    foreach (1..4) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'array',
          'has'  => \@has, }
        );
}

sub lbrace_expr {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'rbrace') { return Kent::Parser::States::lbrace_expr_rbrace($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lbrace_expr_rbrace {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'array',
          'has'  => \@has, }
        );
}

sub lbrace_rbrace {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'embraces',
          'has'  => \@has, }
        );
}

sub lbrace_statement {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'rbrace') { return Kent::Parser::States::lbrace_statement_rbrace($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lbrace_statement_rbrace {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'array',
          'has'  => \@has, }
        );
}

sub lcmt {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);
    if ($token->name eq 'char') { return Kent::Parser::States::lcmt_char($self); }

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'rcmt') { return Kent::Parser::States::lcmt_rcmt($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lcmt_char {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'rcmt') { return Kent::Parser::States::lcmt_char_rcmt($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lcmt_char_rcmt {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'comment',
          'has'  => \@has, }
        );
}

sub lcmt_rcmt {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'comment',
          'has'  => \@has, }
        );
}

sub lcurly {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'hashkey') { return Kent::Parser::States::lcurly_hashkey($self); }
    if ($token->name eq 'rcurly') { return Kent::Parser::States::lcurly_rcurly($self); }
    if ($token->name eq 'str') { return Kent::Parser::States::lcurly_str($self); }
    if ($token->name eq 'hashkey') { $token = Kent::Parser::States::hashkey($self); goto AGAIN; }
    if ($token->name eq 'str') { $token = Kent::Parser::States::str($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lcurly_hashkey {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'rcurly') { return Kent::Parser::States::lcurly_hashkey_rcurly($self); }
    if ($token->name eq 'str') { return Kent::Parser::States::lcurly_hashkey_str($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lcurly_hashkey_rcurly {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'hash',
          'has'  => \@has, }
        );
}

sub lcurly_hashkey_str {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'hashrocket') { return Kent::Parser::States::lcurly_hashkey_str_hashrocket($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lcurly_hashkey_str_hashrocket {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::lcurly_hashkey_str_hashrocket_expr($self); }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lcurly_hashkey_str_hashrocket_expr {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'rcurly') { return Kent::Parser::States::lcurly_hashkey_str_hashrocket_expr_rcurly($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lcurly_hashkey_str_hashrocket_expr_rcurly {
    my ($self) = @_;

    my @has;
    foreach (1..6) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'hash',
          'has'  => \@has, }
        );
}

sub lcurly_rcurly {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'emcurlies',
          'has'  => \@has, }
        );
}

sub lcurly_str {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'hashrocket') { return Kent::Parser::States::lcurly_str_hashrocket($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lcurly_str_hashrocket {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::lcurly_str_hashrocket_expr($self); }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lcurly_str_hashrocket_expr {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'rcurly') { return Kent::Parser::States::lcurly_str_hashrocket_expr_rcurly($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lcurly_str_hashrocket_expr_rcurly {
    my ($self) = @_;

    my @has;
    foreach (1..5) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'hash',
          'has'  => \@has, }
        );
}

sub literal {
    return Kent::Token->new( { 'name' => 'expr' } );
}

sub loop {
    return Kent::Token->new( { 'name' => 'statement' } );
}

sub lparen {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::lparen_expr($self); }
    if ($token->name eq 'rparen') { return Kent::Parser::States::lparen_rparen($self); }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lparen_expr {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'rparen') { return Kent::Parser::States::lparen_expr_rparen($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lparen_expr_rparen {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'parenexpr',
          'has'  => \@has, }
        );
}

sub lparen_rparen {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'emparens',
          'has'  => \@has, }
        );
}

sub minus {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);
    if ($token->name eq 'fqid') { return Kent::Parser::States::minus_fqid($self); }

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub minus_fqid {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'expr',
          'has'  => \@has, }
        );
}

sub minusminus {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);
    if ($token->name eq 'fqid') { return Kent::Parser::States::minusminus_fqid($self); }

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub minusminus_fqid {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'expr',
          'has'  => \@has, }
        );
}

sub num {
    return Kent::Token->new( { 'name' => 'literal' } );
}

sub oct {
    return Kent::Token->new( { 'name' => 'num' } );
}

sub plusplus {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);
    if ($token->name eq 'fqid') { return Kent::Parser::States::plusplus_fqid($self); }

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub plusplus_fqid {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'expr',
          'has'  => \@has, }
        );
}

sub range {
    return Kent::Token->new( { 'name' => 'literal' } );
}

sub rat {
    return Kent::Token->new( { 'name' => 'num' } );
}

sub sci {
    return Kent::Token->new( { 'name' => 'num' } );
}

sub statement {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'comma') { return Kent::Parser::States::statement_comma($self); }
    if ($token->name eq 'comment') { return Kent::Parser::States::statement_comment($self); }
    if ($token->name eq 'lcmt') { $token = Kent::Parser::States::lcmt($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub statement_comma {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'code',
          'has'  => \@has, }
        );
}

sub statement_comment {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'annotated',
          'has'  => \@has, }
        );
}

sub str {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);
    if ($token->name eq 'space') { return Kent::Parser::States::str_space($self); }

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'hashrocket') { return Kent::Parser::States::str_hashrocket($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub str_space {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'literal',
          'has'  => \@has, }
        );
}

sub str_hashrocket {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return Kent::Parser::States::str_hashrocket_expr($self); }
    if ($token->name eq 'bang') { $token = Kent::Parser::States::bang($self); goto AGAIN; }
    if ($token->name eq 'expr') { $token = Kent::Parser::States::expr($self); goto AGAIN; }
    if ($token->name eq 'fqid') { $token = Kent::Parser::States::fqid($self); goto AGAIN; }
    if ($token->name eq 'literal') { $token = Kent::Parser::States::literal($self); goto AGAIN; }
    if ($token->name eq 'minus') { $token = Kent::Parser::States::minus($self); goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = Kent::Parser::States::minusminus($self); goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = Kent::Parser::States::plusplus($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub str_hashrocket_expr {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'comma') { return Kent::Parser::States::str_hashrocket_expr_comma($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub str_hashrocket_expr_comma {
    my ($self) = @_;

    my @has;
    foreach (1..4) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'hashkey',
          'has'  => \@has, }
        );
}

sub until {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'condition') { return Kent::Parser::States::until_condition($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub until_condition {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'array') { return Kent::Parser::States::until_condition_array($self); }
    if ($token->name eq 'embraces') { $token = Kent::Parser::States::embraces($self); goto AGAIN; }
    if ($token->name eq 'lbrace') { $token = Kent::Parser::States::lbrace($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub until_condition_array {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'loop',
          'has'  => \@has, }
        );
}

sub while {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'condition') { return Kent::Parser::States::while_condition($self); }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub while_condition {
    my ($self) = @_;
    say $self->join("_");
    my $lexer  = $self->lexer;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') { $self->pop; $token = $lexer->next; }

  AGAIN:
    if ($token->name eq 'array') { return Kent::Parser::States::while_condition_array($self); }
    if ($token->name eq 'embraces') { $token = Kent::Parser::States::embraces($self); goto AGAIN; }
    if ($token->name eq 'lbrace') { $token = Kent::Parser::States::lbrace($self); goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub while_condition_array {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->pop;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'loop',
          'has'  => \@has, }
        );
}


1;
