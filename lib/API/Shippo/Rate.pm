use strict;
use warnings;
use MRO::Compat 'c3';

package API::Shippo::Rate;
use base ( 'API::Shippo::FetchableResource',
           'API::Shippo::ListableResource'
);

sub api_resource {'rates'}

1;
