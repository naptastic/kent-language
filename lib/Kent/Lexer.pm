package Kent::Lexer;

use Kent::Lexer::Keywords ();
use Kent::Lexer::Rules    ();
use Kent::Token           ();
use Kent::Util            ();
use common::sense;

my @keywords     = @Kent::Lexer::Keywords;
my $file_is_over = 0;

# sourcecode:   a string to tokenize. You should probably load the whole file.
# context:      the name of the set of rules for the lexer to use.
# ending_token: When this token is found, ... aw, shit.
sub new {
    my ( $class, $sourcecode ) = @_;

    my $self = { sourcecode => $sourcecode,
                 tokens     => [],
                 line       => 1,
                 column     => 1,
                 position   => 0,
                 bookmark   => 0, };

    return bless $self, $class;
}

sub next {
    my ( $self, $rules ) = @_;

    die 'Tried to read past end of file' if $file_is_over;

    $rules //= Kent::Lexer::Rules::table( Kent::Lexer::Rules::code_rules );

    foreach my $rule ( @{$rules} ) {

        if ( ref $rule->{regex} eq 'Regexp' ) {
            if ( $self->{sourcecode} =~ s/$rule->{regex}// ) {
                return $self->_make_token( $rule, $1 );
            }
        }
        else {
            if ( $self->{sourcecode} =~ s/^\Q$rule->{regex}\E// ) {
                return $self->_make_token( $rule, $rule->{regex} );
            }
        }
    }

    die "Unrecognized input at line $self->{line} column $self->{column}.";
}

sub _make_token {
    my ( $self, $rule, $raw ) = @_;

    my $newtoken = Kent::Token->new( name         => $rule->{name},
                                     raw          => $raw,
                                     line         => $self->{line},
                                     column       => $self->{column},
                                     next_context => $rule->{next_context}, );

    if ( grep { $_ eq $raw } @keywords ) {
        $newtoken->{name} = $raw;
    }

    if ( $newtoken->name eq 'newline' ) {

        # It doesn't matter to combine multiple 'space' tokens since states
        # that discard whitespace will continue throwing away tokens until
        # they find something that isn't some kind of 'space'.
        $newtoken->{name} = 'space';
        $self->{line}++;
        $self->{column} = 1;
    }
    elsif ( $newtoken->name eq 'eof' ) {
        $file_is_over = 1;
    }
    else {
        $self->{column} += $newtoken->width;
    }

    return $newtoken;
}

1;
