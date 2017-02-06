package Kent::Parser::States;

use strict;
use warnings;
use v5.14;

sub access {
    my ($self) = @_;
    $self->push( Kent::Token->new(
        'name' => 'fqid',
        'has'  => [],
    ) );
    return 1;
}

sub annotated {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'comment') { return $self->annotated_comment; }
    if ($token->name eq 'lcmt') { $self->lcmt; $token = $self->top; goto AGAIN; }
   return $self->annotated_default;
}

sub annotated_comment {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'annotated',
        'has'  => $has,
        ) );
    return 1;
}

sub annotated_default {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'statement',
        'has'  => $has,
        ) );
    return 1;
}

sub array {
    my ($self) = @_;
    $self->push( Kent::Token->new(
        'name' => 'statement',
        'has'  => [],
    ) );
    return 1;
}

sub bang {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);
    if ($token->name eq 'fqid') { return $self->bang_fqid; }

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub bang_fqid {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'expr',
        'has'  => $has,
        ) );
    return 1;
}

sub bof {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'code') { return $self->bof_code; }
    if ($token->name eq 'statement') { return $self->bof_statement; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'annotated') { $self->annotated; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'array') { $self->array; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bof') { $self->bof; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'branch') { $self->branch; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'comment') { $self->comment; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'embraces') { $self->embraces; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'for') { $self->for; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'if') { $self->if; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'ifblock') { $self->ifblock; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'lbrace') { $self->lbrace; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'lcmt') { $self->lcmt; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'loop') { $self->loop; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'statement') { $self->statement; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'until') { $self->until; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'while') { $self->while; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub bof_code {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'eof') { return $self->bof_code_eof; }
    if ($token->name eq 'statement') { return $self->bof_code_statement; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'annotated') { $self->annotated; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'array') { $self->array; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'branch') { $self->branch; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'comment') { $self->comment; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'embraces') { $self->embraces; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'for') { $self->for; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'if') { $self->if; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'ifblock') { $self->ifblock; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'lbrace') { $self->lbrace; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'lcmt') { $self->lcmt; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'loop') { $self->loop; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'statement') { $self->statement; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'until') { $self->until; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'while') { $self->while; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub bof_code_eof {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'file',
        'has'  => $has,
        ) );
    return 1;
}

sub bof_code_statement {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'eof') { return $self->bof_code_statement_eof; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub bof_code_statement_eof {
    my ($self) = @_;

    my $has = [];
    foreach (1..4) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'file',
        'has'  => $has,
        ) );
    return 1;
}

sub bof_statement {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'comma') { return $self->bof_statement_comma; }
    if ($token->name eq 'eof') { return $self->bof_statement_eof; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub bof_statement_comma {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'code',
        'has'  => $has,
        ) );
    return 1;
}

sub bof_statement_eof {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'file',
        'has'  => $has,
        ) );
    return 1;
}

sub branch {
    my ($self) = @_;
    $self->push( Kent::Token->new(
        'name' => 'statement',
        'has'  => [],
    ) );
    return 1;
}

sub char {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);
    if ($token->name eq 'char') { return $self->char_char; }

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub char_char {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'char',
        'has'  => $has,
        ) );
    return 1;
}

sub comment {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'annotated') { return $self->comment_annotated; }
    if ($token->name eq 'statement') { return $self->comment_statement; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'annotated') { $self->annotated; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'array') { $self->array; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'branch') { $self->branch; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'comment') { $self->comment; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'embraces') { $self->embraces; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'for') { $self->for; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'if') { $self->if; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'ifblock') { $self->ifblock; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'lbrace') { $self->lbrace; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'lcmt') { $self->lcmt; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'loop') { $self->loop; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'statement') { $self->statement; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'until') { $self->until; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'while') { $self->while; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub comment_annotated {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'annotated',
        'has'  => $has,
        ) );
    return 1;
}

sub comment_statement {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'annotated',
        'has'  => $has,
        ) );
    return 1;
}

sub dot {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);
    if ($token->name eq 'fqid') { return $self->dot_fqid; }
    if ($token->name eq 'lbrace') { return $self->dot_lbrace; }

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
   return $self->dot_default;
}

sub dot_fqid {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'access',
        'has'  => $has,
        ) );
    return 1;
}

