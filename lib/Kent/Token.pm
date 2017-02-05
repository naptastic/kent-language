package Kent::Token;
use common::sense;

use Kent::Lexer::Rules    ();
use Kent::Lexer::Keywords ();
use Kent::Util            ();

my $rule_table = Kent::Lexer::Rules::table;
my @keywords   = @Kent::Lexer::Keywords::keywords;

#
# XXX: Don't make subclasses of this. It would break the lexer, or require
# the creation of logic that would grow organically into an incomprehensible
# mess.
#

sub new {
    my ( $class, %args ) = @_;

    my $self = { 'name'         => $args{name},
                 'raw'          => $args{raw},
                 'width'        => length( $args{raw} ), #XXX: This is currently wrong for opening and closing quotes.
                 'line'         => $args{line},
                 'column'       => $args{column},
                 'next_context' => $args{next_context},
                 'has'          => $args{has} // [] };
                 # XXX Does 'next_context' actually need to be stored here?

    return bless $self, $class;
}

sub has    { $_[0]->{has}; }
sub name   { $_[0]->{name}; }
sub width  { $_[0]->{width}; }
sub raw    { $_[0]->{raw}; }
sub line   { $_[0]->{line}; }
sub column { $_[0]->{line}; }

sub TO_JSON {
    my ( $self ) = @_;
    return { 'name'   => $self->{name},
             'width'  => $self->{width},
             'line'   => $self->{line},
             'column' => $self->{column},
             'has'    => $self->{has} };
}

1;
