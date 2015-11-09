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
    return $invocant->item_class->construct_from( $response, $callbacks );
}

BEGIN {
    no warnings 'once';
    *Shippo::Updater:: = *WebService::Shippo::Updater::;
}

1;
