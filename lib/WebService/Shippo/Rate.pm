use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::Rate;
use base ( 'WebService::Shippo::FetchableResource',
           'WebService::Shippo::ListableResource'
);

sub api_resource {'rates'}

1;
