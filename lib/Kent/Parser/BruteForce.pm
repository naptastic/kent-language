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

    # TODO: Make the stack an object with a push member please
    push @{ $self->{stack} }, $token;

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

sub push { push @{ $self->{stack} }, shift; }

sub pop { return pop @{ $self->{stack} } }

# ===========================================================================
# Begin State Table
# aka madness
# ===========================================================================

sub comment_begin {
    my ( $self ) = @_;

    my $next = $self->{lexer}->next( $comment_rules );

    push @{ $self->{'stack'} }, $next;

    if    ( $next->name eq 'CHAR' )    { $self->comment_char; }
    elsif ( $next->name eq 'CMT_END' ) { $self->comment; }

    return 1;
}

sub comment_char {
    my ( $self ) = @_;

    my $next = $self->{lexer}->next( $comment_rules );
    push @{ $self->{stack} }, $next;

    if    ( $next->name eq 'CHAR' )    { $self->comment_char; }
    elsif ( $next->name eq 'CMT_END' ) { $self->comment; }
    return 1;
}

sub comment {
    my ( $self ) = @_;

    my $comment_end = pop @{ $self->{stack} };

    my $raw = $comment_end->raw;

    my $prev = pop @{ $self->{stack} };

    while ( $prev->name eq 'CHAR' ) {
        $raw  = $prev->raw . $raw;
        $prev = pop @{ $self->{stack} };
    }

    if ( $prev->name eq 'CMT_BEGIN' ) { $raw = $prev->raw . $raw }

    push @{ $self->{stack} },
        Kent::Token->new( 'name'   => 'comment',
                          'raw'    => $raw,
                          'width'  => length $raw,
                          'line'   => $prev->line,
                          'column' => $prev->column, );
    return 1;
}

1;
