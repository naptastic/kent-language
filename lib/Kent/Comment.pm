package Kent::Comment;
use common::sense;

use Kent::Token;
use base 'Kent::Token';

sub new {
    my ( $class, $stack ) = @_;

    my $cmt_begin = $stack->shift;
    my $guts      = $stack->shift;
    my $cmt_end   = $stack->shift;    # unused right now.

    $guts =~ s/^\s*//;
    $guts =~ s/\s*$//;

    my $self = Kent::Token::new( 'name'   => 'CMT',
                                 'raw'    => $guts,
                                 'line'   => $cmt_begin->line,
                                 'column' => $cmt_begin->column, );

    bless $self, $class;
    return $self;
}

1;
