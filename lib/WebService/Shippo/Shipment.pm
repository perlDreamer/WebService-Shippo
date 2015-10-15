use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Shipment;
use base ( 'WebService::Shippo::CreatableResource',
           'WebService::Shippo::FetchableResource',
           'WebService::Shippo::ListableResource'
);

sub api_resource {'shipments'}

1;