sub dot_lbrace {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'id') { return $self->dot_lbrace_id; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub dot_lbrace_id {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'rbrace') { return $self->dot_lbrace_id_rbrace; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub dot_lbrace_id_rbrace {
    my ($self) = @_;

    my $has = [];
    foreach (1..4) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'access',
        'has'  => $has,
        ) );
    return 1;
}

sub dot_default {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'fqid',
        'has'  => $has,
        ) );
    return 1;
}

sub element {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->element_expr; }
    if ($token->name eq 'statement') { return $self->element_statement; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'annotated') { $self->annotated; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'array') { $self->array; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'branch') { $self->branch; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'comment') { $self->comment; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'embraces') { $self->embraces; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'for') { $self->for; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'if') { $self->if; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'ifblock') { $self->ifblock; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'lbrace') { $self->lbrace; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'lcmt') { $self->lcmt; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'loop') { $self->loop; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'statement') { $self->statement; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'until') { $self->until; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'while') { $self->while; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub element_expr {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'comma') { return $self->element_expr_comma; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub element_expr_comma {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'element',
        'has'  => $has,
        ) );
    return 1;
}

sub element_statement {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'comma') { return $self->element_statement_comma; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub element_statement_comma {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'element',
        'has'  => $has,
        ) );
    return 1;
}

sub else {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'codeblock') { return $self->else_codeblock; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub else_codeblock {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'elseblock',
        'has'  => $has,
        ) );
    return 1;
}

sub elseif {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'cond') { return $self->elseif_cond; }
    if ($token->name eq 'fqid') { return $self->elseif_fqid; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub elseif_cond {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'codeblock') { return $self->elseif_cond_codeblock; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub elseif_cond_codeblock {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'elseifblock',
        'has'  => $has,
        ) );
    return 1;
}

sub elseif_fqid {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'codeblock') { return $self->elseif_fqid_codeblock; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub elseif_fqid_codeblock {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'hashrocket') { return $self->elseif_fqid_codeblock_hashrocket; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub elseif_fqid_codeblock_hashrocket {
    my ($self) = @_;

    my $has = [];
    foreach (1..4) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'elseifblock',
        'has'  => $has,
        ) );
    return 1;
}

sub elseifblock {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'elseif') { return $self->elseifblock_elseif; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub elseifblock_elseif {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'cond') { return $self->elseifblock_elseif_cond; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub elseifblock_elseif_cond {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'codeblock') { return $self->elseifblock_elseif_cond_codeblock; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub elseifblock_elseif_cond_codeblock {
    my ($self) = @_;

    my $has = [];
    foreach (1..4) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'elseifblock',
        'has'  => $has,
        ) );
    return 1;
}

sub embraces {
    my ($self) = @_;
    $self->push( Kent::Token->new(
        'name' => 'array',
        'has'  => [],
    ) );
    return 1;
}

sub emcurlies {
    my ($self) = @_;
    $self->push( Kent::Token->new(
        'name' => 'hash',
        'has'  => [],
    ) );
    return 1;
}

sub emparens {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'array') { return $self->emparens_array; }
    if ($token->name eq 'embraces') { $self->embraces; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'lbrace') { $self->lbrace; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub emparens_array {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'function',
        'has'  => $has,
        ) );
    return 1;
}

sub expr {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'binand') { return $self->expr_binand; }
    if ($token->name eq 'binor') { return $self->expr_binor; }
    if ($token->name eq 'binxor') { return $self->expr_binxor; }
    if ($token->name eq 'comma') { return $self->expr_comma; }
    if ($token->name eq 'eqeq') { return $self->expr_eqeq; }
    if ($token->name eq 'fslash') { return $self->expr_fslash; }
    if ($token->name eq 'gt') { return $self->expr_gt; }
    if ($token->name eq 'logand') { return $self->expr_logand; }
    if ($token->name eq 'logor') { return $self->expr_logor; }
    if ($token->name eq 'logxor') { return $self->expr_logxor; }
    if ($token->name eq 'lt') { return $self->expr_lt; }
    if ($token->name eq 'match') { return $self->expr_match; }
    if ($token->name eq 'minus') { return $self->expr_minus; }
    if ($token->name eq 'ne') { return $self->expr_ne; }
    if ($token->name eq 'ngt') { return $self->expr_ngt; }
    if ($token->name eq 'nlt') { return $self->expr_nlt; }
    if ($token->name eq 'nomatch') { return $self->expr_nomatch; }
    if ($token->name eq 'percent') { return $self->expr_percent; }
    if ($token->name eq 'plus') { return $self->expr_plus; }
    if ($token->name eq 'shl') { return $self->expr_shl; }
    if ($token->name eq 'shr') { return $self->expr_shr; }
    if ($token->name eq 'star') { return $self->expr_star; }
    if ($token->name eq 'starstar') { return $self->expr_starstar; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_binand {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_binand_expr; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_binand_expr {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'expr',
        'has'  => $has,
        ) );
    return 1;
}

