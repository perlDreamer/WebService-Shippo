use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Parcel;
use base ( 'WebService::Shippo::CreatableResource',
           'WebService::Shippo::FetchableResource',
           'WebService::Shippo::ListableResource'
);

sub api_resource {'parcels'}

1;
