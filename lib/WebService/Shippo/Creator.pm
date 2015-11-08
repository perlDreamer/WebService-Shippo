use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Creator;
require WebService::Shippo::Request;
use Params::Callbacks ( 'callbacks' );

sub create
{
    my ( $callbacks, $invocant, @params ) = &callbacks;
    my $response = Shippo::Request->post( $invocant->url, @params );
    return $invocant->item_class->construct_from( $response, $callbacks );
}

1;