sub expr_binor {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_binor_expr; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_binor_expr {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'expr',
        'has'  => $has,
        ) );
    return 1;
}

sub expr_binxor {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_binxor_expr; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_binxor_expr {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'expr',
        'has'  => $has,
        ) );
    return 1;
}

sub expr_comma {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'element',
        'has'  => $has,
        ) );
    return 1;
}

sub expr_eqeq {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_eqeq_expr; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_eqeq_expr {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'cond',
        'has'  => $has,
        ) );
    return 1;
}

sub expr_fslash {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_fslash_expr; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_fslash_expr {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'expr',
        'has'  => $has,
        ) );
    return 1;
}

sub expr_gt {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_gt_expr; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_gt_expr {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'cond',
        'has'  => $has,
        ) );
    return 1;
}

sub expr_logand {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_logand_expr; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_logand_expr {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'expr',
        'has'  => $has,
        ) );
    return 1;
}

sub expr_logor {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_logor_expr; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_logor_expr {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'expr',
        'has'  => $has,
        ) );
    return 1;
}

sub expr_logxor {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_logxor_expr; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_logxor_expr {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'expr',
        'has'  => $has,
        ) );
    return 1;
}

sub expr_lt {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_lt_expr; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_lt_expr {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'cond',
        'has'  => $has,
        ) );
    return 1;
}

sub expr_match {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_match_expr; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_match_expr {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'cond',
        'has'  => $has,
        ) );
    return 1;
}

sub expr_minus {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_minus_expr; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_minus_expr {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'expr',
        'has'  => $has,
        ) );
    return 1;
}

sub expr_ne {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_ne_expr; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_ne_expr {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'cond',
        'has'  => $has,
        ) );
    return 1;
}

sub expr_ngt {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_ngt_expr; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_ngt_expr {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'cond',
        'has'  => $has,
        ) );
    return 1;
}

sub expr_nlt {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_nlt_expr; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_nlt_expr {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'cond',
        'has'  => $has,
        ) );
    return 1;
}

sub expr_nomatch {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_nomatch_expr; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_nomatch_expr {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'cond',
        'has'  => $has,
        ) );
    return 1;
}

sub expr_percent {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_percent_expr; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_percent_expr {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'expr',
        'has'  => $has,
        ) );
    return 1;
}

sub expr_plus {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_plus_expr; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_plus_expr {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'expr',
        'has'  => $has,
        ) );
    return 1;
}

sub expr_shl {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_shl_expr; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_shl_expr {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'expr',
        'has'  => $has,
        ) );
    return 1;
}

sub expr_shr {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_shr_expr; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_shr_expr {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'expr',
        'has'  => $has,
        ) );
    return 1;
}

sub expr_star {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_star_expr; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_star_expr {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'expr',
        'has'  => $has,
        ) );
    return 1;
}

sub expr_starstar {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_starstar_expr; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub expr_starstar_expr {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'expr',
        'has'  => $has,
        ) );
    return 1;
}

sub for {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'fqid') { return $self->for_fqid; }
    if ($token->name eq 'id') { return $self->for_id; }
    if ($token->name eq 'range') { return $self->for_range; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub for_fqid {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'codeblock') { return $self->for_fqid_codeblock; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub for_fqid_codeblock {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'loop',
        'has'  => $has,
        ) );
    return 1;
}

