use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::CustomsItem;
use base ( 'WebService::Shippo::CreatableResource',
           'WebService::Shippo::FetchableResource',
           'WebService::Shippo::ListableResource'
);

sub api_resource {'customs/items'}

1;
