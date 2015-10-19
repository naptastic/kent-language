package Kent::Token;
use common::sense;

use Kent::Lexer::Rules    ();
use Kent::Lexer::Keywords ();

my $rules    = Kent::Lexer::Rules::table;
my %keywords = %Kent::Lexer::Keywords::keywords;

sub new {
    my ( $class, %args ) = @_;

    my $self = {
        'name'   => $args{name},
        'raw'    => $args{raw},
        'line'   => $args{line},
        'column' => $args{column},
    };

    # Variable-width tokens use 'undef' in the token definition table.
    $self->{width} = $rules->{ $self->{name} }{width};
    $self->{width} //= length( $self->{raw} );

    # Is this a keyword?
    if ( $self->{name} eq 'ID' && exists $keywords{ $self->{raw} } ) {
        $self->{name} = "KW_$self->{raw}";
    }

    return bless $self, $class;
}

sub name {
    my ($self) = @_;
    return $self->{name};
}

sub width {
    my ($self) = @_;
    return $self->{width};
}

1;
