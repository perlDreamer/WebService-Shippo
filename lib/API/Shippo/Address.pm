use strict;
use warnings;
use MRO::Compat 'c3';

package # Hide from PAUSE
    API::Shippo::Address;
use base ( 'API::Shippo::CreatableResource',
           'API::Shippo::FetchableResource',
           'API::Shippo::ListableResource'
);

sub api_resource {'addresses'}

1;
