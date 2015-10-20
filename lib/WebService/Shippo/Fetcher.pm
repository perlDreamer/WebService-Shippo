use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Fetcher;
require WebService::Shippo::Request;
use Params::Callbacks ( 'callbacks' );

sub fetch
{
    my ( $callbacks, $invocant, $id, @params ) = &callbacks;
    my $response = Shippo::Request->get( $invocant->url( $id ), @params );
    return $invocant->construct_from( $response, $callbacks );
}

BEGIN {
    no warnings 'once';
    # Allow the use of "retrieve" as an alias for "fetch"
    *retrieve = *fetch;
}

1;
