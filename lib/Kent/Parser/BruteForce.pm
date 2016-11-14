package Kent::Parser::BruteForce;

use common::sense;
use Kent::Lexer;
use Kent::Lexer::Rules;
use Kent::Tokens;

### XXX: Import some methods and constants from other modules please

sub new {
    my ( $class, %args ) = @_;

    return
        bless { 'stack'      => [],
                'lexer'      => Kent::Lexer->new(),
                'tokens'     => $args{tokens},
                'end_with'   => $args{end_with},
                'sourcecode' => $args{sourcecode},
        }, $class;
}

sub parse {
    my ( $self ) = @_

        my $token = $self->{lexer}->get_next_token( Kent::Lexer::Rules::code_rules );
    my $name = $token->name;

    if    ( $name eq 'CMT_BEGIN' ) { $self->cmt_begin( $token ) }
    elsif ( $name eq 'EOF' )       { $self->exit( 0 ) }
    else                           { $self->throw( $token ) }

    return [];
}

sub throw {
    my ( $self, $token ) = @_;
    my $lexer = $self->{lexer};

    die "Unexpected $token->name at line $token->line, column $token->column.";
}

sub cmt_begin {
    my ( $self, $token ) = @_;
    my $next = $self->{lexer}->get_next_token( Kent::Lexer::Rules::comment_rules );

    if    ( $next->name eq 'CHAR' )    { $self->char( $next ) }
    elsif ( $next->name eq 'CMT_END' ) { return $completed_token }
    else                               { $self->throw( $token ) }
}

sub char {
    my ( $self, $token ) = @_;
    my $next = $self->{lexer}->get_next_token( Kent::Lexer::Rules::comment_rules );

    if   ( $next->name eq 'CHAR' ) { $self->char( $next ) }
    else                           { return $completed_char }
}

1;
