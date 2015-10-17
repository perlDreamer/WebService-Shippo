use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Fetcher;
require WebService::Shippo::Request;

sub fetch
{
    my ( $invocant, $id, $params ) = @_;
    my $response = Shippo::Request->get( $invocant->url( $id ), $params );
    return $invocant->construct_from( $response );
}

BEGIN {
    no warnings 'once';
    # Allow the use of "retrieve" as an alias for "fetch"
    *retrieve = *fetch;
}

1;
