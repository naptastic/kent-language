use utf8;
use v5.14;

package Kent::Token;

use strict;
use warnings;

sub new {
    my ( $class, $sourcecode ) = @_;

    my $self = {
        sourcecode => $sourcecode,
        tokens     => [],
        line       => 1,
        column     => 1,
    };

    return bless $self, $class;
}

sub SPACE {
    my ( $self, $raw ) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'SPACE',
        'raw'    => $raw,
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column} += length($raw);
    return 1;
}

sub CRLF {
    my ($self) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'CRLF',
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{line}++;
    $self->{column} = 0;
    return 1;
}

sub ID {
    my ( $self, $raw ) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'ID',
        'raw'    => $raw,
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column} += length($raw);
    return 1;
}

sub OP_ACCESS {
    my ($self) = @_;
    push @{ $self->{tokens} },
      {
        'name'   => 'OP_ACCESS',
        'line'   => $self->{line},
        'column' => $self->{column},
      };
    $self->{column}++;
    return 1;
}

1;
