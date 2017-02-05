package Kent::Parser::States;

sub access {
    return Kent::Token->new( { 'name' => 'fqid' } );
}

sub annotated {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'comment') { return $self->annotated_comment; }
    if ($token->name eq 'space') { return $self->annotated_space; }
    if ($token->name eq 'lcmt') { $token = $self->lcmt; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub annotated_comment {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->shift;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'annotated',
          'has'  => \@has, }
        );
}

sub annotated_space {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->shift;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'statement',
          'has'  => \@has, }
        );
}

sub array {
    return Kent::Token->new( { 'name' => 'statement' } );
}

sub bang {
    my ($self) = @_;
    $token = $self->lexer->next;
    if ($token->name eq 'fqid') { return $self->bang_fqid; }

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub bang_fqid {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->shift;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'expr',
          'has'  => \@has, }
        );
}

sub branch {
    return Kent::Token->new( { 'name' => 'statement' } );
}

sub char {
    my ($self) = @_;
    $token = $self->lexer->next;
    if ($token->name eq 'char') { return $self->char_char; }

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub char_char {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->shift;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'char',
          'has'  => \@has, }
        );
}

sub code {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'eof') { return $self->code_eof; }
    if ($token->name eq 'statement') { return $self->code_statement; }
    if ($token->name eq 'annotated') { $token = $self->annotated; goto AGAIN; }
    if ($token->name eq 'array') { $token = $self->array; goto AGAIN; }
    if ($token->name eq 'branch') { $token = $self->branch; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'loop') { $token = $self->loop; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub code_eof {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->shift;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'file',
          'has'  => \@has, }
        );
}

sub code_statement {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'eof') { return $self->code_statement_eof; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub code_statement_eof {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'file',
          'has'  => \@has, }
        );
}

