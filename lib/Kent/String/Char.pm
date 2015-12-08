package Kent::String::Char;
use common::sense;

use Kent::Token;
use base 'Kent::Token';

sub new {
    my ( $class, $stack ) = @_;

    my $new_char = $stack->shift;
    my $old_char = $stack->shift;
    my $raw      = $old_char->raw . $new_car->raw;

    my $self = Kent::Token::new( 'name'   => 'CHAR',
                                 'raw'    => $raw,
                                 'line'   => $old_char->line,
                                 'width'  => $old_char->width,
                                 'column' => $old_char->column, );

    bless $self, $class;
    return $self;
}

1;
