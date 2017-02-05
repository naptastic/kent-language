package Kent::Util;

use common::sense;
use JSON;

sub dump {
    my ( $structure ) = @_;
    my $printer = JSON->new->pretty->allow_blessed->convert_blessed( 1 )->canonical( 1 );
    return $printer->encode( $structure );
}

sub slurp {
    my ( $filename ) = @_;
    local $/;

    open( my $fh, '<', $filename ) or die "Couldn't open $filename for reading: $!";
    my $data = <$fh>;
    close $fh;

    return $data;
}
1;
