package Kent::Parser;

use common::sense;
use Kent::Lexer;
use Kent::Lexer::Rules;
use Kent::Parser::Rules;
use Data::Dumper;

# tidyoff
sub new {
    my ( $class, %args ) = @_;

    return bless { 'stack'      => [],
                   'lexer'      => Kent::Lexer->new(),
                   'tokens'     => $args{tokens},
                   'end_with'   => $args{end_with},
                   'sourcecode' => $args{sourcecode}, }, $class;
}
# tidyon

sub parse {
    my ( $self )   = @_;
    my $sourcecode = $self->{sourcecode};
    my $lexer      = $self->{lexer};
    my $lexrules   = $self->{lexrules};

    # my $matched = 0;

    my $lexrules = Kent::Lexer::Rules::table( Kent::Lexer::Rules::code_rules );

#    foreach (1..10) {
    while ( 1 ) {
#    while (length $sourcecode) {

        # unless ($matched) { $lexer->next( $lexrules, \$sourcecode ) }
        my $next_token = $lexer->next( $lexrules, \$sourcecode )
            or die '$lexer->next returned false. Something is wrong.';
        $self->push( $next_token );

        say "[$next_token->{line}, $next_token->{column}] $next_token->{name} ($next_token->{next_context})";

        # This is disgusting and wasteful.
        if ( $next_token->{next_context} eq 'code' ) {
            $lexrules = Kent::Lexer::Rules::table( Kent::Lexer::Rules::code_rules );
        }
        elsif ( $next_token->{next_context} eq 'comment' ) {
            $lexrules = Kent::Lexer::Rules::table( Kent::Lexer::Rules::comment_rules );
        }
        elsif ( $next_token->{next_context} eq 'nquote' ) {
            my $quote_begin = $next_token->{raw};
            $lexrules = Kent::Lexer::Rules::table( Kent::Lexer::Rules::nquote_rules( $quote_begin ) );
        }
        elsif ( $next_token->{next_context} eq 'iquote' ) {
            my $quote_begin = $next_token->{raw};
            $lexrules = Kent::Lexer::Rules::table( Kent::Lexer::Rules::iquote_rules( $quote_begin ) );
        }
        elsif ( $next_token->{next_context} eq 'eof' ) { return 1; }
        elsif ( $next_token->{next_context} eq 'die' ) {
            die "I don't know why I'm supposed to die";
        }
        else {
            die 'a token defined a next_context I don\'t understand.';
        }

        # $matched = 0;

        my $phrase = $self->join();    # don't wanna do this a hundred times
        say $self->join( q{ } );       # Debugging info

    }
}

sub apply_rule {
    my ($self, $rule) = @_;

    return 1;    
}

sub push {
    my ( $self, $thingy ) = @_;
    unshift @{ $self->{stack} }, $thingy;

    return 1;
}

sub pop {
    my ( $self ) = @_;
    return shift @{ $self->{stack} };
}

sub join {
    my ( $self, $string ) = @_;
    $string // q{};
    return join( $string, reverse map { $_->name } @{ $self->{stack} } );
}

1;