sub for_id {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'in') { return $self->for_id_in; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub for_id_in {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'fqid') { return $self->for_id_in_fqid; }
    if ($token->name eq 'range') { return $self->for_id_in_range; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub for_id_in_fqid {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'array') { return $self->for_id_in_fqid_array; }
    if ($token->name eq 'embraces') { $self->embraces; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'lbrace') { $self->lbrace; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub for_id_in_fqid_array {
    my ($self) = @_;

    my $has = [];
    foreach (1..5) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'loop',
        'has'  => $has,
        ) );
    return 1;
}

sub for_id_in_range {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'array') { return $self->for_id_in_range_array; }
    if ($token->name eq 'embraces') { $self->embraces; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'lbrace') { $self->lbrace; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub for_id_in_range_array {
    my ($self) = @_;

    my $has = [];
    foreach (1..5) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'loop',
        'has'  => $has,
        ) );
    return 1;
}

sub for_range {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'array') { return $self->for_range_array; }
    if ($token->name eq 'embraces') { $self->embraces; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'lbrace') { $self->lbrace; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub for_range_array {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'loop',
        'has'  => $has,
        ) );
    return 1;
}

sub fqid {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);
    if ($token->name eq 'minusminus') { return $self->fqid_minusminus; }
    if ($token->name eq 'plusplus') { return $self->fqid_plusplus; }

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'arglist') { return $self->fqid_arglist; }
    if ($token->name eq 'compose') { return $self->fqid_compose; }
    if ($token->name eq 'emparens') { return $self->fqid_emparens; }
    if ($token->name eq 'eq') { return $self->fqid_eq; }
    if ($token->name eq 'parenexpr') { return $self->fqid_parenexpr; }
    if ($token->name eq 'lparen') { $self->lparen; $token = $self->top; goto AGAIN; }
   return $self->fqid_default;
}

sub fqid_minusminus {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'expr',
        'has'  => $has,
        ) );
    return 1;
}

sub fqid_plusplus {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'expr',
        'has'  => $has,
        ) );
    return 1;
}

sub fqid_arglist {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'statement',
        'has'  => $has,
        ) );
    return 1;
}

sub fqid_compose {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'array') { return $self->fqid_compose_array; }
    if ($token->name eq 'fqid') { return $self->fqid_compose_fqid; }
    if ($token->name eq 'function') { return $self->fqid_compose_function; }
    if ($token->name eq 'hash') { return $self->fqid_compose_hash; }
    if ($token->name eq 'num') { return $self->fqid_compose_num; }
    if ($token->name eq 'str') { return $self->fqid_compose_str; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'embraces') { $self->embraces; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'emcurlies') { $self->emcurlies; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'emparens') { $self->emparens; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'lbrace') { $self->lbrace; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'lcurly') { $self->lcurly; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'lparen') { $self->lparen; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub fqid_compose_array {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'statement',
        'has'  => $has,
        ) );
    return 1;
}

sub fqid_compose_fqid {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'statement',
        'has'  => $has,
        ) );
    return 1;
}

sub fqid_compose_function {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'statement',
        'has'  => $has,
        ) );
    return 1;
}

sub fqid_compose_hash {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'statement',
        'has'  => $has,
        ) );
    return 1;
}

sub fqid_compose_num {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'statement',
        'has'  => $has,
        ) );
    return 1;
}

sub fqid_compose_str {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'statement',
        'has'  => $has,
        ) );
    return 1;
}

sub fqid_default {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'expr',
        'has'  => $has,
        ) );
    return 1;
}

sub fqid_emparens {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'statement',
        'has'  => $has,
        ) );
    return 1;
}

sub fqid_eq {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->fqid_eq_expr; }
    if ($token->name eq 'fqid') { return $self->fqid_eq_fqid; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub fqid_eq_expr {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'statement',
        'has'  => $has,
        ) );
    return 1;
}

sub fqid_eq_fqid {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'statement',
        'has'  => $has,
        ) );
    return 1;
}

sub fqid_parenexpr {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'statement',
        'has'  => $has,
        ) );
    return 1;
}

