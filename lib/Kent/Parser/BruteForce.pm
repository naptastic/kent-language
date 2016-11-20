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

# ===========================================================================
# Comment stuff
# Actually makes sense
# ===========================================================================
sub lcomment {
    my ( $self ) = @_;

    my $next = $self->lexer->next( $comment_rules );
    $self->lexer->mode('comment');

    $self->push( $next );

    if    ( $next->name eq 'char' )    { $self->comment_char; }
    elsif ( $next->name eq 'rcomment' ) { $self->comment; }
    return 1;
}

sub lcomment_char {
    my ( $self ) = @_;

    my $next = $self->lexer->next( $comment_rules );
    $self->push( $next );

    if    ( $next->name eq 'char' )    { $self->comment_char; }
    elsif ( $next->name eq 'rcomment' ) { $self->comment_comment_char_comment_end; }
    return 1;
}

sub lcomment_char_rcomment {
    my ( $self ) = @_;

    my $comment_end = $self->pop;
    my $raw         = $comment_end->raw;
    my $prev        = $self->pop;

    while ( $prev->name eq 'char' ) {
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

# ===========================================================================
# Expression Stuff
# Whoooooooo boy
# ===========================================================================

# ===========================================================================
# What starts with id?
# Whoooooooo boy
# ===========================================================================

sub ws {
    my ( $self ) @_;

    my $next = $self->lexer->next( $comment_rules );
    $self->push( $next );

    if ( $next->name eq 'dot' ) { $self->ws_dot; }
    if ( $next->name eq 'id' ) { $self->id; }
}

sub ws_dot {
    my ( $self ) @_;

    my $next = $self->lexer->next_ws( $comment_rules );
    $self->push( $next );

    if ( $next->name eq 'id' ) { $self->id; }
    if ( $next->name eq 'ws' ) { 
        # make a "default object access" token
        # return ???
    }

    return 1;
}
sub id {
    my ( $self ) @_;

    my $next = $self->lexer->next_ws( $code_rules );
    $self->push( $next );

    if ( $next->name eq 'dot' ) { $self->id_dot; }
    if ( $next->name eq 'empty_parens' ) { ... }
    if ( $next->name eq 'plusplus' ) { ... }
    if ( $next->name eq 'minusminus' ) { ... }
}

sub id_dot {
    my ( $self ) @_;

    my $next = $self->lexer->next( $code );
    $self->push( $next );

    if ( $next->name eq 'id' ) { "return access id expression" }
    if ( $next->name eq 'empty_braces' ) { die "null is not an acceptable index"; }
    if ( $next->name eq 'lbrace' ) { $self->id_dot_lbrace; }
    if ( $next->name eq 'lcurly' ) { $self->id_dot_lcurly; }
    if ( $next->name eq 'lbrace' ) { $self->lbrace; } # is this the right thing to do?
}

sub id_dot_lbrace {
    my ( $self ) @_;

    my $next = $self->lexer->next( $code );
    $self->push( $next );

    if ( $next->name eq 'range' ) { $self->id_dot_lbrace_range; }
    if ( $next->name eq 'id' )    { $self->id_dot_lbrace_id; }
    if ( $next->name eq 'int' ) { $self->id_dot_lbrace_int; }

}

sub id_dot_lbrace_range {
    my ( $self ) @_;

    my $next = $self->lexer->next( $code );
    $self->push( $next );
}

sub id_dot_lbrace_int {
    my ( $self ) @_;

    my $next = $self->lexer->next( $code );
    $self->push( $next );
1;
