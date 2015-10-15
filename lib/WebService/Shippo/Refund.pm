use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Refund;
use base ( 'WebService::Shippo::CreatableResource',
           'WebService::Shippo::FetchableResource',
           'WebService::Shippo::ListableResource'
);

sub api_resource {'refunds'}

1;
