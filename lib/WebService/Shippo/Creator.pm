use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Creator;
require WebService::Shippo::Request;

sub create
{
    my ( $invocant, $params ) = @_;
    my $response = Shippo::Request->post( $invocant->url, $params );
    return $invocant->construct_from( $response );
}

1;
