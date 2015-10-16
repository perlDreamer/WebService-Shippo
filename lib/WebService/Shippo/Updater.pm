use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Updater;
require WebService::Shippo::Request;

sub update
{
    my ( $invocant, $id, $params ) = @_;
    my $response = Shippo::Request->put( $invocant->url( $id ), $params );
    return $invocant->construct_from( $response );
}

1;
