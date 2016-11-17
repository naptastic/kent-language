package Kent::Parser::BruteForce;

use common::sense;
use Kent::Lexer;
use Kent::Lexer::Rules;
use Kent::Token;

### XXX: Import some methods and constants from other modules please
my $code_rules    = Kent::Lexer::Rules::table( Kent::Lexer::Rules::code_rules );
my $comment_rules = Kent::Lexer::Rules::table( Kent::Lexer::Rules::comment_rules );

sub new {
    my ( $class, %args ) = @_;

    return
        bless { 'stack'      => [],
                'lexer'      => Kent::Lexer->new( $args{sourcecode} ),
                'tokens'     => $args{tokens},
                'end_with'   => $args{end_with},
                'sourcecode' => $args{sourcecode},
        }, $class;
}

sub parse {
    my ( $self ) = @_;

    my $token = $self->{lexer}->next( $code_rules );

    $self->push( $token );

    my $name = $token->name;

    if    ( $name eq 'CMT_BEGIN' ) { $self->comment_begin }
    elsif ( $name eq 'EOF' )       { return $self->{stack}; }
    else                           { $self->throw( $token ) }

    return $self->{stack};
}

sub throw {
    my ( $self, $token ) = @_;
    my $lexer = $self->{lexer};

    die "Unexpected $token->name at line $token->line, column $token->column.";
}

sub lexer { $_[0]->{lexer} }
sub push  { push @{ $_[0]->{stack} }, $_[1]; }
sub pop   { return pop @{ $_[0]->{stack} }; }

# ===========================================================================
# Begin State Table
# aka madness
# ===========================================================================

# This was a bad example.
# ( expr ) can be an expression in parenthesis, or an argument list.
# How to handle what can be both? idk. Do something else for now.

# sub lparen {
#     my ($self) = @_;
# 
#     my $next = $self->lexer->next( $code_rules );
#     $self->push( $next );
# 
#     if ( $next->name eq 'whitespace' ) { $self->pop; $next = $self->lexer->next( $code_rules ) }
#     if ( $next->name eq 'expr' ) { $self->lparen_expr; }
#     if ( $next->name eq 'arg' ) { $self->lparen_arg; }
# }
# 
# sub lparen_expr {
#     my ($self) = @_;
# 
#     # Or start over if $ret is 0
#     return $ret - 1;
# }
# 
# sub lparen_expr_rparen {
#     my ($self) = @_;
# 
#     return 3;
# }

# ===========================================================================
# Whitespace
# aka madness
# ===========================================================================
sub whitespace {
    my ( $self ) = @_;
}

# ===========================================================================
# Comment stuff
# Actually makes sense
# ===========================================================================
sub comment_begin {
    my ( $self ) = @_;

    my $next = $self->lexer->next( $comment_rules );

    $self->push( $next );

    if    ( $next->name eq 'CHAR' )    { $self->comment_char; }
    elsif ( $next->name eq 'CMT_END' ) { $self->comment; }
    return 1;
}

sub comment_char {
    my ( $self ) = @_;

    my $next = $self->lexer->next( $comment_rules );
    $self->push( $next );

    if    ( $next->name eq 'CHAR' )    { $self->comment_char; }
    elsif ( $next->name eq 'CMT_END' ) { $self->comment; }
    return 1;
}

sub comment {
    my ( $self ) = @_;

    my $comment_end = $self->pop;
    my $raw         = $comment_end->raw;
    my $prev        = $self->pop;

    while ( $prev->name eq 'CHAR' ) {
        $raw  = $prev->raw . $raw;
        $prev = $self->pop;
    }

    if ( $prev->name eq 'CMT_BEGIN' ) { $raw = $prev->raw . $raw }

    $self->push(
                 Kent::Token->new( 'name'   => 'comment',
                                   'raw'    => $raw,
                                   'width'  => length $raw,
                                   'line'   => $prev->line,
                                   'column' => $prev->column,
                 ) );
    return 1;
}

1;