sub hashkey {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'comma') { return $self->hashkey_comma; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub hashkey_comma {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'str') { return $self->hashkey_comma_str; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub hashkey_comma_str {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'hashrocket') { return $self->hashkey_comma_str_hashrocket; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub hashkey_comma_str_hashrocket {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->hashkey_comma_str_hashrocket_expr; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub hashkey_comma_str_hashrocket_expr {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'comma') { return $self->hashkey_comma_str_hashrocket_expr_comma; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub hashkey_comma_str_hashrocket_expr_comma {
    my ($self) = @_;

    my $has = [];
    foreach (1..6) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'hashkey',
        'has'  => $has,
        ) );
    return 1;
}

sub hex {
    my ($self) = @_;
    $self->push( Kent::Token->new(
        'name' => 'num',
        'has'  => [],
    ) );
    return 1;
}

sub id {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);
    if ($token->name eq 'dotdot') { return $self->id_dotdot; }

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
   return $self->id_default;
}

sub id_dotdot {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);
    if ($token->name eq 'id') { return $self->id_dotdot_id; }
    if ($token->name eq 'int') { return $self->id_dotdot_int; }

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub id_dotdot_id {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'range',
        'has'  => $has,
        ) );
    return 1;
}

sub id_dotdot_int {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'range',
        'has'  => $has,
        ) );
    return 1;
}

sub id_default {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'fqid',
        'has'  => $has,
        ) );
    return 1;
}

sub if {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'cond') { return $self->if_cond; }
    if ($token->name eq 'fqid') { return $self->if_fqid; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub if_cond {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'codeblock') { return $self->if_cond_codeblock; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub if_cond_codeblock {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'ifblock',
        'has'  => $has,
        ) );
    return 1;
}

sub if_fqid {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'codeblock') { return $self->if_fqid_codeblock; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub if_fqid_codeblock {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'ifblock',
        'has'  => $has,
        ) );
    return 1;
}

sub ifblock {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'elseblock') { return $self->ifblock_elseblock; }
    if ($token->name eq 'elseifblock') { return $self->ifblock_elseifblock; }
    if ($token->name eq 'else') { $self->else; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'elseif') { $self->elseif; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'elseifblock') { $self->elseifblock; $token = $self->top; goto AGAIN; }
   return $self->ifblock_default;
}

sub ifblock_default {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'branch',
        'has'  => $has,
        ) );
    return 1;
}

sub ifblock_elseblock {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'branch',
        'has'  => $has,
        ) );
    return 1;
}

sub ifblock_elseifblock {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'elseblock') { return $self->ifblock_elseifblock_elseblock; }
    if ($token->name eq 'else') { $self->else; $token = $self->top; goto AGAIN; }
   return $self->ifblock_elseifblock_default;
}

sub ifblock_elseifblock_default {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'branch',
        'has'  => $has,
        ) );
    return 1;
}

sub ifblock_elseifblock_elseblock {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'branch',
        'has'  => $has,
        ) );
    return 1;
}

sub int {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);
    if ($token->name eq 'dotdot') { return $self->int_dotdot; }

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
   return $self->int_default;
}

sub int_dotdot {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);
    if ($token->name eq 'id') { return $self->int_dotdot_id; }
    if ($token->name eq 'int') { return $self->int_dotdot_int; }

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub int_dotdot_id {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'range',
        'has'  => $has,
        ) );
    return 1;
}

sub int_dotdot_int {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'range',
        'has'  => $has,
        ) );
    return 1;
}

sub int_default {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'num',
        'has'  => $has,
        ) );
    return 1;
}

sub lbrace {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'element') { return $self->lbrace_element; }
    if ($token->name eq 'expr') { return $self->lbrace_expr; }
    if ($token->name eq 'rbrace') { return $self->lbrace_rbrace; }
    if ($token->name eq 'statement') { return $self->lbrace_statement; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'annotated') { $self->annotated; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'array') { $self->array; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'branch') { $self->branch; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'comment') { $self->comment; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'element') { $self->element; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'embraces') { $self->embraces; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'for') { $self->for; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'if') { $self->if; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'ifblock') { $self->ifblock; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'lbrace') { $self->lbrace; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'lcmt') { $self->lcmt; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'loop') { $self->loop; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'statement') { $self->statement; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'until') { $self->until; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'while') { $self->while; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lbrace_element {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->lbrace_element_expr; }
    if ($token->name eq 'rbrace') { return $self->lbrace_element_rbrace; }
    if ($token->name eq 'statement') { return $self->lbrace_element_statement; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'annotated') { $self->annotated; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'array') { $self->array; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'branch') { $self->branch; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'comment') { $self->comment; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'embraces') { $self->embraces; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'for') { $self->for; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'if') { $self->if; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'ifblock') { $self->ifblock; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'lbrace') { $self->lbrace; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'lcmt') { $self->lcmt; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'loop') { $self->loop; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'statement') { $self->statement; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'until') { $self->until; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'while') { $self->while; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lbrace_element_expr {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'rbrace') { return $self->lbrace_element_expr_rbrace; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lbrace_element_expr_rbrace {
    my ($self) = @_;

    my $has = [];
    foreach (1..4) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'array',
        'has'  => $has,
        ) );
    return 1;
}

sub lbrace_element_rbrace {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'array',
        'has'  => $has,
        ) );
    return 1;
}

