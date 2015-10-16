use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::ReturnShipment;
use base ( 'WebService::Shippo::Shipment' );

sub api_resource {'shipments'}

BEGIN {
    no warnings 'once';
    # Forcing the dev to always use CPAN's perferred "WebService::Shippo"
    # namespace is just cruel; allow the use of "Shippo", too.
    *Shippo::ReturnShipment:: = *WebService::Shippo::ReturnShipment::;
}

1;
