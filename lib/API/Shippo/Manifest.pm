use strict;
use warnings;
use MRO::Compat 'c3';

package API::Shippo::Manifest;
use base ( 'API::Shippo::CreatableResource',
           'API::Shippo::FetchableResource',
           'API::Shippo::ListableResource'
);

sub api_resource {'manifests'}

1;
