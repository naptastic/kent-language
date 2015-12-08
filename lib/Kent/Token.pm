package Kent::Token;
use common::sense;

use Kent::Lexer::Rules    ();
use Kent::Lexer::Keywords ();

my $rule_table = Kent::Lexer::Rules::table;
my %keywords   = %Kent::Lexer::Keywords::keywords;

sub new {
    my ( $class, %args ) = @_;

    my $self = { 'name'   => $args{name},
                 'raw'    => $args{raw},
                 'width'  => $args{width},
                 'line'   => $args{line},
                 'column' => $args{column}, };

    # select * from rules where 'name' = $name limit 1;
    my $rule = ( grep { $_->{name} eq $self->{name} } @$rule_table )[0];

    # Variable-width tokens use 'undef' in the token definition table.
    $self->{width} //= $rule->{width} if ref $rule eq 'HASH';
    $self->{width} //= length( $self->{raw} );

    # Is this a keyword?
    if ( $self->{name} eq 'ID' && exists $keywords{ $self->{raw} } ) {
        $self->{name} = "KW_$self->{raw}";
    }

    return bless $self, $class;
}

sub name   { $_[0]->{name}; }
sub width  { $_[0]->{width}; }
sub raw    { $_[0]->{raw}; }
sub line   { $_[0]->{line}; }
sub column { $_[0]->{line}; }

1;