sub lbrace_element_statement {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'rbrace') { return $self->lbrace_element_statement_rbrace; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lbrace_element_statement_rbrace {
    my ($self) = @_;

    my $has = [];
    foreach (1..4) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'array',
        'has'  => $has,
        ) );
    return 1;
}

sub lbrace_expr {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'rbrace') { return $self->lbrace_expr_rbrace; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lbrace_expr_rbrace {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'array',
        'has'  => $has,
        ) );
    return 1;
}

sub lbrace_rbrace {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'embraces',
        'has'  => $has,
        ) );
    return 1;
}

sub lbrace_statement {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'rbrace') { return $self->lbrace_statement_rbrace; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lbrace_statement_rbrace {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'array',
        'has'  => $has,
        ) );
    return 1;
}

sub lcmt {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);
    if ($token->name eq 'char') { return $self->lcmt_char; }

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'rcmt') { return $self->lcmt_rcmt; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lcmt_char {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'rcmt') { return $self->lcmt_char_rcmt; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lcmt_char_rcmt {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'comment',
        'has'  => $has,
        ) );
    return 1;
}

sub lcmt_rcmt {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'comment',
        'has'  => $has,
        ) );
    return 1;
}

sub lcurly {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'hashkey') { return $self->lcurly_hashkey; }
    if ($token->name eq 'rcurly') { return $self->lcurly_rcurly; }
    if ($token->name eq 'str') { return $self->lcurly_str; }
    if ($token->name eq 'hashkey') { $self->hashkey; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lcurly_hashkey {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'rcurly') { return $self->lcurly_hashkey_rcurly; }
    if ($token->name eq 'str') { return $self->lcurly_hashkey_str; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lcurly_hashkey_rcurly {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'hash',
        'has'  => $has,
        ) );
    return 1;
}

sub lcurly_hashkey_str {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'hashrocket') { return $self->lcurly_hashkey_str_hashrocket; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lcurly_hashkey_str_hashrocket {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->lcurly_hashkey_str_hashrocket_expr; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lcurly_hashkey_str_hashrocket_expr {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'rcurly') { return $self->lcurly_hashkey_str_hashrocket_expr_rcurly; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lcurly_hashkey_str_hashrocket_expr_rcurly {
    my ($self) = @_;

    my $has = [];
    foreach (1..6) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'hash',
        'has'  => $has,
        ) );
    return 1;
}

sub lcurly_rcurly {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'emcurlies',
        'has'  => $has,
        ) );
    return 1;
}

sub lcurly_str {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'hashrocket') { return $self->lcurly_str_hashrocket; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lcurly_str_hashrocket {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->lcurly_str_hashrocket_expr; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lcurly_str_hashrocket_expr {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'rcurly') { return $self->lcurly_str_hashrocket_expr_rcurly; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lcurly_str_hashrocket_expr_rcurly {
    my ($self) = @_;

    my $has = [];
    foreach (1..5) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'hash',
        'has'  => $has,
        ) );
    return 1;
}

sub literal {
    my ($self) = @_;
    $self->push( Kent::Token->new(
        'name' => 'expr',
        'has'  => [],
    ) );
    return 1;
}

sub loop {
    my ($self) = @_;
    $self->push( Kent::Token->new(
        'name' => 'statement',
        'has'  => [],
    ) );
    return 1;
}

sub lparen {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->lparen_expr; }
    if ($token->name eq 'rparen') { return $self->lparen_rparen; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lparen_expr {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'rparen') { return $self->lparen_expr_rparen; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub lparen_expr_rparen {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'parenexpr',
        'has'  => $has,
        ) );
    return 1;
}

sub lparen_rparen {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'emparens',
        'has'  => $has,
        ) );
    return 1;
}

sub minus {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);
    if ($token->name eq 'fqid') { return $self->minus_fqid; }

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub minus_fqid {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'expr',
        'has'  => $has,
        ) );
    return 1;
}