sub comment {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'annotated') { return $self->comment_annotated; }
    if ($token->name eq 'statement') { return $self->comment_statement; }
    if ($token->name eq 'annotated') { $token = $self->annotated; goto AGAIN; }
    if ($token->name eq 'array') { $token = $self->array; goto AGAIN; }
    if ($token->name eq 'branch') { $token = $self->branch; goto AGAIN; }
    if ($token->name eq 'comment') { $token = $self->comment; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'loop') { $token = $self->loop; goto AGAIN; }
    if ($token->name eq 'statement') { $token = $self->statement; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub comment_annotated {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->shift;
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
        my $thing = $self->shift;
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
    $token = $self->lexer->next;
    if ($token->name eq 'fqid') { return $self->dot_fqid; }
    if ($token->name eq 'lbrace') { return $self->dot_lbrace; }

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'space') { return $self->dot_space; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub dot_fqid {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'id') { return $self->dot_lbrace_id; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub dot_lbrace_id {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'rbrace') { return $self->dot_lbrace_id_rbrace; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub dot_lbrace_id_rbrace {
    my ($self) = @_;

    my @has;
    foreach (1..4) {
        my $thing = $self->shift;
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
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->element_expr; }
    if ($token->name eq 'statement') { return $self->element_statement; }
    if ($token->name eq 'annotated') { $token = $self->annotated; goto AGAIN; }
    if ($token->name eq 'array') { $token = $self->array; goto AGAIN; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'branch') { $token = $self->branch; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'loop') { $token = $self->loop; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub element_expr {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'comma') { return $self->element_expr_comma; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub element_expr_comma {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'comma') { return $self->element_statement_comma; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub element_statement_comma {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'codeblock') { return $self->else_codeblock; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub else_codeblock {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'cond') { return $self->elseif_cond; }
    if ($token->name eq 'fqid') { return $self->elseif_fqid; }
    if ($token->name eq 'access') { $token = $self->access; goto AGAIN; }
    if ($token->name eq 'dot') { $token = $self->dot; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'id') { $token = $self->id; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub elseif_cond {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'codeblock') { return $self->elseif_cond_codeblock; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub elseif_cond_codeblock {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'codeblock') { return $self->elseif_fqid_codeblock; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub elseif_fqid_codeblock {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'hashrocket') { return $self->elseif_fqid_codeblock_hashrocket; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub elseif_fqid_codeblock_hashrocket {
    my ($self) = @_;

    my @has;
    foreach (1..4) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'elseif') { return $self->elseifblock_elseif; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub elseifblock_elseif {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'cond') { return $self->elseifblock_elseif_cond; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub elseifblock_elseif_cond {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'codeblock') { return $self->elseifblock_elseif_cond_codeblock; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub elseifblock_elseif_cond_codeblock {
    my ($self) = @_;

    my @has;
    foreach (1..4) {
        my $thing = $self->shift;
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

sub expr {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

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
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub expr_binand {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_binand_expr; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub expr_binand_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_binor_expr; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub expr_binor_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_binxor_expr; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub expr_binxor_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_eqeq_expr; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub expr_eqeq_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_fslash_expr; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub expr_fslash_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_gt_expr; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub expr_gt_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_logand_expr; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub expr_logand_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_logor_expr; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub expr_logor_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_logxor_expr; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub expr_logxor_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_lt_expr; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub expr_lt_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_match_expr; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub expr_match_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_minus_expr; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub expr_minus_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_ne_expr; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub expr_ne_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_ngt_expr; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub expr_ngt_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_nlt_expr; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub expr_nlt_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_nomatch_expr; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub expr_nomatch_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_percent_expr; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub expr_percent_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_plus_expr; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub expr_plus_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_shl_expr; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub expr_shl_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_shr_expr; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub expr_shr_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_star_expr; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub expr_star_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->expr_starstar_expr; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub expr_starstar_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'fqid') { return $self->for_fqid; }
    if ($token->name eq 'id') { return $self->for_id; }
    if ($token->name eq 'range') { return $self->for_range; }
    if ($token->name eq 'access') { $token = $self->access; goto AGAIN; }
    if ($token->name eq 'dot') { $token = $self->dot; goto AGAIN; }
    if ($token->name eq 'id') { $token = $self->id; goto AGAIN; }
    if ($token->name eq 'int') { $token = $self->int; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub for_fqid {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'codeblock') { return $self->for_fqid_codeblock; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub for_fqid_codeblock {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'in') { return $self->for_id_in; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub for_id_in {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'fqid') { return $self->for_id_in_fqid; }
    if ($token->name eq 'range') { return $self->for_id_in_range; }
    if ($token->name eq 'access') { $token = $self->access; goto AGAIN; }
    if ($token->name eq 'dot') { $token = $self->dot; goto AGAIN; }
    if ($token->name eq 'id') { $token = $self->id; goto AGAIN; }
    if ($token->name eq 'int') { $token = $self->int; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub for_id_in_fqid {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'array') { return $self->for_id_in_fqid_array; }
    if ($token->name eq 'embraces') { $token = $self->embraces; goto AGAIN; }
    if ($token->name eq 'lbrace') { $token = $self->lbrace; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub for_id_in_fqid_array {
    my ($self) = @_;

    my @has;
    foreach (1..5) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'array') { return $self->for_id_in_range_array; }
    if ($token->name eq 'embraces') { $token = $self->embraces; goto AGAIN; }
    if ($token->name eq 'lbrace') { $token = $self->lbrace; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub for_id_in_range_array {
    my ($self) = @_;

    my @has;
    foreach (1..5) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'array') { return $self->for_range_array; }
    if ($token->name eq 'embraces') { $token = $self->embraces; goto AGAIN; }
    if ($token->name eq 'lbrace') { $token = $self->lbrace; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub for_range_array {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;
    if ($token->name eq 'minusminus') { return $self->fqid_minusminus; }
    if ($token->name eq 'plusplus') { return $self->fqid_plusplus; }

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'arglist') { return $self->fqid_arglist; }
    if ($token->name eq 'compose') { return $self->fqid_compose; }
    if ($token->name eq 'emparens') { return $self->fqid_emparens; }
    if ($token->name eq 'eq') { return $self->fqid_eq; }
    if ($token->name eq 'parenexpr') { return $self->fqid_parenexpr; }
    if ($token->name eq 'space') { return $self->fqid_space; }
    if ($token->name eq 'lparen') { $token = $self->lparen; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub fqid_minusminus {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->shift;
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
        my $thing = $self->shift;
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
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'array') { return $self->fqid_compose_array; }
    if ($token->name eq 'fqid') { return $self->fqid_compose_fqid; }
    if ($token->name eq 'function') { return $self->fqid_compose_function; }
    if ($token->name eq 'hash') { return $self->fqid_compose_hash; }
    if ($token->name eq 'num') { return $self->fqid_compose_num; }
    if ($token->name eq 'str') { return $self->fqid_compose_str; }
    if ($token->name eq 'access') { $token = $self->access; goto AGAIN; }
    if ($token->name eq 'dot') { $token = $self->dot; goto AGAIN; }
    if ($token->name eq 'embraces') { $token = $self->embraces; goto AGAIN; }
    if ($token->name eq 'emcurlies') { $token = $self->emcurlies; goto AGAIN; }
    if ($token->name eq 'hex') { $token = $self->hex; goto AGAIN; }
    if ($token->name eq 'id') { $token = $self->id; goto AGAIN; }
    if ($token->name eq 'int') { $token = $self->int; goto AGAIN; }
    if ($token->name eq 'lbrace') { $token = $self->lbrace; goto AGAIN; }
    if ($token->name eq 'lcurly') { $token = $self->lcurly; goto AGAIN; }
    if ($token->name eq 'oct') { $token = $self->oct; goto AGAIN; }
    if ($token->name eq 'rat') { $token = $self->rat; goto AGAIN; }
    if ($token->name eq 'sci') { $token = $self->sci; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub fqid_compose_array {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
        my $thing = $self->shift;
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
        my $thing = $self->shift;
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
        my $thing = $self->shift;
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
        my $thing = $self->shift;
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
        my $thing = $self->shift;
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
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->fqid_eq_expr; }
    if ($token->name eq 'fqid') { return $self->fqid_eq_fqid; }
    if ($token->name eq 'access') { $token = $self->access; goto AGAIN; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'dot') { $token = $self->dot; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'id') { $token = $self->id; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub fqid_eq_expr {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
        my $thing = $self->shift;
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
        my $thing = $self->shift;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'statement',
          'has'  => \@has, }
        );
}

sub fqid_space {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->shift;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'expr',
          'has'  => \@has, }
        );
}

sub hashkey {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'comma') { return $self->hashkey_comma; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub hashkey_comma {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'str') { return $self->hashkey_comma_str; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub hashkey_comma_str {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'hashrocket') { return $self->hashkey_comma_str_hashrocket; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub hashkey_comma_str_hashrocket {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->hashkey_comma_str_hashrocket_expr; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub hashkey_comma_str_hashrocket_expr {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'comma') { return $self->hashkey_comma_str_hashrocket_expr_comma; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub hashkey_comma_str_hashrocket_expr_comma {
    my ($self) = @_;

    my @has;
    foreach (1..6) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;
    if ($token->name eq 'dotdot') { return $self->id_dotdot; }

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'space') { return $self->id_space; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub id_dotdot {
    my ($self) = @_;
    $token = $self->lexer->next;
    if ($token->name eq 'id') { return $self->id_dotdot_id; }
    if ($token->name eq 'int') { return $self->id_dotdot_int; }

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub id_dotdot_id {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
        my $thing = $self->shift;
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
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'cond') { return $self->if_cond; }
    if ($token->name eq 'fqid') { return $self->if_fqid; }
    if ($token->name eq 'access') { $token = $self->access; goto AGAIN; }
    if ($token->name eq 'dot') { $token = $self->dot; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'id') { $token = $self->id; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub if_cond {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'codeblock') { return $self->if_cond_codeblock; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub if_cond_codeblock {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'codeblock') { return $self->if_fqid_codeblock; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub if_fqid_codeblock {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'elseblock') { return $self->ifblock_elseblock; }
    if ($token->name eq 'elseifblock') { return $self->ifblock_elseifblock; }
    if ($token->name eq 'space') { return $self->ifblock_space; }
    if ($token->name eq 'else') { $token = $self->else; goto AGAIN; }
    if ($token->name eq 'elseif') { $token = $self->elseif; goto AGAIN; }
    if ($token->name eq 'elseifblock') { $token = $self->elseifblock; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub ifblock_elseblock {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'elseblock') { return $self->ifblock_elseifblock_elseblock; }
    if ($token->name eq 'space') { return $self->ifblock_elseifblock_space; }
    if ($token->name eq 'else') { $token = $self->else; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub ifblock_elseifblock_elseblock {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'branch',
          'has'  => \@has, }
        );
}

sub ifblock_elseifblock_space {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'branch',
          'has'  => \@has, }
        );
}

sub ifblock_space {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;
    if ($token->name eq 'dotdot') { return $self->int_dotdot; }

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'space') { return $self->int_space; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub int_dotdot {
    my ($self) = @_;
    $token = $self->lexer->next;
    if ($token->name eq 'id') { return $self->int_dotdot_id; }
    if ($token->name eq 'int') { return $self->int_dotdot_int; }

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub int_dotdot_id {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
        my $thing = $self->shift;
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
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'element') { return $self->lbrace_element; }
    if ($token->name eq 'expr') { return $self->lbrace_expr; }
    if ($token->name eq 'rbrace') { return $self->lbrace_rbrace; }
    if ($token->name eq 'statement') { return $self->lbrace_statement; }
    if ($token->name eq 'annotated') { $token = $self->annotated; goto AGAIN; }
    if ($token->name eq 'array') { $token = $self->array; goto AGAIN; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'branch') { $token = $self->branch; goto AGAIN; }
    if ($token->name eq 'element') { $token = $self->element; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'loop') { $token = $self->loop; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    if ($token->name eq 'statement') { $token = $self->statement; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub lbrace_element {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->lbrace_element_expr; }
    if ($token->name eq 'rbrace') { return $self->lbrace_element_rbrace; }
    if ($token->name eq 'statement') { return $self->lbrace_element_statement; }
    if ($token->name eq 'annotated') { $token = $self->annotated; goto AGAIN; }
    if ($token->name eq 'array') { $token = $self->array; goto AGAIN; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'branch') { $token = $self->branch; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'loop') { $token = $self->loop; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub lbrace_element_expr {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'rbrace') { return $self->lbrace_element_expr_rbrace; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub lbrace_element_expr_rbrace {
    my ($self) = @_;

    my @has;
    foreach (1..4) {
        my $thing = $self->shift;
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
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'rbrace') { return $self->lbrace_element_statement_rbrace; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub lbrace_element_statement_rbrace {
    my ($self) = @_;

    my @has;
    foreach (1..4) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'rbrace') { return $self->lbrace_expr_rbrace; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub lbrace_expr_rbrace {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'rbrace') { return $self->lbrace_statement_rbrace; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub lbrace_statement_rbrace {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;
    if ($token->name eq 'char') { return $self->lcmt_char; }

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'rcmt') { return $self->lcmt_rcmt; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub lcmt_char {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'rcmt') { return $self->lcmt_char_rcmt; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub lcmt_char_rcmt {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'hashkey') { return $self->lcurly_hashkey; }
    if ($token->name eq 'rcurly') { return $self->lcurly_rcurly; }
    if ($token->name eq 'str') { return $self->lcurly_str; }
    if ($token->name eq 'hashkey') { $token = $self->hashkey; goto AGAIN; }
    if ($token->name eq 'str') { $token = $self->str; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub lcurly_hashkey {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'rcurly') { return $self->lcurly_hashkey_rcurly; }
    if ($token->name eq 'str') { return $self->lcurly_hashkey_str; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub lcurly_hashkey_rcurly {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'hashrocket') { return $self->lcurly_hashkey_str_hashrocket; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub lcurly_hashkey_str_hashrocket {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->lcurly_hashkey_str_hashrocket_expr; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub lcurly_hashkey_str_hashrocket_expr {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'rcurly') { return $self->lcurly_hashkey_str_hashrocket_expr_rcurly; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub lcurly_hashkey_str_hashrocket_expr_rcurly {
    my ($self) = @_;

    my @has;
    foreach (1..6) {
        my $thing = $self->shift;
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
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'hashrocket') { return $self->lcurly_str_hashrocket; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub lcurly_str_hashrocket {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->lcurly_str_hashrocket_expr; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub lcurly_str_hashrocket_expr {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'rcurly') { return $self->lcurly_str_hashrocket_expr_rcurly; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub lcurly_str_hashrocket_expr_rcurly {
    my ($self) = @_;

    my @has;
    foreach (1..5) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->lparen_expr; }
    if ($token->name eq 'rparen') { return $self->lparen_rparen; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub lparen_expr {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'rparen') { return $self->lparen_expr_rparen; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub lparen_expr_rparen {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
        my $thing = $self->shift;
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
    $token = $self->lexer->next;
    if ($token->name eq 'fqid') { return $self->minus_fqid; }

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub minus_fqid {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;
    if ($token->name eq 'fqid') { return $self->minusminus_fqid; }

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub minusminus_fqid {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;
    if ($token->name eq 'fqid') { return $self->plusplus_fqid; }

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub plusplus_fqid {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'comma') { return $self->statement_comma; }
    if ($token->name eq 'comment') { return $self->statement_comment; }
    if ($token->name eq 'eof') { return $self->statement_eof; }
    if ($token->name eq 'lcmt') { $token = $self->lcmt; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub statement_comma {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->shift;
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
        my $thing = $self->shift;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'annotated',
          'has'  => \@has, }
        );
}

sub statement_eof {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->shift;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'file',
          'has'  => \@has, }
        );
}

sub str {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'hashrocket') { return $self->str_hashrocket; }
    if ($token->name eq 'space') { return $self->str_space; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub str_hashrocket {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'expr') { return $self->str_hashrocket_expr; }
    if ($token->name eq 'bang') { $token = $self->bang; goto AGAIN; }
    if ($token->name eq 'expr') { $token = $self->expr; goto AGAIN; }
    if ($token->name eq 'fqid') { $token = $self->fqid; goto AGAIN; }
    if ($token->name eq 'literal') { $token = $self->literal; goto AGAIN; }
    if ($token->name eq 'minus') { $token = $self->minus; goto AGAIN; }
    if ($token->name eq 'minusminus') { $token = $self->minusminus; goto AGAIN; }
    if ($token->name eq 'plusplus') { $token = $self->plusplus; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub str_hashrocket_expr {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'comma') { return $self->str_hashrocket_expr_comma; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub str_hashrocket_expr_comma {
    my ($self) = @_;

    my @has;
    foreach (1..4) {
        my $thing = $self->shift;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'hashkey',
          'has'  => \@has, }
        );
}

sub str_space {
    my ($self) = @_;

    my @has;
    foreach (1..2) {
        my $thing = $self->shift;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'literal',
          'has'  => \@has, }
        );
}

sub until {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'condition') { return $self->until_condition; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub until_condition {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'array') { return $self->until_condition_array; }
    if ($token->name eq 'embraces') { $token = $self->embraces; goto AGAIN; }
    if ($token->name eq 'lbrace') { $token = $self->lbrace; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub until_condition_array {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
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
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'condition') { return $self->while_condition; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub while_condition {
    my ($self) = @_;
    $token = $self->lexer->next;

    while ($token->name eq 'space') { $token = $self->lexer->next; }

  AGAIN:
    if ($token->name eq 'array') { return $self->while_condition_array; }
    if ($token->name eq 'embraces') { $token = $self->embraces; goto AGAIN; }
    if ($token->name eq 'lbrace') { $token = $self->lbrace; goto AGAIN; }
    die "Unexpected $token->name at line $self->lexer->line, column $self->lexer->column";
}

sub while_condition_array {
    my ($self) = @_;

    my @has;
    foreach (1..3) {
        my $thing = $self->shift;
        if ( scalar @{ $thing->{has} } == 1 ) { push @has, $thing->{has}[0]; }
        else { push @has, $thing; }
    }

    return Kent::Token->new(
        { 'name' => 'loop',
          'has'  => \@has, }
        );
}


1;
