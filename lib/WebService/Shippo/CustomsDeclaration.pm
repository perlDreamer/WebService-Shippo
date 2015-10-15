use strict;
use warnings;
use MRO::Compat 'c3';

package WebService::Shippo::CustomsDeclaration;
use base ( 'WebService::Shippo::CreatableResource',
           'WebService::Shippo::FetchableResource',
           'WebService::Shippo::ListableResource'
);

sub api_resource {'customs/declarations'}

1;