sub minusminus {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);
    if ($token->name eq 'fqid') { return $self->minusminus_fqid; }

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub minusminus_fqid {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'expr',
        'has'  => $has,
        ) );
    return 1;
}

sub num {
    my ($self) = @_;
    $self->push( Kent::Token->new(
        'name' => 'literal',
        'has'  => [],
    ) );
    return 1;
}

sub oct {
    my ($self) = @_;
    $self->push( Kent::Token->new(
        'name' => 'num',
        'has'  => [],
    ) );
    return 1;
}

sub plusplus {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);
    if ($token->name eq 'fqid') { return $self->plusplus_fqid; }

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub plusplus_fqid {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'expr',
        'has'  => $has,
        ) );
    return 1;
}

sub range {
    my ($self) = @_;
    $self->push( Kent::Token->new(
        'name' => 'literal',
        'has'  => [],
    ) );
    return 1;
}

sub rat {
    my ($self) = @_;
    $self->push( Kent::Token->new(
        'name' => 'num',
        'has'  => [],
    ) );
    return 1;
}

sub sci {
    my ($self) = @_;
    $self->push( Kent::Token->new(
        'name' => 'num',
        'has'  => [],
    ) );
    return 1;
}

sub statement {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'comma') { return $self->statement_comma; }
    if ($token->name eq 'comment') { return $self->statement_comment; }
    if ($token->name eq 'lcmt') { $self->lcmt; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub statement_comma {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'code',
        'has'  => $has,
        ) );
    return 1;
}

sub statement_comment {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'annotated',
        'has'  => $has,
        ) );
    return 1;
}

sub str {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'hashrocket') { return $self->str_hashrocket; }
   return $self->str_default;
}

sub str_default {
    my ($self) = @_;

    my $has = [];
    foreach (1..2) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'literal',
        'has'  => $has,
        ) );
    return 1;
}

sub str_hashrocket {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'expr') { return $self->str_hashrocket_expr; }
    if ($token->name eq 'access') { $self->access; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'bang') { $self->bang; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'dot') { $self->dot; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'expr') { $self->expr; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'fqid') { $self->fqid; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'hex') { $self->hex; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'id') { $self->id; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'int') { $self->int; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'literal') { $self->literal; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minus') { $self->minus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'minusminus') { $self->minusminus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'num') { $self->num; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'oct') { $self->oct; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'plusplus') { $self->plusplus; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'range') { $self->range; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'rat') { $self->rat; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'sci') { $self->sci; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'str') { $self->str; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub str_hashrocket_expr {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'comma') { return $self->str_hashrocket_expr_comma; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub str_hashrocket_expr_comma {
    my ($self) = @_;

    my $has = [];
    foreach (1..4) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'hashkey',
        'has'  => $has,
        ) );
    return 1;
}

sub until {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'condition') { return $self->until_condition; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub until_condition {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'array') { return $self->until_condition_array; }
    if ($token->name eq 'embraces') { $self->embraces; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'lbrace') { $self->lbrace; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub until_condition_array {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'loop',
        'has'  => $has,
        ) );
    return 1;
}

sub while {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'condition') { return $self->while_condition; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub while_condition {
    my ($self) = @_;
    my $token = $lexer->next;
    $self->push($token);

    while ($token->name eq 'space') {
        $self->pop;
        $token = $lexer->next;
        $self->push($token);
    }

  AGAIN:
    if ($token->name eq 'array') { return $self->while_condition_array; }
    if ($token->name eq 'embraces') { $self->embraces; $token = $self->top; goto AGAIN; }
    if ($token->name eq 'lbrace') { $self->lbrace; $token = $self->top; goto AGAIN; }
    die "Unexpected $token->{name} at line $lexer->{line}, column $lexer->{column}";
}

sub while_condition_array {
    my ($self) = @_;

    my $has = [];
    foreach (1..3) {
        my $thing = $self->pop;
        next if ref $thing->{has} ne 'ARRAY';
        if ( scalar @{ $thing->{has} } == 1 ) { push @{ $has }, $thing->{has}[0]; }
        else { push @{$has}, $thing; }
    }

    $self->push( Kent::Token->new(
        'name' => 'loop',
        'has'  => $has,
        ) );
    return 1;
}

1;
