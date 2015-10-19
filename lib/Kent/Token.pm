package Kent::Token;
use common::sense;

use Kent::Lexer::Rules    ();
use Kent::Lexer::Keywords ();

my $rule_table = Kent::Lexer::Rules::table;
my %keywords   = %Kent::Lexer::Keywords::keywords;

sub new {
    my ( $class, %args ) = @_;

    my $self = {
        'name'   => $args{name},
        'raw'    => $args{raw},
        'line'   => $args{line},
        'column' => $args{column},
    };

    # select * from rules where 'name' = $name limit 1;
    my $rule = ( grep { $_->{name} eq $self->{name} } @$rule_table )[0];

    # Variable-width tokens use 'undef' in the token definition table.
    $self->{width} = $rule->{width};
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
