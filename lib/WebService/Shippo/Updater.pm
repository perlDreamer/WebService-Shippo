use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Updater;
require WebService::Shippo::Request;
use Params::Callbacks ( 'callbacks' );

sub update
{
    my ( $callbacks, $invocant, $id, @params ) = &callbacks;
    my $response = Shippo::Request->put( $invocant->url( $id ), @params );
    return $invocant->construct_from( $response, $callbacks );
}

1;
